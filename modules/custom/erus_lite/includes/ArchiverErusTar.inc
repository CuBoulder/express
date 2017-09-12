<?php

/**
 * @file
 * Archiver implementations provided by the system module.
 */

/**
 * Archiver for .tar files.
 */
class ArchiverErusTar extends ArchiverTar {

  public function extract($path, Array $files = array()) {
    parent::extract($path, $files);

    // Check to see if there is nasty verion information on the extracted
    // folder. We need the extracted folder to be named the project name.
    if (preg_match('/temporary:\/\/update\-extraction/i', $path)) {
      $files = $this->listContents();
      $dir_whole = strtok($files[1], '/\\');
      $parts = explode("-", $dir_whole);

      if ($parts[1] == "7.x" && is_numeric($parts[2])) {
        $extract_path = _update_manager_extract_directory();
        $dest_path = $extract_path . "/" . $parts[0];
        // file_unmanaged_move($source, $dest, FILE_EXISTS_REPLACE);

        file_prepare_directory($dest_path, FILE_CREATE_DIRECTORY);
        foreach ($files as $file_path) {

          // For unix system.
          if ($file_path == "pax_global_header") {
            continue;
          }

          $from = $extract_path . "/" . $file_path;
          $to = $extract_path . "/" . str_replace($dir_whole, $parts[0], $file_path);
          file_unmanaged_move($from, $to, FILE_EXISTS_REPLACE);
        }

        // Clean up.
        file_unmanaged_delete_recursive($extract_path . "/" . $dir_whole);
      }
    }

    return $this;
  }

}
