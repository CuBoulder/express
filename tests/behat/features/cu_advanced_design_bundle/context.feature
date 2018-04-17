# CONTEXT FUNCTIONALITY IS TESTED IN OTHER FEATURES. THIS FEATURE TARGETS SITE BACKGROUND IMAGES ONLY

@AdvDesign
Feature: Add a Site Background image with Context
In order to add visual interest to my site
As an authenticated user
I should be able to add a background image to my site


@api @AdvDesign @context
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

@api @context @contextreactions @exclude_all_bundles
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
