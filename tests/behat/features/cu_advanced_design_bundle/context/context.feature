Feature: Context

@context @contextconditions @exclude_all_bundles
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

@context @contextreactions @exclude_all_bundles
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

# CONTEXT FUNCTIONALITY IS TESTED IN OTHER FEATURES. 
# THIS FEATURE TARGETS SITE BACKGROUND IMAGES AND PAGE TITLE IMAGES ONLY

@api @AdvDesign
Feature: Add background images with Context
In order to add visual interest to my site
As an authenticated user
I should be able to attach graphics to site and page title backgrounds 

# THIS SCENARIO UPLOADS A GRAPHIC TO USE AS BACKGROUND
# NEED A CUSTOM STEP TO FIGURE OUT THE NODE ID
Scenario: A background image can be uploaded for use in tests
 Given I am logged in as a user with the "site_owner" role
 Then I go to "node/add/file"
 And I fill in "edit-title" with "Background Graphic"
 And I attach the file "cupcakes.jpg" to "edit-field-file-attachment-und-0-upload"
 And I press "Upload"
 # THIS NEXT LINE VERIFIES THAT THE UPLOAD WAS SUCCESSFUL
 Then I should see "File Information"
 And I should see "Operations"
 And I press "edit-submit"
 Then I should see "File Background Graphic has been created."
# And I find out the node ID and save it in a variable

Scenario: An authenticated user can attach a background image to a site
 Given I am logged in as a user with the "site_owner" role
 # THEME MUST SUPPORT BACKGROUND GRAPHIC; I.E. LAYOUT == BOXED; THIS LINK ACTIVATES SHADOW THEME
 And I go to "admin/theme/active/cushadow"
 And I go to "/"
 Then the response should contain "cushadow/favicon.ico"
 # NEXT GO TO CONTEXT AND ADD THE GRAPHIC TO BACKSTRETCH
 Then I go to "admin/structure/context/list/sitewide/edit"
 And I select "backstretch" from "edit-reactions-selector"
 # USE THE NODE ID IN THIS NEXT STEP
 # And I fill in "edit-reactions-plugins-backstretch-backstretch-url" with "node/XXX/backstretch"
 And I press "Save"
 # THEN GO TO HOMEPAGE; FINAL CHECK IS THAT 'BACKSTRETCH' and 'NODE ID' IS FOUND IN THE PAGE RESPONSE
 And I go to "/"
 Then the response should contain "backstretchURL"
 # WHEN WE KNOW NODE URL: And the response should contain "node\/XXX\/backstretch"
    
@javascript
Scenario: An authenticated user can attach a background image to a page title
  Given I am logged in as a user with the "site_owner" role
  # CREATE A BASIC PAGE
  And I am on "node/add/page"
  And fill in "edit-title" with "My Page Title"
  And I follow "Disable rich-text"
  And fill in "Body" with "Lorem ipsum dolor sit amet"
  When I press "edit-submit"
 Then I should be on "/my-page-title"
 # GO TO CONTEXT, TURN ON PAGE TITLE FUNCTIONALITY
 Then I go to "admin/structure/context/add"
 And I fill in "edit-name" with "mypagetitle"
 And I select "path" from "edit-conditions-selector"
 And I fill in "edit-conditions-plugins-path-values" with "my-page-title"
 And I select "title_image" from "edit-reactions-selector"
 # USE THE NODE ID IN THIS NEXT STEP
 # And I fill in "edit-reactions-plugins-title-image-title-image-file" with "node/XXX/large"
 And I press "Save"
 Then I should see "mypagetitle has been created"
 # GO TO URL OF BASIC PAGE, YOU SHOULD SEE A DIV FOR HOLDING THE PAGE TITLE GRAPHIC: 
 And I go to "/my-page-title"
 Then I should see "My Page Title"
 And I should see "Lorem ipsum dolor sit amet"
 And the response should contain "id=\"page-title-image-overlay\""
# WHEN WE KNOW NODE URL: And the "#page-title-image-wrapper" element should have "background-image:url(node/XXX/large);" in the "style" attribute
