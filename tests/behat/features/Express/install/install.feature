#A NEW WEB EXPRESS INSTALLATION

@homepage @rebuild
Feature: A fresh installation of Web Express has one page
  When I view a fresh Web Express installation
  As a user
  I should be able to see certain content

Scenario: A user should see "Welcome!" on the homepage
      Given I am on the homepage
      Then I should see "University of Colorado Boulder"
      And I should see a ".fa-home" element
      And I should see a ".search-toggle" element
      And I should see "Welcome to your new Web Express website"
      And I should see the link "University of Colorado Boulder"
      And I should see a ".beboulder" element

