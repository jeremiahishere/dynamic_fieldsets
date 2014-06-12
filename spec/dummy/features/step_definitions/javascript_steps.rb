def create_root_fieldset
  parent_fieldset = DynamicFieldsets::Fieldset.create(
    :name => "First",
    :nkey => "first",
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

def create_textfield(parent, order_num = 1)
  child_field = DynamicFieldsets::TextField.create(
    :name => "Child Field",
    :label => "Child Field",
    # :type => "textfield",
    :enabled => true,
    :required => true)
  DynamicFieldsets::FieldsetChild.create(:fieldset => parent, :child => child_field, :order_num => order_num)
  return child_field
end

def create_radio(parent, order_num = 1)
  child_field = DynamicFieldsets::RadioField.create(
    :name => "Child Field",
    :label => "Child Field",
    # :type => "radio",
    :enabled => true,
    :required => true,
    :field_options => [DynamicFieldsets::FieldOption.create(
      :name => "Radio Button A"
    ), DynamicFieldsets::FieldOption.create(
      :name => "Radio Button B"
    )]
  )
  DynamicFieldsets::FieldsetChild.create(:fieldset => parent, :child => child_field, :order_num => order_num)
  return child_field
end

def create_textarea(parent, order_num = 1)
  child_field = DynamicFieldsets::TextareaField.create(
    :name => "Child Field",
    :label => "Child Field",
    # :type => "textarea",
    :enabled => true,
    :required => true)
  DynamicFieldsets::FieldsetChild.create(:fieldset => parent, :child => child_field, :order_num => order_num)
  return child_field
end

def create_checkbox(parent, order_num = 1)
  child_field = DynamicFieldsets::CheckboxField.create(
    :name => "Child Field",
    :label => "Child Field",
    # :type => "checkbox",
    :enabled => true,
    :required => true,
    :field_options => [DynamicFieldsets::FieldOption.create(
      :name => "Checkbox A"
    ), DynamicFieldsets::FieldOption.create(
      :name => "Checkbox B"
    )]
  )
  DynamicFieldsets::FieldsetChild.create(:fieldset => parent, :child => child_field, :order_num => order_num)
  return child_field
end

def create_select(parent, order_num = 1)
  child_field = DynamicFieldsets::SelectField.create(
    :name => "Child Field",
    :label => "Child Field",
    # :type => "select",
    :enabled => true,
    :required => true,
    :field_options => [DynamicFieldsets::FieldOption.create(
      :name => "Select Option A"
    ), DynamicFieldsets::FieldOption.create(
      :name => "Select Option B"
    )]
  )
  DynamicFieldsets::FieldsetChild.create(:fieldset => parent, :child => child_field, :order_num => order_num)
  return child_field
end

def create_multi_select(parent, order_num = 1)
  child_field = DynamicFieldsets::MultipleSelectField.create(
    :name => "Child Field",
    :label => "Child Field",
    # :type => "multiple_select",
    :enabled => true,
    :required => true,
    :field_options => [DynamicFieldsets::FieldOption.create(
      :name => "Select Option A"
    ), DynamicFieldsets::FieldOption.create(
      :name => "Select Option B"
    ), DynamicFieldsets::FieldOption.create(
      :name => "Select Option C"
    )]
  )
  DynamicFieldsets::FieldsetChild.create(:fieldset => parent, :child => child_field, :order_num => order_num)
  return child_field
end

def create_instruction(parent, order_num = 2)
  child_field = DynamicFieldsets::InstructionField.create(
    :name => "Dependent Field",
    :label => "Dependent Field",
    # :type => "instruction",
    :enabled => true,
    :required => true
  )
  DynamicFieldsets::FieldsetChild.create(:fieldset => parent, :child => child_field, :order_num => order_num)
  return child_field
end

def create_dependency(field1, field2, value, relationship)
  fsc1 = field1.fieldset_children.first
  fsc2 = field2.fieldset_children.first

  group = DynamicFieldsets::DependencyGroup.create(
    :fieldset_child => fsc2,
    :action => "show"
  )
  clause = DynamicFieldsets::DependencyClause.create(
    :dependency_group => group
  )
  dependency = DynamicFieldsets::Dependency.create(
    :fieldset_child => fsc1,
    :value => value,
    :relationship => relationship,
    :dependency_clause => clause
  )
end

Given /^there is a dependency on a textfield with "([^"]*)"$/ do |value|
  @parent_fieldset = create_root_fieldset
  @child_fieldset = create_child_fieldset(@parent_fieldset, 1)
  @textfield = create_textfield(@child_fieldset)
  @instruction = create_instruction(@child_fieldset)
  create_dependency(@textfield, @instruction, value, "equals")
end

Given /^there is a dependency on a radio$/ do
  @parent_fieldset = create_root_fieldset
  @child_fieldset = create_child_fieldset(@parent_fieldset, 1)
  @radio = create_radio(@child_fieldset)
  @instruction = create_instruction(@child_fieldset)
  create_dependency(@radio, @instruction, "radio button b", "equals")
end

Given /^there is a dependency on a textarea with "([^"]*)"$/ do |value|
  @parent_fieldset = create_root_fieldset
  @child_fieldset = create_child_fieldset(@parent_fieldset, 1)
  @textarea = create_textarea(@child_fieldset)
  @instruction = create_instruction(@child_fieldset)
  create_dependency(@textarea, @instruction, value, "equals")
end

Given /^there is a dependency on a checkbox$/ do
  @parent_fieldset = create_root_fieldset
  @child_fieldset = create_child_fieldset(@parent_fieldset, 1)
  @checkbox = create_checkbox(@child_fieldset)
  @instruction = create_instruction(@child_fieldset)
  create_dependency(@checkbox, @instruction, "checkbox b", "includes")
end

Given /^there is a dependency on a select$/ do
  @parent_fieldset = create_root_fieldset
  @child_fieldset = create_child_fieldset(@parent_fieldset, 1)
  @select = create_select(@child_fieldset)
  @instruction = create_instruction(@child_fieldset)
  create_dependency(@select, @instruction, "select option b", "equals")
end

Given /^there is a dependency on a multi-select$/ do
  @parent_fieldset = create_root_fieldset
  @child_fieldset = create_child_fieldset(@parent_fieldset, 1)
  @multi_select = create_multi_select(@child_fieldset)
  @instruction = create_instruction(@child_fieldset)
  create_dependency(@multi_select, @instruction, "select option b", "includes")
end

Then /^I should not see the instructions$/ do
 paths = [
    "//*[@class='hidden']/*[contains(.,'Dependent Field')]",
    "//*[@class='invisible']/*[contains(.,'Dependent Field')]",
    "//*[@style='display: none;']/*[contains(.,'Dependent Field')]"
  ]
  xpath = paths.join '|'
  page.should have_xpath(xpath)
end

Then /^I should see the instructions$/ do
 paths = [
    "//*[@class='hidden']/*[contains(.,'Dependent Field')]",
    "//*[@class='invisible']/*[contains(.,'Dependent Field')]",
    "//*[@style='display: none;']/*[contains(.,'Dependent Field')]"
  ]
  xpath = paths.join '|'
  page.should_not have_xpath(xpath)
end

