Given /^a field exists$/ do
  @field = DynamicFieldsets::Field.create(
    :name => "Test field",
    :label => "Test field",
    :field_type => "textfield",
    :order_num => 1,
    :enabled => true,
    :required => true)
end

Then /^I should see that field listed$/ do
  @field = DynamicFieldsets::Field.last
  page.should have_content(@field.fieldset.name) if @field.fieldset
  page.should have_content(@field.name)
  page.should have_content(@field.field_type)
  page.should have_content(@field.order_num)
end

Then /^I should see the data for that field$/ do
  @field = DynamicFieldsets::Field.last
  page.should have_content(@field.name)
  page.should have_content(@field.label)
  page.should have_content(@field.field_type)
  page.should have_content(@field.order_num)
  page.should have_content(@field.enabled)
  page.should have_content(@field.required)
end

Given /^I record the data for that field$/ do
  @field = DynamicFieldsets::Field.last
end

Then /^I should not see that field listed$/ do
  page.should_not have_content(@field.name)
  page.should_not have_content(@field.field_type)
  page.should_not have_content(@field.order_num)
end
