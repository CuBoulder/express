<?php
/**
 * @file
 * Contains \SiteAudit\Check\Security security_review checks.
 */

/**
 * Class SecurityReviewSiteAuditCheckAbstract
 */
abstract class SecurityReviewSiteAuditCheckAbstract extends SiteAuditCheckAbstract {
  /**
   * The implementing module.
   * @var string
   */
  protected $module = 'security_review';

  /**
   * The check in question.
   * @var string
   */
  protected $check;

  /**
   * Implements \SiteAudit\Check\Abstract\getLabel().
   */
  public function getLabel() {
    $checks = security_review_get_checklist();
    return $checks[$this->module][$this->check]['title'];
  }

  /**
   * Implements \SiteAudit\Check\Abstract\getDescription().
   */
  public function getDescription() {
    $checks = security_review_get_checklist();
    return dt('Security Check of @title', array(
      '@title' => $checks[$this->module][$this->check]['title'],
    ));
  }

  /**
   * Implements \SiteAudit\Check\Abstract\getResultFail().
   */
  public function getResultFail() {
    $ret_val = $this->registry[$this->module][$this->check]['failure'];
    if (isset($this->registry[$this->module][$this->check]['value'])) {
      if (is_array($this->registry[$this->module][$this->check]['value'])) {
        $ret_val .= $this->generateUl($this->registry[$this->module][$this->check]['value'], drush_get_option('html'));
      }
      elseif ($this->registry[$this->module][$this->check]['value']) {
        $ret_val .= ' Additional: "' . $this->registry[$this->module][$this->check]['value'] . '"';
      }
    }
    return $ret_val;
  }

  /**
   * Generates an unordered list or flattened text version of a nested array.
   *
   * @param array $array
   *   Security Review results.
   * @param bool $html
   *   TRUE if the result should be rendered as HTML.
   * @param int $indentation
   *   The number of spaces; defaults to 6.
   *
   * @return string
   *   Formatted result.
   */
  private function generateUl($array, $html = TRUE, $indentation = 6) {
    $result = $html ? '<ul>' : '';
    foreach ($array as $key => $value) {
      $result .= $html ? '<li>' : PHP_EOL . str_repeat(' ', $indentation);
      $result .= $key . ': ';
      if (is_array($value)) {
        $result .= $this->generateUl($value, $html, $indentation + 2);
      }
      elseif (isset($value->name) && $value->name) {
        $result .= $value->name;
      }
      elseif ($value) {
        $result .= $value;
      }
      $result .= $html ? '</li>' : '';
    }
    $result .= $html ? '</ul>' : '';
    return $result;
  }

  /**
   * Implements \SiteAudit\Check\Abstract\getResultInfo().
   */
  public function getResultInfo() {}

  /**
   * Implements \SiteAudit\Check\Abstract\getResultPass().
   */
  public function getResultPass() {
    return $this->registry[$this->module][$this->check]['success'];
  }

  /**
   * Implements \SiteAudit\Check\Abstract\getResultWarn().
   */
  public function getResultWarn() {}

  /**
   * Implements \SiteAudit\Check\Abstract\getAction().
   */
  public function getAction() {}

  /**
   * Implements \SiteAudit\Check\Abstract\calculateScore().
   */
  public function calculateScore() {
    $checks = security_review_get_checklist();
    $checklist_results = security_review_run(array(
      $this->module => array($checks[$this->module][$this->check]),
    ));

    $this->registry[$this->module][$this->check] = $checklist_results['security_review'][0];
    if (!$this->registry[$this->module][$this->check]['result']) {
      return SiteAuditCheckAbstract::AUDIT_CHECK_SCORE_FAIL;
    }
    else {
      return SiteAuditCheckAbstract::AUDIT_CHECK_SCORE_PASS;
    }
  }
}

class SiteAuditCheckSecurityFilePerms extends SecurityReviewSiteAuditCheckAbstract {
  protected $check = 'file_perms';

  /**
   * Implements \SiteAudit\Check\Abstract\getResultWarn().
   */
  public function getResultFail() {
    if (drush_get_option('detail')) {
      return parent::getResultFail();
    }
    return $this->registry[$this->module][$this->check]['failure'];
  }
}

class SiteAuditCheckSecurityInputFormats extends SecurityReviewSiteAuditCheckAbstract {
  protected $check = 'input_formats';
}

class SiteAuditCheckSecurityField extends SecurityReviewSiteAuditCheckAbstract {
  protected $check = 'field';
}

class SiteAuditCheckSecurityErrorReporting extends SecurityReviewSiteAuditCheckAbstract {
  protected $check = 'error_reporting';
}

class SiteAuditCheckSecurityPrivateFiles extends SecurityReviewSiteAuditCheckAbstract {
  protected $check = 'private_files';
}

class SiteAuditCheckSecurityUploadExtensions extends SecurityReviewSiteAuditCheckAbstract {
  protected $check = 'upload_extensions';
}

class SiteAuditCheckSecurityAdminPermissions extends SecurityReviewSiteAuditCheckAbstract {
  protected $check = 'admin_permissions';
}

class SiteAuditCheckSecurityExecutablePhp extends SecurityReviewSiteAuditCheckAbstract {
  protected $check = 'executable_php';
}

class SiteAuditCheckSecurityBaseUrlSet extends SecurityReviewSiteAuditCheckAbstract {
  protected $check = 'base_url_set';
}

class SiteAuditCheckSecurityTemporaryFiles extends SecurityReviewSiteAuditCheckAbstract {
  protected $check = 'temporary_files';
}
