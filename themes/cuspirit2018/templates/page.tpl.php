<div id="page-wrapper" class="page-wrapper">
  <div id="page" class="<?php print $classes; ?>">
    <?php if (!empty($page['alerts'])): ?>
    <div id="alerts-wide-wrapper" class="section-wrapper">
      <div id="alerts" class="clearfix">
        <?php print render($page['alerts']); ?>
      </div>
    </div>
    <?php endif; ?>
    <?php print render($page['branding']); ?>
    <div id="search" tabindex="-1">
      <div class="element-max-width search-wrapper">
        <?php
          if (!empty($page['search_box'])) {
            print render($page['search_box']);
          }
        ?>
      </div>
    </div>
    <div id="header-wrapper" class="section-wrapper header-wrapper">
      <header class="header container-max clearfix" id="header" role="banner">
        <div class="site-name-wrapper col-lg-5 col-md-5 col-sm-12 col-xs-12">
          <div class="site-name-inner">
            <?php
              $site_name_tag = drupal_is_front_page() ? 'h1' : 'div';
            ?>
            <?php if ($site_name): ?>
              <<?php print $site_name_tag; ?> class="site-name">
                <a href="<?php print $front_page; ?>" title="<?php print t('Home'); ?>" class="header__site-link" rel="home"><span><?php print $site_name; ?></span></a>
              </<?php print $site_name_tag; ?>>
              <div class="affiliation">
                COLLEGE OF ENGINEERING &amp; APPLIED SCIENCE
              </div>
            </div>
          <?php endif; ?>
        </div>
        <div class="mobile-menu-toggle menu-toggle">
          <button id="toggle" aria-haspopup="true" aria-expanded="false" aria-controls="mobile-menu" aria-label="Navigation"><i class="fa fa-reorder fa-fw"></i><span class="element-invisible">Menu </span></button>
        </div>
        <div class="search-toggle-wrapper menu-toggle">
          <button id="search-toggle" class="search-toggle" aria-haspopup="true" aria-expanded="false" aria-controls="mobile-menu" aria-label="Search"><i class="fa fa-search fa-fw"></i><span class="element-invisible">Search </span></button>
        </div>
      </header>
    </div>
    <div id="navigation-wrapper" class="navigation-wrapper">
      <?php $secondary_menu = menu_secondary_menu(); ?>
      <?php if (theme_get_setting('use_action_menu') == FALSE && !empty($secondary_menu)): ?>
      <div id="secondary-menu-wrapper" class="section-wrapper">
        <div id="secondary-navigation" class="container-max">
          <div class="secondary-nav-inner col-lg-12 col-md-12 clearfix">
            <?php print render($page['secondary_menu']); ?>
          </div>
        </div>
      </div>
      <?php endif; ?>
      <div id="main-menu-wrapper" class="section-wrapper">
        <div id="navigation" class="container-max">
          <div class="nav-inner col-lg-12 col-md-12 clearfix">
            <?php print render($page['menu']); ?>
          </div>
        </div>
      </div>
    </div>
    <div id="mobile-navigation-wrapper">


      <div id="mobile-navigation">
        <div id="mobile-search">
          <?php
            if (!empty($page['search_box'])) {
              print render($page['search_box']);
            }
          ?>
        </div>
        <nav id="mobile-menu" role="navigation">
        <?php if (isset($mobile_menu) && !empty($mobile_menu)): ?>
          <?php print theme('links', array('links' => $mobile_menu, 'attributes' => array('id' => 'main-menu-mobile', 'class' => array('links', 'clearfix')), 'heading' => array('text' => t('Mobile menu'),'level' => 'h2','class' => array('element-invisible')))); ?>

        <?php else: ?>
          <?php print theme('links', array('links' => $main_menu, 'attributes' => array('id' => 'main-menu-mobile', 'class' => array('links', 'clearfix')), 'heading' => array('text' => t('Mobile menu'),'level' => 'h2','class' => array('element-invisible')))); ?>
          <?php print theme('links', array('links' => $secondary_menu, 'attributes' => array('id' => 'secondary-menu-mobile', 'class' => array('links', 'clearfix')), )); ?>
          <?php if (variable_get('menu_main_links_source', '') != variable_get('menu_footer_links_source', '')): ?>
            <?php print theme('links', array('links' => $footer_menu, 'attributes' => array('id' => 'footer-menu-mobile', 'class' => array('links', 'clearfix')), )); ?>
          <?php endif; ?>
        <?php endif; ?>
        </nav>
      </div>
    </div>
    <div class="express-messages">
      <?php if ($messages): ?>
        <div class="express-message">
          <div class="messages1">
            <?php print $messages; ?>
          </div>
        </div>
      <?php endif; ?>

      <?php if (!empty($tabs['#primary']) || !empty($tabs['#secondary'])): ?>
        <div class="express-message">
          <div class="tabs"><?php print render($tabs); ?></div>
        </div>
      <?php endif; ?>

      <?php if (!empty($page['help'])): ?>
        <div class=" express-message"><?php print render($page['help']); ?></div>
      <?php endif; ?>

      <?php if ($action_links): ?>
        <div class="express-message">
          <ul class="action-links"><?php print render($action_links); ?></ul>
        </div>
      <?php endif; ?>
    </div>
    <div class="top-content-wrapper"><div class="top-content">
      <?php if (!empty($page['intro'])): ?>
      <div id="intro-wide-wrapper" class="section-wrapper">
        <?php print render($page['intro']); ?>
      </div>
      <?php endif; ?>

      <?php if (!empty($page['slider'])): ?>
      <div id="slider-wrapper" class="section-wrapper slider-wrapper<?php if (!empty($page['slider_sidebar'])) { print 'has-slider-sidebar'; } ?>">
        <div id="slider" class="clearfix element-max-width-padding">
          <?php print render($page['slider']); ?>
        </div>
      </div>
      <?php endif; ?>
      <?php if (isset($title_image) && !drupal_is_front_page()): ?>
        <?php
          $vars = array(
            'title_image_width' => $title_image_width,
            'title_image_wrapper_class' => $title_image_wrapper_class,
            'title_image' => $title_image,
          );
          print theme('page_title_image', $vars);
        ?>
      <?php endif; ?>

      <div id="content-wrapper" class="section-wrapper content-wrapper">
        <div class="section-wrapper title-wrapper">

        </div>
        <div id="main" class="clearfix">
          <div class="clearfix container-max content-inner-wrapper">
            <div class="breadcrumb-wrapper col-lg-12 col-md-12 col-sm-12 col-xs-12">
              <?php print $breadcrumb; ?>
            </div>
            <div class="main-title-wrapper col-lg-12 col-md-12 col-sm-12 col-xs-12">
              <a id="main-content"></a>
              <?php print render($title_prefix); ?>
              <?php if ($title): ?>
                <h1 class="page__title title <?php if (isset($title_hidden)) { print 'element-invisible'; } ?>" id="page-title"><?php print $title; ?></h1>
              <?php endif; ?>
              <?php print render($title_suffix); ?>
            </div>



          </div>
          <?php if (!empty($page['post_title_wide'])): ?>
            <div id="post-title-wide-wrapper" class="section-wrapper">
              <?php print render($page['post_title_wide']); ?>
            </div>
          <?php endif; ?>
          <?php if (!empty($page['post_title'])): ?>
            <div id="post-title-wrapper" class="section-wrapper container-max">
              <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                <?php print render($page['post_title']); ?>
              </div>
            </div>
          <?php endif; ?>
          <div id="main-content-wrapper" class="container-max">
            <div id="content" class="<?php print $main_content_classes; ?>" role="main">
              <?php print render($page['content']); ?>
              <?php print $feed_icons; ?>
            </div>


            <?php
              // Render the sidebars to see if there's anything in them.
              $sidebar_first  = render($page['sidebar_first']);
              $sidebar_second = render($page['sidebar_second']);
            ?>

            <?php
              // Order the sidebars depending on which is the primary sidebar
              if ($sidebar_first || $sidebar_second): ?>
              <aside class="sidebars">
                <?php if (theme_get_setting('primary_sidebar') == 'primary-sidebar-first'): ?>
                  <div class="sidebar-first sidebar <?php print $sidebar_first_classes; ?>">
                    <?php print $sidebar_first; ?>
                  </div>
                  <div class="sidebar-second sidebar <?php print $sidebar_second_classes; ?>">
                    <?php print $sidebar_second; ?>
                  </div>
                <?php else: ?>
                  <div class="sidebar-second sidebar <?php print $sidebar_second_classes; ?>">
                    <?php print $sidebar_second; ?>
                  </div>
                  <div class="sidebar-first sidebar <?php print $sidebar_first_classes; ?>">
                    <?php print $sidebar_first; ?>
                  </div>
                <?php endif; ?>
              </aside>
            <?php endif; ?>
          </div>
        </div>
      </div>

      <?php if (!empty($page['feature_layout'])): ?>
        <div id="feature-layout-wrapper" class="section-wrapper feature-layout-wrapper">
          <?php print render($page['feature_layout']); ?>
        </div>
      <?php endif; ?>

      <?php if (!empty($page['wide_2'])): ?>
        <div id="post-wide-wrapper" class="section-wrapper post-wide-wrapper">
          <?php print render($page['wide_2']); ?>
        </div>
      <?php endif; ?>

      <?php if (!empty($page['after_content'])): ?>
        <div id="after-content-wrapper" class="section-wrapper after-content-wrapper">
          <div id="after-content" class="container-max">
            <?php print render($page['after_content']); ?>
          </div>
        </div>
      <?php endif; ?>
    </div></div>
    <?php if (!empty($page['lower'])): ?>
      <div id="after-content2-wrapper" class="section-wrapper after-content2-wrapper">
        <div id="after-content-2" class="container-max">
          <?php print render($page['lower']); ?>
        </div>
      </div>
    <?php endif; ?>


    <div id="footer-section" class='footer-section'>
      <?php if (!empty($page['footer'])): ?>
        <div id="footer-wrapper" class="section-wrapper footer-wrapper">
          <div id="footer" class="footer container-max">
            <div class="col-lg-12 col-md-12">
              <div class="row">
                <?php print render($page['footer']); ?>
              </div>
            </div>
          </div>
        </div>
      <?php endif; ?>

      <?php if (isset($footer_menu) && !empty($footer_menu)): ?>
        <div id="footer-menu-wrapper" class="section-wrapper footer-menu-wrapper <?php print $footer_menu_color; ?>">
          <div id="footer-navigation" class="container-max">
            <div class="nav-inner col-lg-12 col-md-12 clearfix">
              <nav id="footer-menu">
              <?php print theme('links__footer_menu', array('links' => $footer_menu, 'attributes' => array('id' => 'footer-menu-links', 'class' => array('links', 'inline-menu', 'clearfix')), 'heading' => array('text' => t('Footer menu'),'level' => 'h2','class' => array('element-invisible')))); ?>
              </nav>
            </div>
          </div>
        </div>
      <?php endif; ?>
      <div id="site-info-wrapper" class="section-wrapper site-info-wrapper">
        <div id="site-info" class="container-max">
          <?php print render($page['site_info']); ?>
        </div>
      </div>
    </div>
  </div>
</div>
<?php print render($page['bottom']); ?>