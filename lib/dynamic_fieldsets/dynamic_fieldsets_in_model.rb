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
      
      # hacky system to save fieldset values
      # needs to be refactored and tested
      #
      # among other things, it can edit field records for random fsas if the wrong information comes from the controller
      def save_dynamic_fieldsets
        self.dynamic_fieldset_values.keys.each do |key|
          if key.match(/^fsa-/)
            key_id = key.gsub(/^fsa-/, "")
            fsa = DynamicFieldsets::FieldsetAssociator.find_by_id(key_id)
            self.dynamic_fieldset_values[key].keys do |sub_key|
              if sub_key.match(/^field-/)
                sub_key_id = sub_key.gsub(/^field-/, "")
                field_record = DynamicFieldsets::FieldRecord.where(:fieldset_associator_id => fsa.id, :field_id => sub_key_id).first
                if field_record.nil?
                  field_record = DynamicFieldsets::FieldRecord.create(:fieldset_associator_id => fsa.id, :field_id => sub_key_id, :value => params[key][sub_key])
                else
                  field_record.value = params[key][sub_key]
                  field_record.save
                end
              end
            end
          end
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
