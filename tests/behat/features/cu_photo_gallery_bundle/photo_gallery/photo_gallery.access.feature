@PhotoGallery
Feature: Photo Gallery Bundle
When I login to a Web Express website
As a user with the proper role
I should be able to create, edit, and delete a Photo Gallery

  @max_execution_time
  Scenario Outline: Certain user roles should be able to create Photo Gallery content.
 Given  I am logged in as a user with the <role> role
 And I am on "node/add/photo-gallery"
 Then I should see <message>

    Examples:
    | role            | message                 |
    | content_editor  | "Create Photo Gallery"  |
    | site_editor     | "Create Photo Gallery"  |
    | site_owner      | "Create Photo Gallery"  |
    | administrator   | "Create Photo Gallery"  |
    | developer       | "Create Photo Gallery"  |
    | edit_my_content | "Access Denied"         |
    | edit_only       | "Access Denied"         |

 Scenario: An anonymous user shouldn't be able to create Photo Gallery content.
 Given I am on "node/add/photo-gallery"
 Then I should see "Access Denied"
