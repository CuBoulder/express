<div id="block-section-<?php print $bean->bid; ?>" class="<?php print $block_section_classes; ?> ucb-colors" <?php print $parallax_data; ?>>
  <div class="block-section-content-wrapper clearfix container">
    <div class="clearfix block-section-content <?php print $content_bg_classes; ?>">
      <?php print render($content['blocks']); ?>
    </div>
  </div>
</div>
<style>
  .block-bean-type-block-section {overflow:hidden;}
</style>
<?php if(isset($image_small) && isset($image_medium) && isset($image_large)): ?>
  <style>
    #block-section-<?php print $bean->bid; ?> {
      background-image:url(<?php print $image_small; ?>);
    }
    @media all and (min-width: 768px) and (max-width: 959px) {
      #block-section-<?php print $bean->bid; ?> {
        background-image:url(<?php print $image_medium; ?>);
      }
    }
    @media all and (min-width: 960px) {
      #block-section-<?php print $bean->bid; ?> {
        background-image:url(<?php print $image_large; ?>);
      }
    }
    @media all and (min-width: 1600px) {
      #block-section-<?php print $bean->bid; ?> {
        background-image:url(<?php print $image_xlarge; ?>);
      }
    }
  </style>
<?php endif; ?>
