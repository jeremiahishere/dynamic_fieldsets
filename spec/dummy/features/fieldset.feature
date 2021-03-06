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
    And I press "Create Fieldset"
    Then I should be on the fieldset show page for that fieldset
    And I should see "Successfully created a new fieldset"
    And I should see the data for that fieldset

  Scenario: Adding a child fieldsets
    Given a parent fieldset exists
    And I am on the fieldset new page
    When I fill in "test_fieldset" for "Nkey"
    And I fill in "Test Fieldset" for "Name"
    And I fill in "This fieldset is being used for testing." for "Description"
    And I press "Create Fieldset"
    Then I should be on the fieldset show page for that fieldset
    And I should see "Successfully created a new fieldset"
    And I should see the data for that fieldset
    
  Scenario: Editing a fieldset
    Given a parent fieldset exists
    And I am on the fieldset edit page for that fieldset
    When I fill in "Different fieldset name" for "Name"
    And I fill in "different_fieldset_name" for "Nkey"
    And I fill in "This fieldset has been repurposed" for "Description"
    And I press "Update Fieldset"
    Then I should be on the fieldset show page for that fieldset
    And I should see "Successfully updated a fieldset"
    And I should see "Different fieldset name"
    And I should see "different_fieldset_name"
    And I should see "This fieldset has been repurposed"

  Scenario: Destroying a fieldset
    Given I am pending
    Given a parent fieldset exists
    And I record the data for that fieldset
    And I am on the fieldset index page
    When I follow "Destroy"
    Then I should not see that fieldset listed
