module DynamicFieldsets
  # Adds methods to a model extending DynamicFieldsets::Field so that it works with field options
  # when saving and accessing data
  module FieldWithFieldOptions
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_field_with_field_options(args = {})
        validate :has_field_options
        include DynamicFieldsets::FieldWithFieldOptions::InstanceMethods
      end
    end

    module InstanceMethods

      # validation for field options
      def has_field_options
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

