@settings
Feature: Settings and Site Configurations page
When I am on the admin/settings
As a user with the proper role
I should be able to set the site name, enable bundles and other configurations as defined

@api 
Scenario Outline: Devs, Admins and SOs can access Site Configurations
    Given  I am logged in as a user with the <role> role
    When I go to "admin/settings"
    Then I should see "Site Configurations"
    # WE MAY WANT TO ADD OTHER LINKS THAT THEY SEE

    Examples:
      | role           |
      | site_owner     |
      | administrator  |
      | developer      |
      
@api 
  Scenario Outline: CEs and EMCs cannot access Site Configurations
    Given  I am logged in as a user with the <role> role
    When I go to "admin/settings"
    Then I should not see "Site Configurations"

    Examples:
      | role            |
      | content_editor  |
      | edit_my_content |
      
