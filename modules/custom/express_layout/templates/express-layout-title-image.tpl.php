
<div class="feature-layout-title-image">

  <div class="feature-layout-title-image-overlay">
    <?php if (isset($breadcrumb)): ?>
      <div class="title-image-breadcrumbs-wrapper">
        <div class="title-image-breadcrumbs element-max-width-padding"><?php print $breadcrumb; ?></div>
      </div>
    <?php endif; ?>
    <div class="feature-layout-title-image-page-title element-max-width-padding">
      <h1><?php print $title; ?></h1>
      <div class="title-image-byline"></div>
      <?php if (isset($subhead)): ?>
        <div class="subhead">
          <?php print $subhead; ?>
        </div>
      <?php endif; ?>
    </div>
  </div>
</div>
<style>
  .feature-layout-title-image {
    background-image:url(<?php print $img_mobile; ?>);
  }
  @media all and (min-width: 480px) and (max-width: 959px) {
    .feature-layout-title-image {
      background-image:url(<?php print $img_tablet; ?>);
    }
  }
  @media all and (min-width: 960px) {
    .feature-layout-title-image {
      background-image:url(<?php print $img_desktop; ?>);
    }
  }
</style>
