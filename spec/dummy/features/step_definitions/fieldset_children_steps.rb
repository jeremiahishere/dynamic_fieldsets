def create_parent_fieldset
  parent_fieldset = DynamicFieldsets::Fieldset.create(
    :name => "Parent Fieldset",
    :nkey => "parent_fieldset",
    :description => "A test parent fieldset")
  return parent_fieldset
end

def create_child_fieldset(parent, order_num = 1)
  child_fieldset = DynamicFieldsets::Fieldset.create(
    :name => "Child Fieldset",
    :nkey => "child_fieldset",
    :description => "A test child fieldset")
  DynamicFieldsets::FieldsetChild.create(:fieldset => parent, :child => child_fieldset, :order_num => order_num)
  return child_fieldset
end

def create_child_field(parent, order_num = 1)
  child_field = DynamicFieldsets::Field.create(
    :name => "Child Field",
    :label => "Child Field",
    :type => "textfield",
    :enabled => true,
    :required => true)
  DynamicFieldsets::FieldsetChild.create(:fieldset => parent, :child => child_field, :order_num => order_num)
  return child_field
end

Given(/^a parent fieldset exists$/) do
  @parent_fieldset = create_parent_fieldset
end

Given(/^a child fieldset exists$/) do
  @parent_fieldset = create_parent_fieldset
  @child_fieldset = create_child_fieldset(@parent_fieldset, 1)
end

Given /^a child field exists$/ do
  @parent_fieldset = create_parent_fieldset
  @child_field = create_child_field(@parent_fieldset, 1) 
end

Given /^a child field and fieldset exists$/ do
  @parent_fieldset = create_parent_fieldset 
  @child_field = create_child_field(@parent_fieldset, 1) 
  @child_fieldset = create_child_fieldset(@parent_fieldset, 2) 
end

Then(/^the Parent Fieldset should be selected for "([^"]*)"$/) do |field|
  pending "this step does not make sense in the new system."
  value = DynamicFieldsets::Fieldset.last.name
  page.has_xpath?("//option[@selected = 'selected' and contains(string(), value)]").should be_true
end

Then /^I should see the child field information$/ do
  @child_field = DynamicFieldsets::Field.last
  page.should have_content(@child_field.name)
  page.should have_content(@child_field.type)
end

Then /^I should see the child fieldset information$/ do
  @child_fieldset = DynamicFieldsets::Fieldset.last
  page.should have_content(@child_fieldset.name)
  page.should have_content(@child_fieldset.description)
end
