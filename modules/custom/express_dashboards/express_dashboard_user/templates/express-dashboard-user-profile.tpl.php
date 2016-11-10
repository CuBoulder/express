<div class="express-dashboard-user-profile-wrapper">
  <div class="col-md-2 pull-right">
    <?php
      $block = module_invoke('user', 'block_view', 'online');
      print render($block['content']);
    ?>
  </div>
  <p>
    User since: <?php print date('F j, Y', $user['created']); ?>.
  </p>
  <p>
    <small>Roles: <?php print join(', ', $user['roles']); ?></small>
  </p>
</div>
