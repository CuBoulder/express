
<div class="feature-layout-title-image">

  <div class="feature-layout-title-image-overlay">
    <?php if ($breadcrumb): ?>
      <div class="title-image-breadcrumbs-wrapper">
        <div class="title-image-breadcrumbs container"><?php print $breadcrumb; ?></div>
      </div>
    <?php endif; ?>
    <div class="feature-layout-title-image-page-title container">
      <h1><?php print $title; ?></h1>
      <div class="title-image-byline"></div>

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
