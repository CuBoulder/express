
Bundled with AutoSlave are a couple of patches for older versions of Drupal core (newer versions don't need these ones, see patches/README.txt for the recent ones that ARE needed/recommended):

* deadlock-mitigation-7.22.patch:
Instead of delete a row from the variable table when using variable_del(), the variable is just set to NULL. This is to reduce the effect of gap-locking under MySQLs REPEATABLE-READ isolation level. This will of course make the variable table grow in size, but reduce potential deadlocks. The NULL values are not cached, thereby keeping the variable cache at the same size (or less) as without the patch.

* drush-pdo-7.x-5.8.patch:
Drush checks the $databases configuration directly against PDO. As the "autoslave" drivers is not a PDO extension, this check will fail. The patch bypasses this check. If using this patch (which is recommended), the above workaround in the example should not be used.

* update-pdo-7.22.patch:
update.php checks the $databases configuration directly against PDO. As the "autoslave" drivers is not a PDO extension, this check will fail. The patch bypasses this check for autoslave configurations. If using this patch (which is recommended), the above workaround in the example should not be used.

