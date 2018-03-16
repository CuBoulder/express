@file
Feature: File Content Type
  When I login to the website
  As an authenticated user
  I should be able to upload a file

  @api
  Scenario Outline: An authenticated user should be able to access the form for adding a file
    Given  I am logged in as a user with the <role> role
    When I go to "node/add/file"
    Then I should see <message>

    Examples:
      | role            | message         |
      | edit_my_content | "Access denied" |
      | content_editor  | "Create File" |
      | site_owner      | "Create File" |
      | administrator   | "Create File" |
      | developer       | "Create File" |

  @api
  Scenario: An anonymous user should not be able to access the form for adding a file
    When I am on "node/add/file"
    Then I should see "Access denied"


  @api @javascript @broken
  Scenario: A content editor should be able to access the form for adding a file
    Given  I am logged in as a user with the "content_editor" role
    When I go to "node/add/file"
      And  I fill in "Title" with "My File"
      And I fill in "body[und][0][value]" with "Sample Description"
    # And I attach the file "ralphie.jpg" to "edit-field-file-attachment-und-0-upload"
      And I attach the file "aerialDuotoneBlur.jpg" to "files[field_file_attachment_und_0]"
      And I press "Upload"
      And I wait for AJAX
    Then I should see "File Information"
    And I should see "Operations"
    When I press "Save"
    Then I should see "My File"
    And I should see "Access the top file listed below with the following url"
