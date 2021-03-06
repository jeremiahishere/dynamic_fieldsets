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
      # fieldset (mandatory): The unique name of the fieldset the class is associated with
      # multiple (optional): Boolean value to allow multiple answer sets for the same fieldset in the class.
      #   Deafult to false.  Not curently implemented (7-25-2011).
      # initialize_on_create (optional): Create the fieldste associator after create
      #
      # @param [Hash] args A hash of arguments for the fieldsets.
      def acts_as_dynamic_fieldset(args)
        mattr_accessor :dynamic_fieldsets unless self.respond_to?(:dynamic_fieldsets)
        self.dynamic_fieldsets = {} unless self.dynamic_fieldsets.is_a?(Hash)

        # default values for the arguments
        # fieldset is mandatory
        defaults = {
          :multiple => false,
          :initialize_on_create => false
        }

        args.each_pair do |key, value|
          value_with_defaults = defaults.merge(value)
          self.dynamic_fieldsets[key] = value_with_defaults
        end

        # hacky system to save fieldset values
        # needs to be refactored and tested
        mattr_accessor :dynamic_fieldset_values unless self.respond_to?(:dynamic_fieldset_values)
        after_create :initialize_fieldset_associators
        after_save :save_dynamic_fieldsets

        include DynamicFieldsets::DynamicFieldsetsInModel::InstanceMethods
      end
    end

    module InstanceMethods
      
      # If the fieldset is set to initialize_on_create, then attempt to create the fsa
      def initialize_fieldset_associators
        self.dynamic_fieldsets.each_pair do |key, options|
          if options[:initialize_on_create]
            fsa = fieldset_associator(key)
            fsa.save if fsa.new_record?
          end
        end
      end

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
          fsa_tag_id = DynamicFieldsets.config.form_fieldset_associator_prefix + fsa.id.to_s

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
          fsa_tag_id = DynamicFieldsets.config.form_fieldset_associator_prefix + fsa_id.to_s
          field_tag_id = DynamicFieldsets.config.form_field_prefix + child.id.to_s
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
          throw "found a child that wasn't a field or fieldset" + child.inspect
        end
      end
      
      # Stores data from the controller into the dynamic_fieldset_values instance variable
      # Also combines the date and time fields into a single field
      #
      # @param [Hash] params The parameters from the controller that include fsa tags
      def set_fieldset_values( params )
        values = params.select{ |key| key.match(/^#{DynamicFieldsets.config.form_fieldset_associator_prefix}/) }
        values.keys.each do |key|
          values[key] = set_date_to_mysql( values[key] )
        end
        self.dynamic_fieldset_values = values
      end
      
      # This turns your date fields into a MySQL-happy single format.  This modifies the hash.
      #
      # This method may cause bugs for servers not using UTC time because of the way rails deals with
      # time conversions.  If the query receives a string instead of a time object, time zone information
      # may be saved incorrectly. (1-25-2012)
      #
      # At some point this should be moved to the date_field and datetime_field models.  Right now, it needs
      # to stay here because we are taking the values from the form and iterating over the keys.  This
      # will not work because the date information is stored int 3-5 keys.  We need to change the form
      # data parser to get a list of expected field and iterate over them, looking for the values in the 
      # form post.  That is a big change that we don't have time for now. (JH 2-27-2012)
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
          datefield += '%02d' % post.delete( "#{field}(2i)" ).to_i # month
          datefield += '-'
          datefield += '%02d' % post.delete( "#{field}(3i)" ).to_i # day
          if post.keys.include? "#{field}(4i)" then
            datefield += ' '
            datefield += '%02d' % post.delete( "#{field}(4i)" ).to_i # hour
            datefield += ':'
            datefield += '%02d' % post.delete( "#{field}(5i)" ).to_i # minute
            datefield += ':'
            datefield += '00' # second
          end
          # adding the formatted string to the hash to be saved.
          post.merge! field => datefield
        end
        return post
      end

      # Given the form values, finds the keys that correspond to fieldsets
      # then passes the value for the key to the fieldset associator object for saving into individual field records
      def save_dynamic_fieldsets
        values = self.dynamic_fieldset_values
        if !values.nil?
          values.keys.each do |key|
            if key.start_with?(DynamicFieldsets.config.form_fieldset_associator_prefix)
              save_fsa(key, values[key])
            end
          end
        end
        self.dynamic_fieldset_values = nil
      end

      # save all of the fields and fieldsets in the values hash for this fieldset associator
      #
      # @param [String] The key that includes the fieldset associator's id
      # @param [Hash] fsa_values An array of input information from the form
      def save_fsa(key, fsa_values)
        key_id = key.gsub(/^#{DynamicFieldsets.config.form_fieldset_associator_prefix}/, "")

        if(key_id == "")
          fsa = DynamicFieldsets::FieldsetAssociator.create(
            :fieldset_id => fsa_values[:fieldset_id],
            :fieldset_model_id => self.id,
            :fieldset_model_type => self.class.name,
            :fieldset_model_name => fsa_values[:fieldset_model_name] 
          )
        else 
          fsa = DynamicFieldsets::FieldsetAssociator.find(key_id)
        end

        fsa.update_fieldset_records_with_form_information(fsa_values)
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
            :fieldset_model_name => sym.to_s,
            :fieldset_nkey => self.dynamic_fieldsets[sym][:fieldset].to_s).first
          if fsa.nil?
            fsa = DynamicFieldsets::FieldsetAssociator.new(
            :fieldset_model_id => self.id,
            :fieldset_model_type => self.class.name,
            :fieldset_model_name => sym.to_s,
            :fieldset_id => DynamicFieldsets::Fieldset.where(:nkey => self.dynamic_fieldsets[sym][:fieldset].to_s).first.id)
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
          return DynamicFieldsets::Fieldset.where(:nkey => self.dynamic_fieldsets[sym][:fieldset]).first
        else
          return nil
        end
      end

    end
  end
end
