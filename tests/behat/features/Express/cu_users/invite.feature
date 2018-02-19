Feature: User External Invite
  Given I am an administrator
  When I login to a Web Express site
  I should be able to invite users to my site

  @api @invite
  Scenario: Invite page has correct variables set.
    Given I am logged in as a user with the "site_owner" role
    When I go to "/admin/people/invite"
    Then I should not see "Your site is not yet configured to invite users. Contact the site administrator to configure the invite feature."
      And I should see "Content Editor"
      And I should see "Site Owner"

  @api @invite
  Scenario: A developer can access the user invite configuration form.
    Given I am logged in as a user with the "developer" role
    When I go to "admin/config/people/invite"
    Then I should see "Number of days invites are valid"
      And I should see "Invitation Accepted Email Template"


