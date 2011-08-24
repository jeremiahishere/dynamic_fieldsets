Given /^an information form exists$/ do
  # note that we are ignoring validations for this in case the fieldset has required fields
  @information_form = InformationForm.new(:name => "Test information form")
  @information_form.save(:validate => false)
end

Given /^a fieldset associator exists$/ do
  @fieldset_associator = DynamicFieldsets::FieldsetAssociator.create(
    :fieldset_model_id => InformationForm.last.id,
    :fieldset_model_type => "InformationForm",
    :fieldset_model_name => ":child_form",
    :fieldset_id => DynamicFieldsets::Fieldset.last.id)
end
