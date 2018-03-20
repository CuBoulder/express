@settings
Feature: Site Description
In order to optimize search engine results
Authenticated users with the proper role
Should be able to add a Site Description

#SOME ROLES CAN SET THE SITE NAME
@api
Scenario: Devs, Admins and SOs can set the Site Description
  Given I am logged in as a user with the <role> role
  And am on "admin/settings/site-configuration/site-description"
  And fill in "site_description" with "We offer personalized career development"
  When I press "Save"
  Then I should see "The configuration options have been saved"
  And I go to "/"
  Then I should see a neta tag with name'description and content ='we offer personalized'
    
Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      | 

# SOME ROLES CAN NOT SET SITE DESCRIPTION
@api 
Scenario Outline: CEs and EMCs should not be able to set site name
Given I am logged in as a user with the <role> role
And am on "admin/settings/site-configuration/site-description"
Then I should see "Access denied"

 Examples:
    | role            | 
    | content_editor  | 
    | edit_my_content  | 
