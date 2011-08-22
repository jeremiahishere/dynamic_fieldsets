Feature: Managed fieldset children

  Scenario: Viewing child index page from the index page
    Given a parent fieldset exists
    And I am on the fieldset index page
    When I follow "Children"
    Then I should be on the fieldset child page for that fieldset

  Scenario: Viewing a one generation fieldset's index page
    Given I am pending
    Given a child fieldset exists
    And I am on the fieldset children page for the parent fieldset
    When I follow "Children"
    Then I should be on the fieldset child page for that fieldset

  Scenario: Viewing a fieldset's view page from the fieldset's child page
    Given a child fieldset exists
    And I am on the fieldset children page for the parent fieldset
    When I follow "Show"
    Then I should be on the child fieldset show page
    And I should see the data for that fieldset

  Scenario: Viewing a field's edit page from the fieldset's child page
    Given a child fieldset exists
    And I am on the fieldset children page for the parent fieldset
    When I follow "Edit"
    Then I should be on the fieldset edit page for that fieldset

  Scenario: Viewing a field and a fieldset from the fieldset's child page
    Given I am pending
    Given a child field and fieldset exists
    And I am on the fieldset children page for the parent fieldset
    Then I should see the child field information
    And I should see the child fieldset information

  Scenario: Automatically setting fieldset when creating a new child field from the child page
    Given I am pending
    Given a parent fieldset exists
    And I am on the fieldset child page for that fieldset
    When I follow "New Child - Field" 
    Then I should be on the field new page
    And the Parent Fieldset should be selected for "Fieldset"

  Scenario: Automatically setting fieldset when creating a new child fieldset from the child page
    Given I am pending
    Given a parent fieldset exists
    And I am on the fieldset child page for that fieldset
    When I follow "New Child - Fieldset"
    Then I should be on the fieldset new page
    And the Parent Fieldset should be selected for "Parent fieldset"
