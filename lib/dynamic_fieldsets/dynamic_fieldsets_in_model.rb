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

      # Runs the dynamic fieldset validations for required fields and adds them to the errors array
      # 
      # finish stubbing out method later
      def run_dynamic_fieldset_validations!
        # iterate over fynamic_fieldset_values
        # if the field of the fieldset child is required
        #   and the field has a blank/nil value
        #     add an error for that field
        puts "Running dynamic fieldset validations"
      end
      
      # Stores the dynamic fieldset values
      def set_fieldset_values( params )
        self.dynamic_fieldset_values = params.select{ |key| key.match(/^fsa-/) }
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
              key_id = key.gsub(/^fsa-/, "")
              fsa = DynamicFieldsets::FieldsetAssociator.find_by_id(key_id)
              
              # SAVE DATES
              # 'dates' is an array of the "field-ID"s that have multiple date fields of the format field(1i), field(2i), ...
              dates = values[key].select{ |k| k =~ /\([0-9]i\)/ }.keys.map{ |k| k.gsub /\([0-9]i\)/, '' }.uniq
              
              # deleting the date segments from the hash, while building a YYYY-MM-DD HH:MM string.
              dates.each do |field|
                datefield  = ''
                datefield +=          values[key].delete( "#{field}(1i)" ) # year
                datefield += '-'
                datefield += '%02d' % values[key].delete( "#{field}(2i)" ) # month
                datefield += '-'
                datefield += '%02d' % values[key].delete( "#{field}(3i)" ) # day
                if values[key].keys.include? "#{field}(4i)" then
                  datefield += ' '
                  datefield += '%02d' % values[key].delete( "#{field}(4i)" ) # hour
                  datefield += ':'
                  datefield += '%02d' % values[key].delete( "#{field}(5i)" ) # minute
                  datefield += ':'
                  datefield += '00' # second
                end
                # adding the formatted string to the hash to be saved.
                values[key].merge! field => datefield
              end
                
              values[key].keys.each do |sub_key| # EACH FIELD
                if sub_key.start_with?("field-")
                  sub_key_id = sub_key.gsub(/^field-/, "")
                  
                  this_value = values[key][sub_key]
                  if this_value.is_a? Array
                  then # multiple values
                    field_records = DynamicFieldsets::FieldRecord.where(:fieldset_associator_id => fsa.id, :fieldset_child_id => sub_key_id)
                    
                    this_value.each do |value|
                      if field_records.select{ |record| record.value.eql? value }.empty? # record does not exist?
                        #ADD
                        DynamicFieldsets::FieldRecord.create( :fieldset_associator_id => fsa.id,
                                                              :fieldset_child_id => sub_key_id,
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
                    
                  else # single value
                    # retrieve record
                    field_record = DynamicFieldsets::FieldRecord.where(:fieldset_associator_id => fsa.id, :fieldset_child_id => sub_key_id).first
                    if field_record.nil? # create record
                      field_record = DynamicFieldsets::FieldRecord.create(:fieldset_associator_id => fsa.id, :fieldset_child_id => sub_key_id, :value => this_value)
                    else # update record
                      field_record.value = this_value
                      field_record.save
                    end
                  end
                  
                end
              end
            end
          end
        end
        self.dynamic_fieldset_values = nil
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
            fsa = DynamicFieldsets::FieldsetAssociator.create(
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
