<div class="node-teaser view-mode-teaser">
  <?php if ($thumbnail): ?>
    <?php print render($thumbnail); ?>
  <?php endif; ?>
  <div class="node-content node-teaser-content">
    <h2><?php print $title; ?>
    <?php print render($content['body']); ?>
  </div>
</div>
