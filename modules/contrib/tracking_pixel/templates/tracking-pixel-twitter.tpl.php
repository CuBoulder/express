<!-- Twitter universal website tag code -->
<script>
  !function (e, n, u, a) {
    e.twq || (a = e.twq = function () {
      a.exe ? a.exe.apply(a, arguments) :
        a.queue.push(arguments);
    }, a.version = '1', a.queue = [], t = n.createElement(u),
      t.async = !0, t.src = '//static.ads-twitter.com/uwt.js', s = n.getElementsByTagName(u)[0],
      s.parentNode.insertBefore(t, s))
  }(window, document, 'script');
  // Insert Twitter Pixel ID and Standard Event data below
  twq('init',<?php print check_plain($variables['twitter_id']); ?>);
  twq('track', 'PageView');
  <?php if (isset($variables['twitter_action'])): ?>
  twq('track', "<?php print check_plain($variables['twitter_action']); ?>");
  <?php endif; ?>
</script>
<!-- End Twitter universal website tag code -->
