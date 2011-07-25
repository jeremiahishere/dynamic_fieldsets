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

        include DynamicFieldsets::DynamicFieldsetsInModel::InstanceMethods
      end
    end

    module InstanceMethods

      # Matches methods that match named_fieldset and named_fieldset_fieldset
      # Or calls super
      #
      # @param [Symbol] sym The name of the method
      # @param [Array] args The arguments of the method
      # @returns [?] The result of the found method or the result of super
      def method_missing(sym, *args)
        super(sym, *args)
        # if matches a form_name
        #   get the form associator
        # if matchs form_name_fieldset
        #   get the fieldset
        # call super
      end

      # Matches methods that match named_fieldset and named_fieldset_fieldset
      # Or calls super
      #
      # @param [Symbol] sym The name of the method
      # @param [Array] args The arguments of the method
      # @returns [Boolean] True if the method is found or the result of super
      def respond_to?(sym, *args)
        # if it matches form_name or form_name_fieldset
        #   return true
        # call super
        super(sym, *args)
      end

      # Returns whether a method name matches a named fieldset
      #
      # @param [Symbol] The name of the method
      # @param [Boolean] Whether the method name matches a named fieldset
      def match_fieldset_associator?(sym)
      end

      # Returns whether a method name matches a named fieldset followed by '_fieldset'
      #
      # @param [Symbol] The name of the method
      # @param [Boolean] Whether the method name matches a named fieldset
      def match_fieldset?(sym)
      end

      # Returns the fieldset associator object for the named fieldset
      #
      # @param [Symbol] The name of the name fieldset
      # @param [FieldsetAssociator] The fieldset associator object for the named fieldset
      def fieldset_associator(sym)
      end

      # Returns the fieldset object for the named fieldset
      #
      # @param [Symbol] The name of the named fieldset
      # @param [Fieldset] The fieldset object for the named fieldset
      def fieldset(sym)
      end

    end
  end
end
