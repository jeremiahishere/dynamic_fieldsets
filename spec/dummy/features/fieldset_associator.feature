Feature: Managing fieldset associators

  Scenario: I should be able to see all fieldset associators on the index page
    Given I am pending
    Given a fieldset exists
    And an information form exists
    And a fieldset associator exists
    When I go to the fieldset associator index page
    Then I should see "InformationForm"
    And I should see ":child_form"
    And I should see "Fingerprint Form"

  Scenario: I should be able to see a fieldset associator on the show page
    Given I am pending
    Given a fieldset exists
    And an information form exists
    And a fieldset associator exists
    When I go to the fieldset associator show page for that fieldset associator
    Then I should see "InformationForm"
    And I should see ":child_form"
    And I should see "Fingerprint Form"

