Feature: Reports
  Web Express should provide reports in the correct format with expected results.

  @api @reports
  Scenario: There should be no requirements errors listed on a Web Express site.
    Given CU - I run drush "core-requirements" "--severity=2"
    Then the drush output should be empty
