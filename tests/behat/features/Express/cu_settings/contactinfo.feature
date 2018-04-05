@settings
Feature: Site Contact populates Site Information region
In order to provide contact information about the site
Authenticated users with the proper role
Should be able to add Contact Information

#SOME ROLES CAN SET THE SITE CONTACT
@api
Scenario Outline: Devs, Admins and SOs can set the Site Contact
  Given I am logged in as a user with the <role> role
  And am on "admin/settings/site-configuration/contact"
  And fill in "Contact Information" with <address>
  And I press "edit-submit"
  Then I should see "The configuration options have been saved"
  And I go to "/"
  Then I should see <address>
    
Examples:
    | role            | address | 
    | developer       | 1234 Fifth Street | 
    | administrator   | email@example.edu |
    | site_owner      | 303-123-4567 |

# SOME ROLES CAN NOT SET SITE CONTACT
@api 
Scenario Outline: CEs and EMCs should not be able to set site name
Given I am logged in as a user with the <role> role
And am on "admin/settings/site-configuration/contact"
Then I should see "Access denied"

 Examples:
    | role            | 
    | content_editor  | 
    | edit_my_content  | 
    
@api 
Scenario: An anonymous user should not be able to set site name
  When I am on "admin/settings/site-configuration/contact"
  Then I should see "Access denied"
