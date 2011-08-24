Feature: Managed fields

  Scenario: Listing fields
    Given a field exists
    When I go to the field index page
    Then I should see that field listed

  Scenario: Adding a field
    Given I am on the field new page
    When I fill in "test_field" for "Label"
    And I fill in "Test field" for "Name"
    And I select "textfield" from "Field type"
    And I press "Create Field"
    Then I should be on the field show page for that field
    And I should see "Successfully created a new field"
    And I should see the data for that field

  Scenario: Editing a field
    Given a field exists
    And I am on the field edit page for that field
    When I fill in "Different field name" for "Name"
    And I fill in "different_field_name" for "Label"
    And I select "textarea" from "Field type"
    And I press "Update Field"
    Then I should be on the field show page for that field
    And I should see "Successfully updated a field"
    And I should see "Different field name"
    And I should see "different_field_name"

  Scenario: Destroying a field
    Given a field exists
    And I record the data for that field
    And I am on the field index page
    When I press "Destroy"
    Then I should not see that field listed

  Scenario: Should not be able to destroy a field in use
    Given a field exists
    And the field is in use
    When I go to the field index page
    Then I should see "Destroy" within "del"

  # this test should be a javascript test and actually test the javascript at some point
  Scenario: Additional field links on new page
    Given a field exists
    And I am on the field new page
    Then I should see "Add Field Option"
    And I should see "Add Default Value"
    And I should see "Add Html Attribute"

  Scenario: Additional field values on show page
    Given a field exists
    And field options, defaults, and attributes exist for that field
    When I go to the field show page for that field
    Then I should see "Default value value"
    And I should see "Field option value"
    And I should see "Html attribute name"
    And I should see "Html attribute value"

  Scenario: Enabling and disabling a field
    Given a field exists
    When I go to the field index page
    Then I should see that field listed
    When I press "Disable"
    Then I should be on the field index page
    And I should see "Successfully updated a new field." 
    When I press "Enable"
    Then I should be on the field index page
    And I should see "Successfully updated a new field." 
