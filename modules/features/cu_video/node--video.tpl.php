<?php if($view_mode == 'teaser'): ?>
  <div class="video-view-mode-teaser node-view-mode-teaser clearfix">
    <?php if(!empty($content['field_video'])): ?>
      <?php print render($content['field_video']); ?>
    <?php endif; ?>
    <div class="video-view-mode-teaser-content node-view-mode-teaser-content">
      <h2<?php print $title_attributes; ?>><a href="<?php print $node_url; ?>"><?php print $title; ?></a></h2>
      <div class="video-summary"><?php print render($content['body']); ?></div>
    </div>
  </div>
<?php elseif($view_mode == 'embed'): ?>
  <div class="video-view-mode-embed node-view-mode-embed clearfix">
    <div class="video-view-mode-embed-content node-view-mode-embed-content">
      <h3<?php print $title_attributes; ?>><a href="<?php print $node_url; ?>"><?php print $title; ?></a></h3>
      <div class="node-view-mode-embed-summary video-view-mode-embed-summary"><?php print render($content['body']); ?></div>
      <?php print render($content); ?>
    </div>
  </div>
<?php elseif($view_mode == 'sidebar'): ?>
  <div class="video-view-mode-sidebar clearfix node-view-mode-sidebar">
    <?php if(!empty($content['field_video'])): ?>
      <?php print render($content['field_video']); ?>
    <?php endif; ?>
    <div class="video-view-mode-sidebar-content node-view-mode-sidebar-content">
      <a href="<?php print $node_url; ?>"><?php print $title; ?></a>
    </div>
  </div>
<?php elseif($view_mode == 'title'): ?>
  <div class="video-view-mode-title node-view-mode-title clearfix">
    <div class="video-view-mode-titles-content node-view-mode-titles-content">
      <a href="<?php print $node_url; ?>"><?php print $title; ?></a>
    </div>
  </div>
<?php else: ?>
  <?php print render($content['body']); ?>
  <?php print render($content['field_video']); ?>
<?php endif; ?>
