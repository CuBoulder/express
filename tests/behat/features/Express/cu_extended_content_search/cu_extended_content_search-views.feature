# Content: Three tabs: Content, Blocks and Locked documents
# Content is sortable by Title, Type, Author, and Updated Date


Feature: CU Extended Content Search Views
  When I go to the Admin/Content page
  As an authenticated user
  I should be able to access additional views of content

  @api @extended_search
  Scenario Outline: Devs, Admins and SOs get the full content functionality
    Given  I am logged in as a user with the <role> role
    When I go to "admin/content"
    And I should see link "Content"
    And I should see link "Blocks"
    And I should see link "Locked Documents"
    And I should see the link "Add content"
    And I should see the link "Title"
    And I should see the link "Type"
    And I should see the link "Author"
    And I should see the link "Updated Date"
    And I should see the link "edit"

    Examples:
    | role            | 
    | site_owner      |
    | administrator   |
    | developer       |

  @api @extended_search
  Scenario: Content Editors get most content functionality
    Given  I am logged in as a user with the "content_editor" role
    When I go to "admin/content"
    And I should see link "Content"
    And I should see link "Blocks"
    And I should see the link "Add content"
    And I should see the link "Title"
    And I should see the link "Type"
    And I should see the link "Author"
    And I should see the link "Updated Date"
    And I should see the link "edit"

  @api @extended_search
  Scenario: Edit_My_Content editors get very limited functionality
    Given  I am logged in as a user with the "edit_my_content" role
    When I go to "admin/content"
    And I should see "Content"
    And I should see the link "Title"
    And I should see the link "Type"
    And I should see the link "Author"
    And I should see the link "Updated Date"
    
    @api @extended_search
  Scenario: An anonymous user should not be able to access the form for adding page content
    When I am on "admin/content"
    Then I should see "Access denied"

  @api @extended_search
  Scenario: As a content_editor I should be able to see the additional fields for finding content
    Given I am logged in as a user with the "content_editor" role
    When I go to "admin/content"
    Then I should see "Title contains"
      And I should see "Node: Type"
      And I should see "Promoted"
      And I should see "Published"
      And I should see "Author"
      And I should see an "#edit-submit-cu-content-administration-override-view" element
      And I should see a ".views-reset-button" element
      And I should see "Operations"
      And I should see the link "sort by Title"
      And I should see the link "sort by Type"
      # Author was removed as a sortable link in the 2.8.5 release.
      # And I should see the link "sort by Author"
