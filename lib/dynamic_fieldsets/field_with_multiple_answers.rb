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
      # Updates the field records for the field based on the given values
      #
      # Manages multiple records
      #
      # @param [DynamicFieldsets::FieldsetAssociator] fsa The associator the value is attached to
      # @param [DynamicFieldsets::FieldsetChild] fieldset_child The fieldset child for the value
      # @param [Array or String] value The new values inputted by the user from the form
      def update_field_records(fsa, fieldset_child, values)
        # make sure values is an array in case the input from the form is bad
        throw "Form value type mismatch error: The value from the form must be Array for #{self.inspect}." unless value.is_a?(Array)
        
        # create new records if the values are not in the db
        values.each do |value|
          if fieldset_child.field_records.select{ |record| record.value.eql? value }.empty?
            DynamicFieldsets::FieldRecord.create!( 
              :fieldset_associator_id => fsa.id,
              :fieldset_child_id => fieldset_child.id,
              :value => value)
          end
        end
      
        # remove records in the db that are not in the input values
        # note that if a record is updated, it is treated as a creation and deletion instead of a single update
        fieldset_child.field_records.each do |record|
          if !values.include?(record.value)
            record.destroy
          end
        end
      end

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
