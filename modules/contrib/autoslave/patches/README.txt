In recent versions of D7 core such as 7.54, the deadlock mitigation patch is not required. actually not required since 7.22
so these patches were moved into the : legacy_patches_no_longer_needed folder

However, these following patches for core ARE still required:
1) D7 core patch from issue #1893996 apply this to drupal core 7.54 or newer. 
   (link to patch is below, most recent D7 patch as of writing)
 - https://www.drupal.org/files/1893996-1-simpletest-prefix.patch (apply this patch to drupal core 7.54 or newer)
   #for more info, see drupal.org/node/1893996
2) D7 core patch 30 from issue #1889328 apply this to drupal core 7.54 or newer.
   (link to patch is below, most recent D7 patch as of writing)
 - https://www.drupal.org/files/issues/1889328-30-query-options.patch
