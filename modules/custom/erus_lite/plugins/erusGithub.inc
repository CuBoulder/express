<?php

/**
 * @file
 * ERUS GitHub plugin.
 *
 * Uses V3 of the github API.
 */

/**
 * Class ErusGithub.
 */
class ErusGithub {

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

    // Store data for later.
    $this->setUpdateData($data);

    // Make request to GitHub.
    $github_response = $this->githubRequest($machine_name);

    $code = $github_response['response_code'];
    $github_data = $github_response['result'];

    if ($code !== 200) {
      watchdog('erus', 'GitHub API returned with response code: !code  for: !project.', array('!code' => $code, '!project' => $machine_name), WATCHDOG_ERROR);
      return FALSE;
    }

    // If the GitHub data is empty then return.
    if (!is_array($github_data) || empty($github_data)) {
      return FALSE;
    }

    // Convert GH data into update modules data.
    $available = $this->mapData($github_data, $machine_name);
    // Sanitize the status of the data from the original call.
    $this->sanitizeInfoData($data);

    // Allow update module to do its magic.
    update_calculate_project_update_status($machine_name, $data, $available);

    // Small hack to show update is available instead of unsupported.
    if ($data['status'] == 3) {
      $data['status'] = 4;
    }

    return $data;
  }

  /**
   * Makes a GET request to GitHub for project data.
   *
   * @param null|string $project_name
   *   Name of the project that matches GitHub URL.
   *
   * @return array
   *   Data returned from GitHub API request for releases of project.
   */
  protected function githubRequest($project_name = NULL) {

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

    // Get some cURL session information back.
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
   * @param string $project_name
   *   Name of project.
   *
   * @return array
   *   An array of data formatted for the Update module.
   */
  protected function mapData(array $releases, $project_name) {

    $update_data = $this->getUpdateData();
    $data = $this->getDefaultUpdateStatusAvailableDataArray();

    $latest_release = $this->getLatestRelease($releases);
    $dev_release = $this->getLatestDevRelease($releases);

    $latest_prod_tag = !empty($latest_release['tag_name']) ? $latest_release['tag_name'] : $dev_release["tag_name"];

    $data['title'] = $update_data['info']['name'];
    $data['short_name'] = $update_data['name'];
    $data['link'] = $this->getProjectUrl($latest_release);
    $data['last_fetch'] = time();

    $data['recommended_major'] = $this->parseLatestMajor($latest_prod_tag);
    $data['supported_majors'] = implode(",", range(1, 99));
    $data['default_major'] = $this->parseLatestMajor($latest_prod_tag);

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
      $md5 = $this->parseMd5Checksum($release['body']);

      $data['releases'][$tag_name] = array(
        'name' => $update_data['name'] . ' ' . $tag_name,
        'version' => $tag_name,
        'tag' => $tag_name,
        'version_major' => $this->parseLatestMajor($tag_name),
        'version_patch' => $this->parseLatestMinor($tag_name),
        'version_extra' => @$tag_parts[2],
        'status' => 'published',
        'release_link' => $release['html_url'],
        'download_link' => $download_link,
        'date' => strtotime($release['published_at']),
        'mdhash' => !empty($md5) ? $md5 : md5($release['url']),
        // Just making this stuff up.
        'filesize' => isset($release['assets'][0]) ? $release['assets'][0]['size'] : 0,
        'files' => "\n  \n  \n  ",
        'terms' => $this->parseReleaseTerms($release['body']),
      );

    }

    // Sort by name so that the list shows up in the right order.
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
   *
   * Tags should be a comma separated list.
   * E.g. Release type: Bug fixes, New features, Security update.
   *
   * @param string $string
   *   Release description.
   *
   * @return array
   *   An array of data containing release types. Defaults to "Bug Fixes".
   */
  protected function parseReleaseTerms($string = '') {
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
   * @param string $string
   *   String that might contain an MD5 checksum.
   *
   * @return bool|string
   *   An MD5 checksum or FALSE if no matches.
   */
  protected function parseMd5Checksum($string = '') {
    preg_match_all('/md5:.*\n/', $string, $matches);
    $found = array_pop($matches);
    if (!empty($found)) {
      $md5 = str_replace("md5: ", "", $found[0]);
      return trim($md5);
    }
    return FALSE;
  }

  /**
   * Goes through the releases looking for a "pre-lease" tag in the github UI.
   *
   * @param array $releases
   *   An array of all of the release data from GitHub.
   *
   * @return array|bool
   *   An array of data for the latest release or FALSE if none.
   */
  protected function getLatestRelease(array $releases) {
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

    // Silly ksort will put 7.x-1.0-alpha1 in front of 7.x-1.0.
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
   * Looks for the latest tag marked with pre-release.
   *
   * @param array $releases
   *   An array of all of the release data from GitHub.
   *
   * @return array
   *   An array of data for the latest dev release.
   */
  protected function getLatestDevRelease(array $releases) {
    foreach ($releases as $release) {
      if ($release['prerelease'] == TRUE) {
        return $release;
      }
    }
  }

  /**
   * Return a link to the github page.
   *
   * @param array $release
   *   An array of data about a specific release on GitHub.
   *
   * @return string
   *   URL of the project on GitHub.
   */
  protected function getProjectUrl(array $release) {
    $bits = parse_url($release['html_url']);
    $its_n_bits = explode("/", ltrim($bits['path'], "/"));
    return $bits['scheme'] . "://" . $bits['host'] . "/" . $its_n_bits[0] . "/" . $its_n_bits[1];
  }

  /**
   * Used to parse latest minor version from GitHub data.
   *
   * @param string $tag_name
   *   Tag name returned from GitHub.
   *
   * @return string
   *   String of version needed for Update module.
   */
  protected function parseLatestMajor($tag_name) {

    // Figure out what the currently installed major version is. We need
    // to handle both contribution (e.g. "5.x-1.3", major = 1) and core
    // (e.g. "5.1", major = 5) version strings.
    $matches = array();
    if (preg_match('/^(\d+\.x-)?(\d+)\..*$/', $tag_name, $matches)) {
      return $matches[2];
    }
  }

  /**
   * Used to parse latest minor version from GitHub data.
   *
   * @param string $tag_name
   *   Tag name of the latest minor release.
   *
   * @return string
   *   String of version needed for Update module.
   */
  protected function parseLatestMinor($tag_name) {

    $big_bits = explode("-", $tag_name);
    $little_bits = explode(".", $big_bits[1]);
    return $little_bits[1];

  }

  /**
   * Returns an array of default update status fields.
   *
   * @return array
   *   An array of default status update options.
   */
  protected function getDefaultUpdateStatusAvailableDataArray() {
    return array(
      'title' => '',
      'short_name' => '',
      'type' => 'project_module',
      'api_version' => '7.x',
      'recommended_major' => '1',
      'supported_majors' => '1',
      // E.g: (1,2,3 || 1,2 || 3)
      'default_major' => '1',
      'dev_version' => NULL,
      'project_status' => 'published',
      'link' => '',
      'terms' => '',
      'releases' => array(),
      'last_fetch' => 0,
    );
  }

  /**
   * Remove status information from data array.
   */
  protected function sanitizeInfoData(&$data) {
    unset($data['project_status']);
    unset($data['status']);
    unset($data['reason']);
  }

}
