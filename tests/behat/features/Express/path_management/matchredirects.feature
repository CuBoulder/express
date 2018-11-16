@settings @redirects @matchredirects
Feature: Match redirects
  In order to redirect entire sections
  An authenticated user with the proper role
  Should be able to create a Match redirect

  Scenario Outline: Only Devs and Admins get the Match Redirect link.
    Given I am logged in as a user with the <role> role
    When I go to "admin/settings"
    Then I should see "Match Redirect"

  Examples:
      | role                  |
      | developer             |
      | administrator         |

Scenario Outline: Lower level roles do not get the Match Redirect link.
    Given I am logged in as a user with the <role> role
    When I go to "admin/settings"
    Then I should not see "Match Redirect"

    Examples:
      | role                  |
      | site_owner            |
      | content_editor        |
      | edit_my_content       |
      | site_editor           |
      | edit_only             |

Scenario Outline: Only a developers and administrators can add match redirects.
    Given I am logged in as a user with the <role> role
    When I go to "admin/config/search/match_redirect/add"
    Then I should see <message>

    Examples:
      | role                  | message                                                                                                    |
      | developer             | "By default if a pattern matches and there is content for that target url then it will not be redirected." |
      | administrator         | "By default if a pattern matches and there is content for that target url then it will not be redirected." |
      | site_owner            | "Access denied"                                                                                            |
      | content_editor        | "Access denied"                                                                                            |
      | edit_my_content       | "Access denied"                                                                                            |
      | site_editor           | "Access denied"                                                                                            |
      | edit_only             | "Access denied"                                                                                            |
      | access_manager        | "Access denied"                                                                                            |
      | configuration_manager | "Access denied"                                                                                            |

@checkboxCheck
  Scenario: Verify that "Allow content to be redirected?" is unchecked before further tests are conducted
  Given I am logged in as a user with the "developer" role
  And I am on "admin/config/search/match_redirect/add"
  Then the "edit-override" checkbox should not be checked

Scenario: An administrator should be able to add match redirects.
    Given I am logged in as a user with the "administrator" role
    When I go to "node/add/page"
    And I fill in "Title" with "Fruity Tooty"
    And I fill in "Body" with "Fruity Tooty Body text."
    And I press "Save"
    Then I should see "Basic page Fruity Tooty has been created."
    When I go to "node/add/page"
    And I fill in "Title" with "Veggie Wedgie"
    And I fill in "Body" with "Veggie Wedgie Body text."
    And I press "Save"
    Then I should see "Basic page Veggie Wedgie has been created."
    When I go to "admin/config/search/match_redirect/add"
    Then I should see "By default if a pattern matches and there is content for that target url then it will not be redirected."
    When I fill in "Pattern" with "fruity*"
    And I fill in "Target" with "veggie-wedgie"
    And I select "301" from "status_code"
    And I check "edit-override"
    And I press "Save"
    Then I should see "Redirect saved."
    When I go to "fruity"
    Then I should see "Veggie Wedgie"


Scenario: An administrator should be able to edit match redirects.
  Given I am logged in as a user with the "administrator" role
  When I go to "admin/config/search/match_redirect"
  And I follow "Edit"
  Then I should see "Edit match redirect"
  And the "edit-override" checkbox should be checked

  Scenario Outline: Less privileged users should not be able to edit match redirects.
    Given I am logged in as a user with the <role> role
    When I go to "admin/config/search/match_redirect/add"
    Then I should see <message>

    Examples:
      | role                  | message         |
      | developer             | "Edit"          |
      | administrator         | "Edit"          |
      | site_owner            | "Access denied" |
      | content_editor        | "Access denied" |
      | edit_my_content       | "Access denied" |
      | site_editor           | "Access denied" |
      | edit_only             | "Access denied" |
      | access_manager        | "Access denied" |
      | configuration_manager | "Access denied" |
