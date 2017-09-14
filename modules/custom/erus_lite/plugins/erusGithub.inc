<?php

/**
 * ERUS GitHub plugin.
 * @file
 *
 * Uses V3 of the github API.
 */

/**
 * Class erusGithub.
 */
class erusGithub {

  protected $updateData = array();

  /**
   * Sets updateData variable.
   *
   * @param array $data
   *   Data needed by the update module.
   */
  protected function setUpdateData(array $data) {
    $this->updateData = $data;
  }

  /**
   * Gets updateData variable.
   *
   * @return array
   *   An array of update data.
   */
  protected function getUpdateData() {
    return $this->updateData;
  }

  /**
   * The Magic Happens.
   *
   * @param array $data
   *   Update data for Drupal project.
   *
   * @return bool|array
   *   Update array manipulated to take in account GitHub data.
   */
  public function process($data) {

    // Project machine name.
    $machine_name = $data['info']['project'];

    // Go old or go home.
    if (!isset($data['info']['datestamp'])) {
      $data['info']['datestamp'] = 0;
    }

    // Store data for later
    $this->setUpdateData($data);

    // Make request to GitHub.
    $github_response = $this->github_request($machine_name);

    $code = $github_response['response_code'];
    $github_data = $github_response['result'];

    if ($code !== 200) {
      watchdog('erus', 'GitHub API returned with response code: ' . $code . ' for: ' . $machine_name, array(), WATCHDOG_ERROR);
      return FALSE;
    }

    // If the GitHub data is empty then return.
    if (!is_array($github_data) || empty($github_data)) {
      return FALSE;
    }

    // Convert GH data into update modules data.
    $available = $this->map_data($github_data, $machine_name);
    // Sanitize the status of the data from the original call
    $this->sanitize_info_data($data);

    // Allow update module to do its magic.
    update_calculate_project_update_status($machine_name, $data, $available);

    // Small hack to show update is available instead of unsupported...
    if ($data['status'] == 3) {
      $data['status'] = 4;
    }

    return $data;
  }

  /**
   * @param null|string $project_name
   *   Name of the project that matches GitHub URL.
   *
   * @return array
   *   Data returned from GitHub API request for releases of project.
   */
  protected function github_request($project_name = NULL) {

    // Setup cURL request.
    $curl = curl_init();
    $request_path = 'https://api.github.com/repos/CuBoulder/' . $project_name . '/releases';
    curl_setopt($curl, CURLOPT_URL, $request_path);

    // Return the transfer as a string of the values if the curl succeeds.
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, TRUE);

    // Need to add User-Agent or else you get a 403.
    curl_setopt($curl, CURLOPT_HTTPHEADER, array(
      'Content-Type: application/json',
      'User-Agent: Web Express',
    ));

    // Make request.
    $result = curl_exec($curl);

    // Get some cURL session information back
    $info = curl_getinfo($curl);
    $code = $info['http_code'];
    curl_close($curl);

    // Add response code to returned data.
    $data = array();
    $data['result'] = json_decode($result, TRUE);
    $data['response_code'] = $code;

