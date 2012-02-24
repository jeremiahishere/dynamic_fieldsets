DynamicFieldsets.configure do |config|
  # If cache classes is off, this field needs to be set.  Otherwise, rails issues
  # can cause the single table inheritance to fail.  This is due to the object
  # space getting reset after every request.  In production and test environemnts, 
  # this information will not be used because the object space will be complete.
  # config.available_field_types = [ "DynamicFieldsets::CheckboxField", "DynamicFieldsets::"DateField", "DynamicFieldsets::"DatetimeField", "DynamicFieldsets::InstructionField", "DynamicFieldsets::MultipleSelectField", "DynamicFieldsets::RadioField", "DynamicFieldsets::SelectField", "DynamicFieldsets::TextField", "DynamicFieldsets::TextareaField" ]

  # This should correspond to the beginning of the id for the fields for on the form
  # For example: fsa-8
  # config.form_fieldset_associator_prefix = "fsa-"

  # This should correspond to the beginning of the field section of form inputs
  # For example: fsa-8[field-7]
  # config.form_field_prefix = "field-"
end
