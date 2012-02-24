module DynamicFieldsets
  # Adds dynamic fieldsets to models.
  # The configuration options here determine which fieldset is associated with the model
  # and how it is identified.  The model knows which fieldset it is suppoed to be
  # associated with and where the values for the fieldset are stored.
  module DynamicFieldsetsInModel

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      # Adds a dynamic fieldset to a model
      #
      # Each set of options should be put inside of a hash with the unqiue name for the 
      # fieldset as the key:
      # :child_form => {options}
      # Options:
      # Fieldset: The unique name of the fieldset the class is associated with
      # Multiple: Boolean value to allow multiple answer sets for the same fieldset in the class.
      #   Deafult to false.  Not curently implemented (7-25-2011).
      #
      # @param [Hash] args A hash of arguments for the fieldsets.
      def acts_as_dynamic_fieldset(args)
        mattr_accessor :dynamic_fieldsets unless self.respond_to?(:dynamic_fieldsets)
        self.dynamic_fieldsets = {} unless self.dynamic_fieldsets.is_a?(Hash)

        args.each_pair do |key, value|
          self.dynamic_fieldsets[key] = value
        end

        # hacky system to save fieldset values
        # needs to be refactored and tested
        mattr_accessor :dynamic_fieldset_values unless self.respond_to?(:dynamic_fieldset_values)
        after_save :save_dynamic_fieldsets

        include DynamicFieldsets::DynamicFieldsetsInModel::InstanceMethods
      end
    end

    module InstanceMethods

      # Overrides the ActiveModel Validations run_validations! method
      # It additionally adds validations for the fields that are required
      #
      # I am not sure if this is the correct place to put this.  Seems like a reasonable one.
      #
      # @return [Boolean] The result of run_validations! with the extra errors added, should be true if errors.empty? 
      def run_validations!
        run_dynamic_fieldset_validations!
        super
      end

      # Iterates over the fieldset associator's children and adds errors
      #
      # Will not validate fieldsets that are missing from the dynamic_fieldsets_values hash
      # This means that if the data is not provided by the controller, no checks will be run
      def run_dynamic_fieldset_validations!
        # for each fsa
        self.dynamic_fieldsets.keys.each do |key|
          fsa = self.fieldset_associator(key)
          fsa_tag_id = "fsa-" + fsa.id.to_s

          # check if the values are set, if it matches the current fsa, and if it matches the current fieldset
          if !self.dynamic_fieldset_values.nil? && self.dynamic_fieldset_values.has_key?(fsa_tag_id) && self.dynamic_fieldset_values[fsa_tag_id][:fieldset_model_name] == key
            run_fieldset_child_validations!(fsa.id, fsa.fieldset)
          end
        end
      end
      
      # Checks if a fieldset child is required and adds an error if it's value is blank
      # Adds errors to the self.errors array, does not return them
      #
      # @param [Integer] fsa_id The id for the fieldset associator the child belongs to
      # @param [Field or Fieldset] child The child of the fieldset associator
      def run_fieldset_child_validations!(fsa_id, child)
        if child.is_a?(DynamicFieldsets::Fieldset)
          # if a fieldset, then recurse
          child.children.each do |grand_child|
            run_fieldset_child_validations!(fsa_id, grand_child)
          end
        elsif child.is_a?(DynamicFieldsets::Field)
          # if a child, check if the params value is set, check if it is required, check if it satisfies condition
          fsa_tag_id = "fsa-" + fsa_id.to_s
          field_tag_id = "field-" + child.id.to_s
          if !self.dynamic_fieldset_values[fsa_tag_id].has_key?(field_tag_id)
            self.errors.add(:base, child.label + " is missing from the form data")
          else
            # get the value
            value = self.dynamic_fieldset_values[fsa_tag_id][field_tag_id]
            if child.required?
              # empty works on array or string, so simplifying here
              self.errors.add(:base, child.label + " is required") if value.nil? || value.empty?
            end
          end
        else
          # found a major problem, not sure how to get here
          puts "found a child that wasn't a field or fieldset" + child.inspect
        end
      end
      
      # Stores data from the controller into the dynamic_fieldset_values instance variable
      #
      # @param [Hash] params The parameters from the controller that include fsa tags
      def set_fieldset_values( params )
        values = params.select{ |key| key.match(/^fsa-/) }
        values.keys.each do |key|
          set_date_to_mysql( values[key] )
        end
        self.dynamic_fieldset_values = values
      end
      
      # This turns your date fields into a MySQL-happy single format.  This modifies the hash.
      #
      # This method may cause bugs for servers not using UTC time because of the way rails deals with
      # time conversions.  If the query receives a string instead of a time object, time zone information
      # may be saved incorrectly. (1-25-2012)
      #
      # @param [Hash] post The post parameters that include date fields like date(1i), date(2i), ...
      # @return [Hash] The modified hash containing one key-pair value in YYYY-MM-DD[ hh:mm] format.
      def set_date_to_mysql( post )
        # 'dates' is an array of the "field-ID"s that have multiple date fields of the format field(1i), field(2i), ...
        # e.g. [ "field-4", "field-7" ]
        dates = post.select{ |k| k =~ /\([0-9]i\)/ }.keys.map{ |k| k.gsub /\([0-9]i\)/, '' }.uniq
        dates.each do |field|
          datefield  = ''
          datefield +=          post.delete( "#{field}(1i)" ) # year
          datefield += '-'
          datefield += '%02d' % post.delete( "#{field}(2i)" ) # month
          datefield += '-'
          datefield += '%02d' % post.delete( "#{field}(3i)" ) # day
          if post.keys.include? "#{field}(4i)" then
            datefield += ' '
            datefield += '%02d' % post.delete( "#{field}(4i)" ) # hour
            datefield += ':'
            datefield += '%02d' % post.delete( "#{field}(5i)" ) # minute
            datefield += ':'
            datefield += '00' # second
          end
          # adding the formatted string to the hash to be saved.
          post.merge! field => datefield
        end
        return post
      end
      
      
      # hacky system to save fieldset values
      # needs to be refactored and tested
      #
      # among other things, it can edit field records for random fsas if the wrong information comes from the controller
      def save_dynamic_fieldsets
        values = self.dynamic_fieldset_values
        if !values.nil?
          values.keys.each do |key|
            if key.start_with?("fsa-")
              save_fsa(key, values[key])
            end
          end
        end
        self.dynamic_fieldset_values = nil
      end

      # save all of the fields and fieldsets in the values hash for this fieldset associator
      def save_fsa(key, fsa_values)
        key_id = key.gsub(/^fsa-/, "")

        if key_id.eql? ""
        then fsa = DynamicFieldsets::FieldsetAssociator.create(
          :fieldset_id => fsa_values[:fieldset_id],
          :fieldset_model_id => self.id,
          :fieldset_model_type => self.class.name,
          :fieldset_model_name => fsa_values[:fieldset_model_name] )
        else fsa = DynamicFieldsets::FieldsetAssociator.find_by_id key_id
        end
          
        fsa_values.keys.each do |fieldset_child_key| # EACH FIELD
          if fieldset_child_key.start_with?("field-")
            fieldset_child_id = fieldset_child_key.gsub(/^field-/, "")
            
            this_value = fsa_values[fieldset_child_key]
            if this_value.is_a? Array
            then # multiple values
              save_multiple_records(fsa, fieldset_child_id, this_value)
            else # single value
              save_single_record(fsa, fieldset_child_id, this_value)
            end
          end
        end
      end

      # save a field with multiple field records
      def save_multiple_records(fsa, fieldset_child_id, this_value)
        field_records = DynamicFieldsets::FieldRecord.where(:fieldset_associator_id => fsa.id, :fieldset_child_id => fieldset_child_id)
        
        this_value.each do |value|
          if field_records.select{ |record| record.value.eql? value }.empty? # record does not exist?
            #ADD
            DynamicFieldsets::FieldRecord.create( :fieldset_associator_id => fsa.id,
                                                  :fieldset_child_id => fieldset_child_id,
                                                  :value => value)
          end
        end
        field_records.each do |record|
          if !this_value.include? record.value then
            #DELETE
            record.destroy
          else
            #KEEP
          end
        end
      end

      # save a field with a single field record
      def save_single_record(fsa, fieldset_child_id, this_value)
        # retrieve record
        field_record = DynamicFieldsets::FieldRecord.where(:fieldset_associator_id => fsa.id, :fieldset_child_id => fieldset_child_id).first
        if field_record.nil? # create record
          field_record = DynamicFieldsets::FieldRecord.create(:fieldset_associator_id => fsa.id, :fieldset_child_id => fieldset_child_id, :value => this_value)
        else # update record
          field_record.value = this_value
          field_record.save
        end
      end

      # Matches methods that match named_fieldset and named_fieldset_fieldset
      # Or calls super
      #
      # @param [Symbol] sym The name of the method
      # @param [Array] args The arguments of the method
      # @returns [?] The result of the found method or the result of super
      def method_missing(sym, *args)
        if match_fieldset_associator?(sym)
          return fieldset_associator(sym)
        elsif match_fieldset?(sym)
          return fieldset(sym)
        else
          super(sym, *args)
        end
      end

      # Matches methods that match named_fieldset and named_fieldset_fieldset
      # Or calls super
      #
      # @param [Symbol] sym The name of the method
      # @param [Array] args The arguments of the method
      # @returns [Boolean] True if the method is found or the result of super
      def respond_to?(sym, *args)
        if match_fieldset_associator?(sym)
          return true
        elsif match_fieldset?(sym)
          return true
        else
          super(sym, *args)
        end
      end

      # Returns whether a method name matches a named fieldset
      #
      # @param [Symbol] The name of the method
      # @param [Boolean] Whether the method name matches a named fieldset
      def match_fieldset_associator?(sym)
        return self.dynamic_fieldsets.keys.include?(sym)
      end

      # Returns whether a method name matches a named fieldset followed by '_fieldset'
      #
      # @param [Symbol] The name of the method
      # @param [Boolean] Whether the method name matches a named fieldset
      def match_fieldset?(sym)
        sym_string = sym.to_s
        if !sym_string.match(/_fieldset$/)
          return false
        else
          sym_string.gsub!(/_fieldset$/, "")
          return self.dynamic_fieldsets.keys.include?(sym_string.to_sym)
        end
      end

      # Returns the fieldset associator object for the named fieldset.
      # If one doesn't exist, it creates it and returns it
      #
      # @param [Symbol] The name of the name fieldset
      # @param [FieldsetAssociator] The fieldset associator object for the named fieldset
      def fieldset_associator(sym)
        if match_fieldset_associator?(sym)
          fsa = DynamicFieldsets::FieldsetAssociator.find_by_fieldset_model_parameters(
            :fieldset_model_id => self.id,
            :fieldset_model_type => self.class.name, 
            :fieldset_model_name => sym,
            :fieldset => self.dynamic_fieldsets[sym][:fieldset]).first
          if fsa.nil?
            fsa = DynamicFieldsets::FieldsetAssociator.new(
            :fieldset_model_id => self.id,
            :fieldset_model_type => self.class.name,
            :fieldset_model_name => sym.to_s,
            :fieldset => DynamicFieldsets::Fieldset.find_by_nkey(self.dynamic_fieldsets[sym][:fieldset]))
          end
          return fsa
        else
          return nil
        end
      end

      # Returns the fieldset object for the named fieldset
      #
      # @param [Symbol] The name of the named fieldset
      # @param [Fieldset] The fieldset object for the named fieldset
      def fieldset(sym)
        if match_fieldset_associator?(sym)
          return DynamicFieldsets::Fieldset.find_by_nkey(:nkey => self.dynamic_fieldsets[sym][:fieldset])
        else
          return nil
        end
      end

    end
  end
end
