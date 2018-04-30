@settings
Feature: Feedback Form places an existing Webform as a popup
In order to create a site feedback form
An authenticated user with the proper role
Should be able to select a published form as the site feedback form

#SOME ROLES CAN SELECT A FEEDBACK FORM AND SET OPTIONS FOR IT
@api
Scenario Outline: Devs, Admins and SOs can see all the options for the Feedback Form
  Given I am logged in as a user with the <role> role
  And am on "admin/settings/forms/feedback"
  Then I should see "Available Webforms"
  And I should see "Feedback Button Label"
  And I should see "Feedback Button Color"
  And I should see "Feedback Form Presentation"
    
Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      | 

# SOME ROLES CAN NOT SELECT A FEEDBACK FORM
@api 
Scenario Outline: CEs and EMCs should not be able to access feedback form settings
Given I am logged in as a user with the <role> role
And am on "admin/settings/forms/feedback"
Then I should see "Access denied"

 Examples:
    | role            | 
    | content_editor  | 
    | edit_my_content  | 

@api 
Scenario: An anonymous user should not be able to access feedback form settings
  When I am on "admin/settings/forms/feedback"
  Then I should see "Access denied"
