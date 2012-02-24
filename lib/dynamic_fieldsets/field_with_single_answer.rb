module DynamicFieldsets
  module FieldWithSingleAnswer
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_field_with_single_answer(args = {})
        include DynamicFieldsets::FieldWithSingleAnswer::InstanceMethods
      end
    end

    module InstanceMethods

      # Gets the first field record matching the parameters
      #
      # @param [DynamicFieldsets::FieldsetAssociator] fsa The associator
      # @param [DynamicFieldsets::FieldsetChild] fsc The fieldset child
      # @return [String] The first field record
      def get_values_using_fsa_and_fsc(fsa, fsc)
        collect_field_records_by_fsa_and_fsc(fsa, fsc).first
      end

      # @return [String] Default single answer partial filename
      def show_partial
        "/dynamic_fieldsets/show_partials/show_single_answer"
      end

      # @return [String] Alias for field_defaults.first
      def default
        return self.field_defaults.first
      end

      # @param [String] value A value for the field already saved to the database
      # @return [String] A field option saved in the db, or the default if value is blank
      def value_or_default_for_form(value)
        if value.nil?
          if field_defaults.length == 0
            return ""
          else
            return collect_default_values.first
          end
        else
          return value
        end  
      end
    end
  end
end

