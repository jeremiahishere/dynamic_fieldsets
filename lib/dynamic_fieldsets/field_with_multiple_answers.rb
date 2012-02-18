module DynamicFieldsets
  module FieldWithMultipleAnswers
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_field_with_multiple_answers(args)
        include DynamicFieldsets::FieldWithOneAnswer::InstanceMethods
      end
    end

    module InstanceMethods

      # @param [Array] values A list of values for the field already saved to the database
      # @return [Array] An array of field option values saved in the db, or the defaults if none are in the db
      def values_or_defaults_for_form(values)
        if values.empty?
          if field.field_Defaults.length == 0
            return []
          else
            return field.field_defaults.collect { |d| d[:value] }
          end
        else
          return values
        end  
      end

      # @return [Array] Alias for field_defaults
      def defaults
        return self.field_defaults if options?
        return nil
      end
    end
  end
end
