Given /^a field exists$/ do
  @field = DynamicFieldsets::Field.create(
    :name => "Test field",
    :label => "Test field",
    :type => "textfield",
    :enabled => true,
    :required => true)
end

Given /^the field is in use$/ do
  @field = DynamicFieldsets::Field.last
  if DynamicFieldsets::Fieldset.all.empty?
    Given %{a fieldset exists}
  end
  @fsc = DynamicFieldsets::FieldsetChild.create(:child => @field, :fieldset_id => DynamicFieldsets::Fieldset.last.id)
end


Given /^field options, defaults, and attributes exist for that field$/ do
  @field = DynamicFieldsets::Field.last
  DynamicFieldsets::FieldOption.create(:field => @field, :name => "Field option value")
  DynamicFieldsets::FieldDefault.create(:field => @field, :value => "Default value value")
  DynamicFieldsets::FieldHtmlAttribute.create(:field => @field, :attribute_name => "Html attribute name", :value => "Html attribute value")
end

Then /^I should see that field listed$/ do
  @field = DynamicFieldsets::Field.last
  page.should have_content(@field.name)
  page.should have_content(@field.type)
end

Then /^I should see the data for that field$/ do
  @field = DynamicFieldsets::Field.last
  page.should have_content(@field.name)
  page.should have_content(@field.label)
  page.should have_content(@field.type)
  page.should have_content(@field.enabled)
  page.should have_content(@field.required)

  if @field.field_options.length > 0 
    @field.field_options.each do |fo|
      page.should have_content(fo.name)
    end
  end

  if @field.field_defaults.length > 0
    @field.field_defaults.each do |fd|
      page.should have_content(fd.value)
    end
  end

  if @field.field_html_attributes.length > 0
    @field.field_html_attributes.each do |fha|
      page.should have_content(fha.attribute_name)
      page.should have_content(fha.value)
    end
  end
end

Given /^I record the data for that field$/ do
  @field = DynamicFieldsets::Field.last
end

Then /^I should not see that field listed$/ do
  page.should_not have_content(@field.name)
  page.should_not have_content(@field.type)
end
