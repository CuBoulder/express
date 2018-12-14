<?php

/**
 * @file
 * Template for desktop search block.
 */

global $base_path;
$active = TRUE;
$options = $block->options;
$configs = $block->configs;
$active_option = key($options);
$active_configs = $configs[$active_option];
?>
  <div class="cu-search-box cu-search-box-small animated" role="search">
    <h2><?php print t('Search'); ?></h2>
    <form class="cu-search-form" action="<?php print $active_configs['action']; ?>" method="get">
      <div class="search-form-wrapper">
        <div class="search-fields">
          <div class="cu-search">
            <div class="form-item form-type-textfield form-item-search-keys">
              <label class="element-invisible" for="edit-search-keys">Enter the terms you wish to search for. </label>
              <input placeholder="<?php print $active_configs['placeholder']; ?>" type="search" id="edit-search-keys" name="cse" value="" size="15" maxlength="128" class="form-text">
            </div>
            <div class="form-actions form-wrapper" id="edit-actions"><input type="submit" id="edit-submit" name="op" value="Search" class="form-submit"></div>
          </div>
        </div>

        <?php if (count($options) > 1): ?>
          <div class="search-options">
            <?php foreach ($options as $option): ?>
              <?php if ($option): ?>
                <?php
                  $checked = $active ? 'checked="checked"' : '';
                  $value = isset($configs[$option]['value']) ? $configs[$option]['value'] : $configs[$option]['label'];
                ?>
                <div class="search-option">
                  <input type="radio" name="search-option" <?php print $checked; ?> value="<?php print $value; ?>" data-placeholder="<?php print $configs[$option]['placeholder']; ?>" data-action="<?php print $configs[$option]['action']; ?>" id="search-<?php print $option; ?>"/> <label for="search-<?php print $option; ?>"><?php print $configs[$option]['label']; ?></label>
                </div>
                <?php
                  $active = FALSE;
                ?>
              <?php endif; ?>
            <?php endforeach; ?>
          </div>
        <?php endif; ?>
        <?php if (!empty($block->options['all'])): ?>
        <div class="campus-links">
          <h3 class="display-inline">Other ways to search: </h3>
          <ul class="inline inline-menu">
            <li><a href="https://calendar.colorado.edu">Events Calendar</a></li>
            <li><a href="https://www.colorado.edu/map">Campus Map</a></li>
          </ul>

        </div>
      <?php endif; ?>
      </div>
    </form>
  </div>
