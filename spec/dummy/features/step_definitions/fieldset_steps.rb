Given(/^fieldsets exist$/) do
  num_sets = DynamicFieldsets::Fieldset.all.length
  Linguistics.use(:en)
  10.times do
    DynamicFieldsets::Fieldset.create(
      :name => "Test information form#{DynamicFieldsets::Fieldset.all.length + 1}",
      :nkey => (DynamicFieldsets::Fieldset.all.length + 1).en.ordinate,
      :description => "A test information form#{DynamicFieldsets::Fieldset.all.length + 1}")
  end
end

Then(/^I should see that fieldset listed$/) do
  @fieldset = DynamicFieldsets::Fieldset.last
  page.should have_content(@fieldset.name)
  page.should have_content(@fieldset.nkey)
  page.should have_content(@fieldset.description)
end

Then(/^I should see the data for that fieldset$/) do
  @fieldset = DynamicFieldsets::Fieldset.last
  page.should have_content(@fieldset.name)
  page.should have_content(@fieldset.nkey)
  page.should have_content(@fieldset.description)
end
Given /^I record the data for that fieldset$/ do
  @fieldset = DynamicFieldsets::Fieldset.last
end

# must call record the data for this to work
Then /^I should not see that fieldset listed$/ do
  page.should_not have_content(@fieldset.name)
  page.should_not have_content(@fieldset.nkey)
  page.should_not have_content(@fieldset.description)
end
