# If these tests ever, break please delete them
# They are for demosntrating javsacript testing only
Feature: How to test with and without javascript

  # If you use a javascript tag, Selenium will be loaded and used to test the page
  # Normal javascript will run in a firefox browser
  @javascript
  Scenario: Creating a field option
    Given I am on the field new page
    And I should not see "remove" within "a"
    When I follow "Add Field Option"
    Then I should see "remove" within "a"

  # If you don't use javascript, no javascript will be run because we are using a simulated browser
  # In this case, clicking on the link will not do anything
  Scenario: Creating a field option
    Given I am on the field new page
    And I should not see "remove" within "a"
    When I follow "Add Field Option"
    Then I should not see "remove" within "a"


  # Please do not delete these tests, they are for dependencies. [hex]
  # Not all of these steps are fully tested, but I should not see the instructions
  # and I should see the instructions are written. They seem like they should be good, but not tested.

  @javascript
  Scenario: Checking textfield dependency
    Given I am pending
    And there is a dependency on a textfield with "I like tests"
    And I am on the information forms edit page
    # Not made yet
    When I fill in the field with "I don't like tests"
    Then I should not see the instructions
    When I fill in the field with "I like tests"
    Then I should see the instructions

  @javascript
  Scenario: Checking radio button dependency
    Given I am pending
    And there is a dependency on a radio
    And I am on the information forms edit page
    # Not made yet
    When I select the radio button "Radio Button A"
    Then I should not see the instructions
    When I select the radio button "Radio Button B"
    Then I should see the instructions

  @javascript
  Scenario: Checking textarea dependency
    Given I am pending
    And there is a dependency on a textarea with "I like tests"
    And I am on the information forms edit page
    # Not made yet
    When I fill in the area with "I don't like tests"
    Then I should not see the instructions
    When I fill in the area with "I like tests"
    Then I should see the instructions

  @javascript
  Scenario: Checking checkbox dependency
    Given I am pending
    And there is a dependency on a checkbox
    And I am on the information forms edit page
    # Not made yet
    When I check the checkbox "Checkbox A"
    Then I should not see the instructions
    When I check the checkbox "Checkbox B"
    Then I should see the instructions

  @javascript
  Scenario: Checking select dependency
    Given I am pending
    And there is a dependency on a select
    And I am on the information forms edit page
    # Not made yet
    When I select the select option "Select Option A"
    Then I should not see the instructions
    When I select the select option "Select Option B"
    Then I should see the instructions

  @javascript
  Scenario: Checking multiple select dependency
    Given I am pending
    And there is a dependency on a multi-select
    And I am on the information forms edit page
    # Not made yet
    When I select the select option "Select Option A"
    Then I should not see the instructions
    When I select the select option "Select Option B"
    Then I should see the instructions