    return $data;
  }

  /**
   * Maps the GH response data into Update status usable format.
   *
   * @param array $releases
   *   An array of information about project releases.
   *
   * @param string $project_name
   *   Name of project
   *
   * @return array
   */
  protected function map_data($releases, $project_name) {

    $update_data = $this->getUpdateData();
    $data = $this->get_default_update_status_available_data_array();

    $latest_release = $this->get_latest_release($releases);
    $dev_release = $this->get_latest_dev_release($releases);

    $latest_prod_tag = !empty($latest_release['tag_name']) ? $latest_release['tag_name'] : $dev_release["tag_name"];

    $data['title'] = $update_data['info']['name'];
    $data['short_name'] = $update_data['name'];
    $data['link'] = $this->get_project_url($latest_release);
    $data['last_fetch'] = time();

    $data['recommended_major'] = $this->parse_latest_major($latest_prod_tag);
    $data['supported_majors'] = implode(",", range(1, 99));
    $data['default_major'] = $this->parse_latest_major($latest_prod_tag);

    foreach ($releases as $release) {
      $tag_name = $release['tag_name'];
      $tag_parts = explode('-', $tag_name);

      // Create a url to the tarball.
      $download_link = "https://github.com/CuBoulder/" . $project_name . "/archive/" . $release['tag_name'] . ".tar.gz";

      // If there is an asset use that one.
      if (isset($release['assets'][0])) {
        $download_link = "https://github.com/CuBoulder/" . $project_name . "/releases/download/" . $release['tag_name'] . "/" . $release['assets'][0]['name'];
      }

      // GH doesn't provide a checksum on files. We will have to provide it in the body.
      $md5 = $this->parse_md5_checksum($release['body']);

      $data['releases'][$tag_name] = array(
        'name' => $update_data['name'] . ' ' . $tag_name,
        'version' => $tag_name,
        'tag' => $tag_name,
        'version_major' => $this->parse_latest_major($tag_name),
        'version_patch' => $this->parse_latest_minor($tag_name),
        'version_extra' => @$tag_parts[2],
        'status' => 'published',
        'release_link' => $release['html_url'],
        'download_link' => $download_link,
        'date' => strtotime($release['published_at']),
        'mdhash' => !empty($md5) ? $md5 : md5($release['url']),
        // just making this stuff up.
        'filesize' => isset($release['assets'][0]) ? $release['assets'][0]['size'] : 0,
        'files' => "\n  \n  \n  ",
        'terms' => $this->parse_release_terms($release['body']),
      );

    }

    // sort by name so that the list shows up as:
    // 7.x-1.1-alpha1
    // 7.x-1.0
    // 7.x-1.0-beta11
    // 7.x-1.0-beta10
    // 7.x-1.0-beta9

    $keys = array_keys($data['releases']);

    uasort($keys, function ($a, $b) {
      if ($a == $b) {
        return 0;
      }
      $a = str_replace('7.x-', '', $a);
      $b = str_replace('7.x-', '', $b);

      return version_compare($a, $b, '>') ? -1 : 1;
    }
    );
    $keys = array_flip($keys);
    $data['releases'] = array_merge($keys, $data['releases']);
    return $data;
  }

  /**
   * Look for "Release type:" in the body of a release for tag information.
   * Tags should be a comma separated list
   * eg: Release type: Bug fixes, New features, Security update
   *
   * @param string $string [description]
   *
   * @return [type]         [description]
   */
  protected function parse_release_terms($string = '') {
    $terms = array('Release type' => array());

    preg_match_all('/Release type:.*\n/', $string, $matches);
    $found = array_pop($matches);

    if (!empty($found)) {
      $found = str_replace("Release type:", "", $found[0]);
      $found = str_replace(", ", ",", $found);
      $found = str_replace(" ,", ",", $found);
      $found = trim($found);
      $terms['Release type'] = explode(",", $found);
    }
    else {
      $terms['Release type'] = array('Bug fixes');
    }

    return $terms;
  }

  /**
   * Parses out the md5 checksum value from the body of a release.
   * This is needed for 'drush up' to work
   *
   * @param  string $string [description]
   *
   * @return [type]         [description]
   */
  protected function parse_md5_checksum($string = '') {
    preg_match_all('/md5:.*\n/', $string, $matches);
    $found = array_pop($matches);
    if (!empty($found)) {
      $md5 = str_replace("md5: ", "", $found[0]);
      return trim($md5);
    }
    return FALSE;
  }


  /**
   * Goes through the releases looking for a release that isnt marked as
   * a "pre-lease" in the github ui.
   *
   * @param  [array] $releases [all of the releases from GH]
   *
   * @return [array]           [the latest marked as non prerelease]
   */
  protected function get_latest_release($releases) {
    $potentials = array();

    foreach ($releases as $release) {
      if ($release['draft'] === TRUE || $release['prerelease'] === TRUE) {
        continue;
      }
      $potentials[$release['tag_name']] = $release;
    }

    if (empty($potentials)) {
      return FALSE;
    }

    // Silly ksort will put 7.x-1.0-alpha1 in front of 7.x-1.0
    krsort($potentials);
    $key = array_shift($potentials);

    $parts = explode("-", $key["tag_name"]);
    if (isset($potentials[$parts[0] . "-" . $parts[1]])) {
      return $potentials[$parts[0] . "-" . $parts[1]];
    }
    else {
      return $key;
    }

  }

  /**
   * Looks for the latest tag marked with pre-release
   *
   * @param  [type] $releases [description]
   *
   * @return [type]           [description]
   */
  protected function get_latest_dev_release($releases) {
    foreach ($releases as $release) {
      if ($release['prerelease'] == TRUE) {
        return $release;
      }
    }
  }

  /**
   * Return a link to the github page.
   *
   * @param  [type] $releases [description]
   *
   * @return [type]           [description]
   */
  protected function get_project_url($release) {
    $bits = parse_url($release['html_url']);
    $its_n_bits = explode("/", ltrim($bits['path'], "/"));
    return $bits['scheme'] . "://" . $bits['host'] . "/" . $its_n_bits[0] . "/" . $its_n_bits[1];
  }

  /**
   * [parse_latest_major description]
   *
   * @param  [type] $tag_name [description]
   *
   * @return [type]           [description]
   */
  protected function parse_latest_major($tag_name) {

    // Figure out what the currently installed major version is. We need
    // to handle both contribution (e.g. "5.x-1.3", major = 1) and core
    // (e.g. "5.1", major = 5) version strings.
    $matches = array();
    if (preg_match('/^(\d+\.x-)?(\d+)\..*$/', $tag_name, $matches)) {
      return $matches[2];
    }

  }

  /**
   * [parse_latest_minor description]
   *
   * @param  [type] $tag_name [description]
   *
   * @return [type]           [description]
   */
  protected function parse_latest_minor($tag_name) {

    $big_bits = explode("-", $tag_name);
    $little_bits = explode(".", $big_bits[1]);
    return $little_bits[1];

  }

  /**
   * Returns an array of default update status fields
   *
   * @return [type]                [description]
   */
  protected function get_default_update_status_available_data_array() {
    return array(
      'title' => '',
      'short_name' => '',
      'type' => 'project_module',
      'api_version' => '7.x',
      'recommended_major' => '1',
      'supported_majors' => '1',
      // eg: 1,2,3 || 1,2 || 3
      'default_major' => '1',
      'dev_version' => NULL,
      'project_status' => 'published',
      // published, insecure, revoked, unpublished, not-fetched
      'link' => '',
      'terms' => '',
      'releases' => array(
        // 'tag_name' => array(
        //   'name' => '',
        //   'version' => '',
        //   'tag' => '',
        //   'version_major' => '',
        //   'version_patch' => '',
        //   'version_extra' => '',
        //   'status' => '',
        //   'release_link' => '',
        //   'download_link' => '',
        //   'date' => '',
        //   'mdhash' => '',
        //   'filesize' => '',
        //   'files' => '',
        //   'terms' => array(
        //     'Release type' => array(
        //       'New features', 'Bug fixes',
        //     )
        //   ),
        // )
      ),
      'last_fetch' => 0,
    );
  }

  /**
   * Remove status information from data array
   */
  protected function sanitize_info_data(&$data) {
    unset($data['project_status']);
    unset($data['status']);
    unset($data['reason']);
  }
}
