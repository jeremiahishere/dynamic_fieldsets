module DynamicFieldsets
  class FieldsetAssociator < ActiveRecord::Base
    belongs_to :fieldset
    has_many :field_records

    validates_presence_of :fieldset_id, :fieldset_model_id, :fieldset_model_type, :fieldset_model_name
    validate :unique_fieldset_model_name_per_polymorphic_fieldset_model

    def unique_fieldset_model_name_per_polymorphic_fieldset_model
      FieldsetAssociator.where(:fieldset_model_id => self.fieldset_model_id, :fieldset_model_type => self.fieldset_model_id, :fieldset_model_name => self.fieldset_model_name).each do |fsa|
        if fsa.id != self.id
          self.errors.add(:fieldset_model_name, "A duplicate Field Model, Field Model Name pair has been found.")
        end
      end
    end

    # Scope to find a fieldset associator based on information from the fieldset model
    #
    # Arguments
    # fieldset: The nkey of the fieldset
    # fieldset_model_id: The id of the fieldset model
    # fieldset_model_type: The class name of the fieldset model
    # fieldset_model_name: The named fieldset in the model
    #
    # @params [Hash] args A hash of arguments for the scope
    # @retursn [Array] An array of fieldset associators that match the arguments
    def self.find_by_fieldset_model_parameters(args)
      fieldset = Fieldset.find_by_nkey(args[:fieldset])
      where(
        :fieldset_id => fieldset.id, 
        :fieldset_model_id => args[:fieldset_model_id], 
        :fieldset_model_type => args[:fieldset_model_type], 
        :fieldset_model_name => args[:fieldset_model_name])
    end

    # Returns a hash of field record values
    # The hash keys are field ids
    # The hash values are field_record values or field_records ids depending on the field type
    # Fun nonintuitive stuff here
    #
    # If a field that expects a single value has multiple values, it will
    # choose one to use arbitrarily
    #
    # @returns [Hash] A hash of field record values associated with field ids
    def field_values
      output = {}
      self.field_records.each do |record|
        if record.field.type == "checkbox" || record.field.type == "multiple_select"
          output[record.field.id] = [] unless output[record.field.id].is_a?(Array)
          # note record.id
          output[record.field.id].push record.id
        else
          # note record.value
          output[record.field.id] = record.value
        end
      end
      return output
    end

  end
end
