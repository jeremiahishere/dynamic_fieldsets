Given(/^a fieldset exists$/) do
  @fieldset = DynamicFieldsets::Fieldset.create(
    :name => "Fingerprint Form",
    :nkey => "fingerprint_form",
    :description => "A test fingerprint form")
end

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
    :description => "A test parent fieldset",
    :parent_fieldset => @parent_fieldset,
    :order_num => 1)
end

Given /^a child field exists$/ do
  @parent_fieldset = DynamicFieldsets::Fieldset.create(
    :name => "Parent Fieldset",
    :nkey => "parent_fieldset",
    :description => "A test parent fieldset")
  @child_field = DynamicFieldsets::Field.create(
    :name => "Child Fieldset",
    :label => "Child Fieldset",
    :field_type => "textfield",
    :order_num => 1,
    :enabled => true,
    :required => true,
    :fieldset => @parent_fieldset)
end

Then(/^I should see that fieldset listed$/) do
  @fieldset = DynamicFieldsets::Fieldset.last
  page.should have_content(@fieldset.name)
  page.should have_content(@fieldset.nkey)
  page.should have_content(@fieldset.description)
  page.should have_content(@fieldset.parent_fieldset.name) if @fieldset.parent_fieldset
end

Then(/^I should see the data for that fieldset$/) do
  @fieldset = DynamicFieldsets::Fieldset.last
  page.should have_content(@fieldset.name)
  page.should have_content(@fieldset.nkey)
  page.should have_content(@fieldset.description)
  page.should have_content(@fieldset.parent_fieldset.name) if @fieldset.parent_fieldset
  page.should have_content(@fieldset.order_num) if @fieldset.order_num
end
Given /^I record the data for that fieldset$/ do
  @fieldset = DynamicFieldsets::Fieldset.last
end

# must call record the data for this to work
Then /^I should not see that fieldset listed$/ do
  page.should_not have_content(@fieldset.name)
  page.should_not have_content(@fieldset.nkey)
  page.should_not have_content(@fieldset.description)
  page.should_not have_content(@fieldset.parent_fieldset.name) if @fieldset.parent_fieldset
  page.should_not have_content(@fieldset.order_num) if @fieldset.order_num
end

Then /^the parent fieldset should be selected for the Parent fieldset selector$/ do
  @field = "dynamic_fieldsets_fieldset[parent_fieldset_id]"
  @value = DynamicFieldsets::Fieldset.last.name
  #with_scope(@field) do
    field_selected = find_field(@field)['selected']
    if field_selected.respond_to? :should
      field_selected.should be_true
    else
      assert field_selected
    end
  #end
end
