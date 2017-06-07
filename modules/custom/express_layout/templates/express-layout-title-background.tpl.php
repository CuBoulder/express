
<div class="feature-layout-title-background <?php print $background_color; ?>">

    <?php if (isset($breadcrumb)): ?>
      <div class="title-background-breadcrumbs-wrapper">
        <div class="title-background-breadcrumbs element-max-width-padding"><?php print $breadcrumb; ?></div>
      </div>
    <?php endif; ?>
    <div class="feature-layout-title-image-page-title element-max-width-padding">
      <h1 class="page-title-image-title"><?php print $title; ?></h1>
      <div class="title-image-byline"></div>
      <?php if (isset($subhead)): ?>
        <div class="subhead">
          <?php print $subhead; ?>
        </div>
      <?php endif; ?>
    </div>
</div>
