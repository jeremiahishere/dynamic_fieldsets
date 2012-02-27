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
      
      # Collects the field records for the field so they can be used on the front end
      # These are only the currently saved values in the database, don't worry 
      # about defaults here
      #
      # Converts the ids into field option names for :name part of the return hash
      #
      # @return [Array] An array of field record values
      def collect_field_records_by_fsa_and_fsc(fsa, fsc)
        records = DynamicFieldsets::FieldRecord.where(:fieldset_associator_id => fsa.id, :fieldset_child_id => fsc.id)
        return records.collect do |r| 
          { 
            :value => r.value, 
            :name => DynamicFieldsets::FieldOption.find(r.value.to_i).name
          }
        end
      end

      # given a value hash for a field, return the part that needs to be shown on the show page
      def get_value_for_show(value)
        value[:name]
      end

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

