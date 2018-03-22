@settings
Feature: Cache Clearing
In order to get a page to show new edits
An authenticated user with the proper role
Should be able to clear the site caches

# ACCESSING THE CLEAR CACHES LANDING PAGE
@api
Scenario Outline: Devs, Admins and SOs can access the 'Clear Caches' page where they see four tabs
  Given I am logged in as a user with the <role> role
  And am on "admin/settings/cache/clear"
 Then I should see "Which Cache to Clear?"
  And I should see the link "Clear Page by Path"
  And I should see the link "Clear Page Full"
  And I should see the link "Clear Database Full"
    
Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      | 

@api 
Scenario: CEs can access the 'Clear Caches' landing page where they see two tabs
Given I am logged in as a user with the "content_editor" role
And am on "admin/settings/cache/clear"
Then I should see "Which Cache to Clear?"
And I should see the link "Clear Page by Path"

@api 
Scenario: EMCs should not be able to access the 'Clear Caches' landing page
Given I am logged in as a user with the "edit_my_content" role
And am on "admin/settings/cache/clear"
Then I should see "Access denied"
    
 # TESTING THE CLEAR-PAGE-BY-PATH FUNCTIONALITY
  @api 
  Scenario Outline: Devs, Admins, SOs and CEs can Clear Page by Path.
  Given I am logged in as a user with the <role> role
  When I go to "admin/settings/cache/clear/varnish-path"
  Then I should see "Enter the specific path or URL to clear from the Page cache."
  And I fill in "edit-clear-varnish-path-cache-path" with <testpath>
  And I press "edit-clear-varnish-path-cache"
  And I wait 60 seconds
  Then the response should contain "Status message"
  And I should see "cleared from Page Cache"
   
Examples:
    | role           | testpath   |
    | developer      | "node/123" |
    | administrator  | "node/234" |
    | site_owner     | "node/345" |
    | content_editor | "node/456" |


# ACCESSING THE CLEAR-PAGE-FULL PAGE
@api
Scenario Outline: Devs, Admins and SOs can access the 'Clear Page Full' tag; CEs and EMCs cannot
  Given I am logged in as a user with the <role> role
  When I go to "admin/settings/cache/clear/varnish-full"
 Then I should see <message>
    
Examples:
    | role             | message |
    | developer        | "Repeatedly clearing caches will cause performance problems for you" |
    | administrator    | "Repeatedly clearing caches will cause performance problems for you" |
    | site_owner       | "Repeatedly clearing caches will cause performance problems for you" |
    | content_editor   | "Access denied" |
    | edit_my_content  | "Access denied" |

# NOTE: NO VARNISH ON TRAVIS; TESTING CONTENT ONLY
  @api 
 Scenario Outline: Devs, Admins and SOs can Clear Page Full.
    Given I am logged in as a user with the <role> role
    When I go to "admin/settings/cache/clear/varnish-full"
    Then I should see "Repeatedly clearing caches will cause performance problems"
  # And I press "edit-clear-varnish-cache"
  # And I wait 20 seconds
  # Andn I should see "Full Page Cache Cleared"
   
   Examples:
    | role           | 
    | developer      | 
    | administrator  | 
    | site_owner     | 


# ACCESSING THE CLEAR-DATABASE-FULL PAGE
@api
Scenario Outline: Devs, Admins and SOs can access the 'Clear Database Full' tag; CEs and EMCs cannot
  Given I am logged in as a user with the <role> role
  When I go to "admin/settings/cache/clear/drupal-full"
 Then I should see <message>
    
Examples:
    | role             | message |
    | developer        | "Repeatedly clearing caches will cause performance problems for you" |
    | administrator    | "Repeatedly clearing caches will cause performance problems for you" |
    | site_owner       | "Repeatedly clearing caches will cause performance problems for you" |
    | content_editor   | "Access denied" |
    | edit_my_content  | "Access denied" |
    
   
 # NOTE: NO VARNISH ON TRAVIS; TESTING CONTENT ONLY
@api 
 Scenario Outline: Devs, Admins and SOs can Clear Database Full.
   Given I am logged in as a user with the <role> role
   When I go to "admin/settings/cache/clear/drupal-full"
   Then I should see "Repeatedly clearing caches will cause performance problems"
   # And I press "edit-clear-drupal-cache"
  # And I wait 20 seconds
  # And I should see "Full Page Cache Cleared"

   Examples:
    | role           | 
    | developer      | 
    | administrator  | 
    | site_owner     
 
  
