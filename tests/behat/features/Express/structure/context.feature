@structure @javascript
Feature: Context
In order to exercise control over my regions, pages and blocks 
As an authenticated user
I should be able to set conditions and reactions with Context

@api
Scenario Outline: An authenticated user should be able to access the form for adding a Context
    Given I am logged in as a user with the <role> role
    When I go to "admin/structure/context"
    Then I should see <message>

    Examples:
    | role            | message |
    | edit_my_content | "Access denied" |
    | content_editor  | "Context allows you to manage contextual conditions" |
    | site_owner      | "Context allows you to manage contextual conditions" |
    | administrator   | "Context allows you to manage contextual conditions" |
    | developer       | "Context allows you to manage contextual conditions" |
    | configuration_manager | "Access denied" |
    | site_editor | "Context allows you to manage contextual conditions" |
    | edit_only | "Access denied" |
    | access_manager | "Access denied" |
    | form_manager | "Access denied" |
    

@api
Scenario Outline: Available Contexts are limited for all but Devs
Given I am logged in as a user with the <role> role
When I go to "admin/structure/context"
Then I should see "homepage"
 And I should see "sitewide"
 And I should see "sitewide-except-homepage"
 And I should not see "express_layout_blocks"
 And I should not see "pc2tr40fz12bx"
 And I should not see "search_results"

    Examples:
    | role            |
    | content_editor  |
    | site_owner      |
    | administrator   |
    | site_editor |
    
    
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
