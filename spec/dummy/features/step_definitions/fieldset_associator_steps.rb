Given /^a fieldset exists$/ do
  @fieldset = DynamicFieldsets::Fieldset.create(
    :name => "Fingerprint Form",
    :nkey => "fingerprint_form",
    :description => "A test fingerprint form")
end

Given /^an information form exists$/ do
  @information_form = InformationForm.create(:name => "Test information form")
end

Given /^a fieldset associator exists$/ do
  @fieldset_associator = DynamicFieldsets::FieldsetAssociator.create(
    :fieldset_model_id => InformationForm.last.id,
    :fieldset_model_type => "InformationForm",
    :fieldset_model_name => ":child_form",
    :fieldset_id => DynamicFieldsets::Fieldset.last.id)
end
