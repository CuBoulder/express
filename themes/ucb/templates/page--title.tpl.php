<div class="page-wrapper">
  <div class="page <?php print $classes; ?>">
    <!-- ALERTS -->
    <?php if (!empty($page['alerts'])): ?>
      <div id="alerts-wide-wrapper" class="section">
        <div id="alerts" class="clearfix">
          <?php print render($page['alerts']); ?>
        </div>
      </div>
    <?php endif; ?>

    <!-- CAMPUS BRANDING -->
    <?php print render($page['branding']); ?>
    <!-- /CAMPUS BRANDING -->

    <!-- DESKTOP SEARCH -->
    <div id="search" tabindex="-1" class="background-black">
      <div id="search-inner">
        <div class="container container-small">
          <div class="search-form">

            <?php print render($search_desktop); ?>
            <button id="close-search"><i class="fa fa-times" aria-hidden="true"></i><span class="element-invisible">Close</span></button>
          </div>
        </div>
      </div>
    </div>
    <!-- /DESKTOP SEARCH -->

    <!-- SITE HEADER -->
    <div id="header-wrapper" class="section header-wrapper no-underline cu-header">
      <div class="container">
      <header class="ucb header clearfix" id="header" role="banner" tabindex="-1">
        <div class="site-name-wrapper">

            <?php
              $vars = array();
              $vars['site_name_tag'] = drupal_is_front_page() ? 'h1' : 'div';
              $vars['affiliation'] = variable_get('express_site_affiliation', NULL);
              $vars['site_name'] = $site_name;
              $vars['front_page'] = url('<front>');
              print theme('site_name', $vars);
            ?>

        </div>
        <div class="mobile-menu-toggle menu-toggle">
          <button id="toggle" aria-haspopup="true" aria-expanded="false" aria-controls="mobile-menu" aria-label="Navigation"><i class="fa fa-reorder fa-fw" aria-hidden="true"></i><span class="mobile-menu-text">Menu </span></button>
        </div>
      </header>
    </div>
    </div>
    <!-- /SITE HEADER -->

    <!-- NAVIGATION -->
    <div id="navigation-wrapper" class="navigation-wrapper section no-underline">

      <!-- Main menu -->
      <div id="main-menu-wrapper" class="section">
        <div id="navigation" class="container">
          <div class="nav-inner clearfix">
            <?php print render($page['menu']); ?>
          </div>
        </div>
      </div>
      <!-- /Main menu -->
      <!-- Secondary menu under main menu -->
      <?php $secondary_menu = menu_secondary_menu(); ?>
      <?php if (theme_get_setting('use_action_menu') == FALSE && !empty($secondary_menu)): ?>
        <div id="secondary-menu-wrapper" class="section">
          <div id="secondary-navigation" class="container">
            <div class="secondary-nav-inner clearfix">
              <?php print render($page['secondary_menu']); ?>
            </div>
          </div>
        </div>
        <!-- /Secondary menu under main menu -->
      <?php endif; ?>
    </div>
    <!-- /NAVIGATION -->

    <!-- MOBILE NAVIGATION -->
    <div id="mobile-navigation-wrapper" class="section no-underline">
      <div id="mobile-navigation">
        <!-- Mobile search -->
        <div id="mobile-search">
          <?php
            if (!empty($search_mobile)) {
              // print render($search_mobile);
            }
          ?>
        </div>
        <!-- Mobile menu -->
        <nav id="mobile-menu" role="navigation">
        <?php
          // See if there is a custom mobile menu, otherwise, combine
          // Main, secondary, footer menus.
          if (isset($mobile_menu) && !empty($mobile_menu)):
        ?>
          <?php print theme('links', array('links' => $mobile_menu, 'attributes' => array('id' => 'main-menu-mobile', 'class' => array('links', 'clearfix')), 'heading' => array('text' => t('Mobile menu'),'level' => 'h2','class' => array('element-invisible')))); ?>
        <?php else: ?>
          <?php print theme('ucb_main_menu_links', array('links' => $main_menu, 'attributes' => array('id' => 'main-menu-mobile', 'class' => array('links', 'clearfix')), 'heading' => array('text' => t('Mobile menu'),'level' => 'h2','class' => array('element-invisible')))); ?>
          <?php print theme('links', array('links' => $secondary_menu, 'attributes' => array('id' => 'secondary-menu-mobile', 'class' => array('links', 'clearfix')), )); ?>
          <?php
            // Make sure footer menu is not a duplicate of the main menu.
            if (variable_get('menu_main_links_source', '') != variable_get('menu_footer_links_source', '')):
          ?>
            <?php print theme('links', array('links' => $footer_menu, 'attributes' => array('id' => 'footer-menu-mobile', 'class' => array('links', 'clearfix')), )); ?>
          <?php endif; ?>
        <?php endif; ?>
        </nav>
      </div>
    </div>
    <!-- MOBILE NAVIGATION -->


    <!-- MESSAGES/TABS/HELP/ACTION LINKS -->
    <div class="express-messages section">
      <div class="container">
        <?php if ($messages): ?>
          <div class="express-message">
            <div class="messages-inner">
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
    </div>
    <!-- /MESSAGES/TABS/HELP/ACTION LINKS -->

    <!-- PAGE CONTENT -->
    <div class="page-content">
      <!-- INTRO -->
      <?php if (!empty($page['intro'])): ?>
        <div id="intro-wide-wrapper" class="section intro-wide-wrapper">
          <?php print render($page['intro']); ?>
        </div>
      <?php endif; ?>
      <!-- //INTRO -->

      <!-- SLIDER -->
      <?php if (!empty($page['slider'])): ?>
        <div id="slider-wrapper" class="section slider-wrapper <?php print $section['slider']['class']; ?>">
          <div id="slider" class="clearfix container">
            <?php print render($page['slider']); ?>
          </div>
        </div>
      <?php endif; ?>
      <!-- //SLIDER -->

      <!-- PAGE TITLE IMAGE -->
      <?php if (isset($title_image) && !drupal_is_front_page()): ?>
        <?php
          $vars = array(
            'title_image_width' => $title_image_width,
            'title_image_wrapper_class' => $title_image_wrapper_class,
            'title_image' => $title_image,
          );
          print theme('page_title_image', $vars);
        ?>
      <?php else: ?>
        <div id="page-title-wrapper" class="page-title-wrapper section-wrapper <?php if (isset($title_hidden)) { print 'element-invisible'; } ?>">
          <a id="main-content"></a>
          <div class="page-title-inner container">
            <h1 id="page-title"><?php print drupal_get_title(); ?></h1>
            <?php print $breadcrumb; ?>
          </div>
        </div>
        <div class="clear"></div>
      <?php endif; ?>
      <!-- //PAGE TITLE IMAGE -->

      <!-- MAIN CONTENT -->
      <div id="main-content-wrapper" class="section main-content-wrapper">
        <div id="main" class="clearfix">



          <!-- POST TITLE WIDE -->
          <?php if (!empty($page['post_title_wide'])): ?>
            <div id="post-title-wide-wrapper" class="post-title-wide-wrapper section">
              <?php print render($page['post_title_wide']); ?>
            </div>
          <?php endif; ?>

          <!-- POST TITLE -->
          <?php if (!empty($page['post_title'])): ?>
            <div id="post-title-wrapper" class="post-title-wrapper section">
              <div class="container">
                <?php print render($page['post_title']); ?>
              </div>
            </div>
          <?php endif; ?>

          <!-- NODE CONTENT -->
          <div class="content-wrapper section">
            <div class="container">
              <div class="row">
                <div id="content" class="<?php print $main_content_classes; ?>" role="main">
                  <?php print render($page['content']); ?>
                </div>

                <?php
                  // Render the sidebars to see if there's anything in them.
                  $sidebar_first  = render($page['sidebar_first']);
                  $sidebar_second = render($page['sidebar_second']);
                ?>
                <!-- SIDEBARS -->
                <?php
                  // Order the sidebars depending on which is the primary sidebar
                  if ($sidebar_first || $sidebar_second):
                ?>
                    <?php if (theme_get_setting('primary_sidebar') == 'primary-sidebar-first'): ?>
                      <!-- SIDEBAR 1 -->
                      <div class="sidebar-first sidebar <?php print $sidebar_first_classes; ?>">
                        <?php print $sidebar_first; ?>
                      </div>
                      <!-- SIDEBAR 2 -->
                      <div class="sidebar-second sidebar <?php print $sidebar_second_classes; ?>">
                        <?php print $sidebar_second; ?>
                      </div>
                    <?php else: ?>
                      <!-- SIDEBAR 2 -->
                      <div class="sidebar-second sidebar <?php print $sidebar_second_classes; ?>">
                        <?php print $sidebar_second; ?>
                      </div>
                      <!-- SIDEBAR 1 -->
                      <div class="sidebar-first sidebar <?php print $sidebar_first_classes; ?>">
                        <?php print $sidebar_first; ?>
                      </div>
                    <?php endif; ?>
                <?php endif; ?>
                <!-- /SIDEBARS -->

              </div>
            </div>
          </div>

        </div>

      </div>
      <!-- /MAIN CONTENT -->

      <!-- FEATURE LAYOUT CONTENT -->
      <?php if (!empty($page['feature_layout'])): ?>
        <div id="feature-layout-wrapper" class="section-wrapper feature-layout-wrapper">
          <?php print render($page['feature_layout']); ?>
        </div>
      <?php endif; ?>
      <!-- /FEATURE LAYOUT CONTENT -->
    </div>
    <!-- /PAGE CONTENT -->

    <!-- POST WIDE -->
    <?php if (!empty($page['wide_2'])): ?>
      <div id="post-wide-wrapper" class="section-wrapper post-wide-wrapper">
        <?php print render($page['wide_2']); ?>
      </div>
    <?php endif; ?>
    <!-- /POST WIDE -->

    <!-- AFTER CONTENT -->
    <?php if (!empty($page['after_content'])): ?>
      <div id="after-content-wrapper" class="section after-content-wrapper <?php if (!empty($section['after-content'])) { print $section['after-content']['class']; } ?>">
        <div id="after-content" class="container">
          <?php print render($page['after_content']); ?>
        </div>
      </div>
    <?php endif; ?>
    <!-- /AFTER CONTENT -->

    <!-- AFTER CONTENT2 -->
    <?php if (!empty($page['lower'])): ?>
      <div id="after-content2-wrapper" class="section after-content2-wrapper <?php print $section['after-content2']['class']; ?>">
        <div id="after-content-2" class="container">
          <?php print render($page['lower']); ?>
        </div>
      </div>
    <?php endif; ?>
    <!-- /AFTER CONTENT2 -->

    <!-- FOOTER SECTION -->
    <div id="footer-section" class="footer-section <?php print $section['footer-section']['class']; ?>">
      <!-- FOOTER -->
      <?php if (!empty($page['footer'])): ?>
        <div id="footer-wrapper" class="section footer-wrapper <?php print $section['footer']['class']; ?>">
          <div id="footer" class="footer container">
            <?php print render($page['footer']); ?>
          </div>
        </div>
      <?php endif; ?>
      <!-- /FOOTER -->

      <!-- FOOTER MENU -->
      <?php if (isset($footer_menu) && !empty($footer_menu)): ?>
        <div id="footer-menu-wrapper" class="section footer-menu-wrapper <?php print $footer_menu_color; ?>">
          <div id="footer-navigation" class="container">
            <div class="clearfix">
              <nav id="footer-menu">
              <?php print theme('ucb_footer_menu_links', array('links' => $footer_menu, 'attributes' => array('id' => 'footer-menu-links', 'class' => array('links', 'inline-menu', 'clearfix')), 'heading' => array('text' => t('Footer menu'),'level' => 'h2','class' => array('element-invisible')))); ?>
              </nav>
            </div>
          </div>
        </div>
      <?php endif; ?>
      <!-- /FOOTER MENU -->

      <!-- SITE INFO -->
      <div id="site-info-wrapper" class="section site-info-wrapper <?php print $section['site-info']['class']; ?>">
        <div id="site-info" class="site-info">
          <div class="container">
            <?php print render($page['site_info']); ?>
          </div>
        </div>
      </div>
      <!-- /SITE INFO -->
    </div>

  </div>
</div>
