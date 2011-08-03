Given(/^a fieldset exists$/) do
  @fieldset = DynamicFieldsets::Fieldset.create(
    :name => "Fingerprint Form",
    :nkey => "fingerprint_form",
    :description => "A test fingerprint form")
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
