Given /^a fieldset exists$/ do
  @fieldset = DynamicFieldsets::Fieldset.create(
    :name => "Fingerprint Form",
    :nkey => "fingerprint_form",
    :description => "A test fingerprint form")
end

Then /^I should see that fieldset listed$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see the data for the fieldset$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^a parent fieldset exists$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I choose "([^"]*)" from "([^"]*)"$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

