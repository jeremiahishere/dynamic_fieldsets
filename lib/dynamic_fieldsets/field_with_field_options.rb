module DynamicFieldsets
  # Adds methods to a model extending DynamicFieldsets::Field so that it works with field options
  # when saving and accessing data
  module FieldWithFieldOptions
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_field_with_field_options(args = {})
        validate :at_least_one_field_option
        include DynamicFieldsets::FieldWithFieldOptions::InstanceMethods
      end
    end

    module InstanceMethods

      def uses_field_options?
        true
      end

      # validation for field options
      def at_least_one_field_option
        if self.field_options.empty?
          self.errors.add(:field_options, "This field must have options")
        end
      end
      
      # @return [FieldOptions] Returns all field options that are enabled
      def options
        return self.field_options.reject{ |option| !option.enabled }
      end
    end
  end
end

