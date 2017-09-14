<?php

use Drupal\DrupalExtension\Context\RawDrupalContext;
use Behat\Behat\Context\SnippetAcceptingContext;
use Drupal\DrupalExtension\Context\DrushContext;

/**
 * Defines application features from the specific context.
 */
class CuDrushContext extends RawDrupalContext implements SnippetAcceptingContext {

  /**
   * Passed in DrupalContext instance to use protected methods.
   *
   * @var \Drupal\DrupalExtension\Context\DrushContext
   */
  private $drushContext;

  /**
   * Drush output as string used to check values in other functions.
   *
   * @var
   */
  private $drushOutput;

  /**
   * Initializes context.
   *
   * Every scenario gets its own context instance.
   * You can also pass arbitrary arguments to the
   * context constructor through behat.yml.
   */
  public function __construct() {
    $this->drushContext = new DrushContext();
  }

  /**
   * @Given CU - I run drush :command :arguments
   */
  public function assertDrushCommandWithArgument($command, $arguments) {
    $this->drushOutput = $this->getDriver('drush')->$command($this->fixStepArgument($arguments));
    if (!isset($this->drushOutput)) {
      $this->drushOutput = TRUE;
    }
  }

  /**
   * @Then the drush output should be empty
   */
  public function drushOutputShouldBeEmpty() {
    if (!empty($this->drushOutput)) {
      throw new \Exception(sprintf("The last drush command output was not empty.\nOutput:\n\n%s'", $this->drushOutput));
    }
  }

  /**
   * Returns fixed step argument (with \\" replaced back to ").
   *
   * @param string $argument
   *
   * @return string
   */
  protected function fixStepArgument($argument) {
    return str_replace('\\"', '"', $argument);
  }

}

