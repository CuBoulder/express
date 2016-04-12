<div class="express-dashboard-user-profile-wrapper">
  <p>
    User since: <?php print date('F j, Y', $user['created']); ?>. You last logged in on <?php print date('F j, Y', $user['access']); ?>
  </p>
  <p>
    <small>Roles: <?php print join(', ', $user['roles']); ?></small>
  </p>
</div>
