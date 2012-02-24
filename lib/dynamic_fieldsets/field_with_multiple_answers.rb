module DynamicFieldsets
  module FieldWithMultipleAnswers
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_field_with_multiple_answers(args = {})
        include DynamicFieldsets::FieldWithMultipleAnswers::InstanceMethods
      end
    end

    module InstanceMethods

      # Gets the first field record matching the parameters
      #
      # @param [DynamicFieldsets::FieldsetAssociator] fsa The associator
      # @param [DynamicFieldsets::FieldsetChild] fsc The fieldset child
      # @return [Array] An array of field records
      def get_values_using_fsa_and_fsc(fsa, fsc)
        collect_field_records_by_fsa_and_fsc(fsa, fsc)
      end

      # @return [String] Default multiple answer partial filename
      def show_partial
        "/dynamic_fieldsets/show_partials/show_multiple_answers"
      end

      # @param [Array] values A list of values for the field already saved to the database
      # @return [Array] An array of field option values saved in the db, or the defaults if none are in the db
      def values_or_defaults_for_form(values)
        if values.nil? || values.empty?
          if field_defaults.length == 0
            return []
          else
            return collect_default_values
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
