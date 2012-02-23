module DynamicFieldsets
  module FieldWithOneAnswer
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_field_with_one_answer(args = {})
        include DynamicFieldsets::FieldWithOneAnswer::InstanceMethods
      end
    end

    module InstanceMethods
      # @return [String] Alias for field_defaults.first
      def default
        return self.field_defaults.first
      end

      # @param [String] value A value for the field already saved to the database
      # @return [String] A field option saved in the db, or the default if value is blank
      def value_or_default_for_form(value)
        if value.nil?
          if field.field_Defaults.length == 0
            return ""
          else
            return field.field_defaults.first.value
          end
        else
          return value
        end  
      end
    end
  end
end

