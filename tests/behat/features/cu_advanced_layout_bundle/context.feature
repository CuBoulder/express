@AdvLayoutBundle @context @javascript
Feature: Context
In order to exercise control over my regions, pages and blocks 
As an authenticated user
I should be able to set conditions and reactions with Context

@api
Scenario Outline: An authenticated user should be able to access the form for adding a Context
    Given I am logged in as a user with the <role> role
    When I go to "admin/structure/context"
    Then I should see "Context allows you to manage contextual conditions"

    Examples:
    | role            |
    | edit_my_content |
    | content_editor  |
    | site_owner      |
    | administrator   |
    | developer       |


@api @context @contextconditions
Scenario Outline: A content_editor should see a limited number of context conditions
Given  I am logged in as a user with the "content_editor" role
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

@api @context @contextreactions
Scenario Outline: A content_editor should see a limited number of context reactions
Given  I am logged in as a user with the "content_editor" role
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
