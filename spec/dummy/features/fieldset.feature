Feature: Managed fieldsets

  Scenario: Listing fieldsets
    Given a fieldset exists
    When I go to the fieldset index page
    Then I should see that fieldset listed

  Scenario: Adding a root fieldset
    Given I am on the fieldset new page
    When I fill in "test_fieldset" for "Nkey"
    And I fill in "Test Fieldset" for "Name"
    And I fill in "This fieldset is being used for testing." for "Description"
    And I am pending
    And I choose "true" within "#fieldset_enabled"
    And I choose "true" within "#fieldset_required"
    And I press "Submit"
    Then I should be on the fieldset show page for that fieldset
    And I should see the data for the fieldset

  Scenario: Adding a child fieldsets
    Given a parent fieldset exists
    And I am on the fieldset new page
    When I fill in "test_fieldset" for "Nkey"
    And I fill in "Test Fieldset" for "Name"
    And I fill in "This fieldset is being used for testing." for "Description"
    And I am pending
    And I choose "true" within "#fieldset_enabled"
    And I choose "true" within "#fieldset_required"
    And I choose "that parent" from "Parent Fieldset"
    And I fill in "1" for "Order Number"
    And I press "Submit"
    Then I should be on the fieldset show page for that fieldset
    And I should see the data for the fieldset
    
    
  Scenario: Showing a fieldset
  Scenario: Editing a fieldset
  Scenario: Destroying a fieldset
  Scenario: Fieldset Validations
