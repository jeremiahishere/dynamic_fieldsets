Given(/^a parent fieldset exists$/) do
  @parent_fieldset = DynamicFieldsets::Fieldset.create(
    :name => "Parent Fieldset",
    :nkey => "parent_fieldset",
    :description => "A test parent fieldset")
end

Given(/^a child fieldset exists$/) do
  @parent_fieldset = DynamicFieldsets::Fieldset.create(
    :name => "Parent Fieldset",
    :nkey => "parent_fieldset",
    :description => "A test parent fieldset")
  @child_fieldset = DynamicFieldsets::Fieldset.create(
    :name => "Child Fieldset",
    :nkey => "child_fieldset",
    :description => "A test child fieldset",
    :parent_fieldset => @parent_fieldset,
    :order_num => 1)
end

Given /^a child field exists$/ do
  @parent_fieldset = DynamicFieldsets::Fieldset.create(
    :name => "Parent Fieldset",
    :nkey => "parent_fieldset",
    :description => "A test parent fieldset")
  @child_field = DynamicFieldsets::Field.create(
    :name => "Child Field",
    :label => "Child Field",
    :field_type => "textfield",
    :order_num => 1,
    :enabled => true,
    :required => true,
    :fieldset => @parent_fieldset)
end

Given /^a child field and fieldset exists$/ do
  @parent_fieldset = DynamicFieldsets::Fieldset.create(
    :name => "Parent Fieldset",
    :nkey => "parent_fieldset",
    :description => "A test parent fieldset")
  @child_field = DynamicFieldsets::Field.create(
    :name => "Child Field",
    :label => "Child Field",
    :field_type => "textfield",
    :order_num => 1,
    :enabled => true,
    :required => true,
    :fieldset => @parent_fieldset)
  @child_fieldset = DynamicFieldsets::Fieldset.create(
    :name => "Child Fieldset",
    :nkey => "child_fieldset",
    :description => "A test child fieldset",
    :parent_fieldset => @parent_fieldset,
    :order_num => 2)
end

Then /^the Parent Fieldset should be selected for "([^"]*)"$/ do |field|
  value = DynamicFieldsets::Fieldset.last.name
  page.has_xpath?("//option[@selected = 'selected' and contains(string(), value)]").should be_true
end

Then /^I should see the child field information$/ do
  @child_field = DynamicFieldsets::Field.last
  page.should have_content(@child_field.name)
  page.should have_content(@child_field.field_type)
  page.should have_content(@child_field.order_num)
end

Then /^I should see the child fieldset information$/ do
  @child_fieldset = DynamicFieldsets::Fieldset.last
  page.should have_content(@child_fieldset.order_num) if @child_fieldset.order_num
  page.should have_content(@child_fieldset.name)
  page.should have_content(@child_fieldset.description)
end
