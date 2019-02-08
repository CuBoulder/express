@AdvancedDesign
Feature: Context
In order to place blocks and add background graphics
As a user with the proper role
I should be able to access the full context features

@context @contextconditions
  Scenario Outline: A Site Owner should see a limited number of context conditions
    Given  I am logged in as a user with the "site_owner" role
    And am on "admin/structure/context/add"
    When I select <condition> from "edit-conditions-selector"

    Examples:
      | condition |
      | "Context (any)" |
      | "Context (all)" |
      | "Default context" |
      | "Layout" |
      | "Menu" |
      | "Node type" |
      | "Taxonomy" |
      | "Path" |
      | "Query string" |
      | "Sitewide context" |
      | "Sitewide public" |

  @context @contextreactions
  Scenario Outline: A Site Owner should see a limited number of context reactions
    Given  I am logged in as a user with the "site_owner" role
    And am on "admin/structure/context/add"
    Then I select <reaction> from "edit-reactions-selector"

    Examples:
      | reaction |
      | "Backstretch" |
      | "Blocks" |
      | "Breadcrumb" |
      | "Columns Override" |
      | "Menu" |
      | "Regions" |
      | "Page Title Image" |
