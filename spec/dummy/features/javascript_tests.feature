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

