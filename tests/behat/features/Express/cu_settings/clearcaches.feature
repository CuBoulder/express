@settings
Feature: Cache Clearing
In order to get a page to show new edits
An authenticated user with the proper role
Should be able to clear the site caches

#SOME ROLES CAN ACCESS THE SITE CACHES PAGE
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
Scenario: CEs can access the 'Clear Caches' page where they see two tabs
Given I am logged in as a user with the "content_editor" role
And am on "admin/settings/cache/clear"
Then I should see "Which Cache to Clear?"
And I should see the link "Clear Page by Path"

@api 
Scenario: EMCs should not be able to access the 'Clear Caches' page
Given I am logged in as a user with the "edit_my_content" role
And am on "admin/settings/cache/clear"
Then I should see "Access denied"
    
 # NOTE: NO VARNISH ON TRAVIS
  @api 
  Scenario Outline: Devs, Admins, SOs and CEs can Clear Page by Path.
    Given I am logged in as a user with the <role> role
    When I go to "admin/settings/cache/clear/varnish-path"
   And I fill in "edit-clear-varnish-path-cache-path" with "node/1"
   And I press "edit-clear-varnish-path-cache"
   And I wait 20 seconds
   Then I should see "cleared from Page Cache"
   
Examples:
    | role           | 
    | developer      | 
    | administrator  | 
    | site_owner     | 
    | content_editor |

 
 # NOTE: NO VARNISH ON TRAVIS
  @api 
 Scenario: Devs, Admins and SOs can Clear Page Full.
    #NOTE: TESTING ONLY SITE OWNERS SINCE FULL CACHE CLEARS ARE LIMITED TO ONCE PER HOUR
    Given I am logged in as a user with the "site_owner" role
    When I go to "admin/settings/cache/clear/varnish-full"
   #Then I should see "Repeatedly clearing caches will cause"
   And I press "edit-clear-varnish-cache"
   And I wait 20 seconds
   Then I should see "Full Page Cache Cleared"

  #NOTE: THIS TEST DEPENDS ON THE ONE DIRECTLY ABOVE
  Scenario: A Full Page Clear can only be performed once per hour.
    Given I am logged in as a user with the "site_owner" role
    When I go to "admin/settings/cache/clear/varnish-full"
   Then I should see "Repeatedly clearing caches will cause performance problems"
   And the "#edit-clear-varnish-cache" element should have "disabled" in the "disabled" attribute
  
  @api 
 Scenario: Devs, Admins and SOs can Clear Database Full.
    #NOTE: TESTING ONLY SITE OWNERS SINCE FULL CACHE CLEARS ARE LIMITED TO ONCE PER HOUR
    Given I am logged in as a user with the "site_owner" role
    When I go to "admin/settings/cache/clear/drupal-full"
   Then I should see "Repeatedly clearing caches will cause performance problems"
   And I press "edit-clear-drupal-cache"
   And I wait 20 seconds
   Then I should see "Full Page Cache Cleared"

  #NOTE: THIS TEST DEPENDS ON THE ONE DIRECTLY ABOVE
  Scenario: A Full Database Clear can only be performed once per hour.
    Given I am logged in as a user with the "site_owner" role
    When I go to "admin/settings/cache/clear/drupal-full"
   Then I should see "The Full Database Cache cache was recently cleared"
   And the "#edit-clear-drupal-cache" element should have "disabled" in the "disabled" attribute
 
  
