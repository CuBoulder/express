Feature: CU Extended Content Search Views
  When I log into the website
  As an content editor, site owner, administrator or developer
  I should be able to access additional views.

  @api @extended_search
  Scenario Outline: An authenticated user should be able to access the form for finding content
    Given  I am logged in as a user with the <role> role
    When I go to "admin/content"
    Then I should not see <message>

    Examples:
    | role           | message         |
    | content_editor | "Access denied" |
    | site_owner     | "Access denied" |
    | administrator  | "Access denied" |
    | developer      | "Access denied" |

  @api @extended_search
  Scenario: An anonymous user should not be able to access the form for adding page content
    When I am on "admin/content"
    Then I should see "Access denied"

  @api @extended_search
  Scenario: As a content_editor I should be able to see the additional fields for finding content
    Given  I am logged in as a user with the "content_editor" role
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
