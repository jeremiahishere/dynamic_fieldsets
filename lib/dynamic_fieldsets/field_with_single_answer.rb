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

      # Updates the field records for the field based on the given values
      #
      # Saves or updates a single field record
      #
      # @param [DynamicFieldsets::FieldsetAssociator] fsa The associator the value is attached to
      # @param [DynamicFieldsets::FieldsetChild] fieldset_child The fieldset child for the value
      # @param [Array or String] value The new values inputted by the user from the form
      def update_field_records(fsa, fieldset_child, value)
        # make sure the value is a string in case the input from the form is bad
        value = value.first if value.is_a?(Array)
        # retrieve record
        field_record = DynamicFieldsets::FieldRecord.where(:fieldset_associator_id => fsa.id, :fieldset_child_id => fieldset_child.id).first
        if field_record.nil? 
          # create record
          DynamicFieldsets::FieldRecord.create!(
            :fieldset_associator_id => fsa.id, 
            :fieldset_child_id => fieldset_child.id, 
            :value => value)
        else 
          # update record
          field_record.value = value 
          field_record.save
        end
      end

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

