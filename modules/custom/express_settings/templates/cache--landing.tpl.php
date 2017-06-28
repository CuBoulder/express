<p>To ensure that sites hosted on the Web Express platform load quickly, web pages, images, and files are cached or stored temporarily at a few different levels.</p>

<p>Our caches are designed to keep themselves current and expire without . Under normal conditions you won't
need to clear them, but occasionally there are problems that require clearing one or more cache. 
Each time a cache is cleared, it temporarily reduces the performance of the site for editors and visitors.</p>

<h2>Which Cache to Clear?</h2>

<div class="express-cards">
  <div class="express-card" data-width="one-third">
    <div class="content">
      <i class="fa fa-laptop" aria-hidden="true"></i> <i class="fa fa-arrow-right" aria-hidden="true"></i>
      <h3>Browser Cache</h3>
      <p>
      This is the layer of caching most users are familar with and must be cleared by each user on their computer, tablet or mobile device.       
      </p>
      <p>
      <b>When to clear:</b> You and your co-worker see different things when you view the same webpage on different computers when you are both logged in or both anonymous.
      </p>
      <p>
      <b>How to clear:</b> OIT maintains <a href="https://oit.colorado.edu/services/network-internet-services/ucb-wireless/tips-tricks/clear-browser-cache">step by step instructions for clearing browser caches for different browsers and operating systems</a>.
      </p>
    </div>
  </div>
  <div class="express-card" data-width="one-third">
    <div class="content">
      <i class="fa fa-arrow-left" aria-hidden="true"></i> <i class="fa fa-cloud" aria-hidden="true"></i> <i class="fa fa-arrow-right" aria-hidden="true"></i>
      <h3>Intermediate Cache</h3>
      <p>
      This caches content based on visitor requests between the browser and the web servers for up to 10 minutes.          
      </p>
      <p>
      <b>When to clear:</b> A page looks correct to you while logged in, but incorrect when you are not logged in on the same computer.
      </p>
      <p>
      <b>How to clear:</b> Site Owners and Content Editors can clear the cache of any path at any time by <a href="clear/varnish-path">entering the path</a> or using the link to Clear Intermediate Cache found next to Edit Layout on every page.  Site Owners can <a href="clear/varnish-full">clear the entire Intermediate Cache for the site</a> once an hour.
      </p>
    </div>
  </div>
  <div class="express-card"  data-width="one-third">
    <div class="content">
      <i class="fa fa-arrow-left" aria-hidden="true"></i> <i class="fa fa-server" aria-hidden="true"></i>
      <h3>Web Express Cache</h3>
      <p>
      This caches content of the site on servers hosting the Web Express sites.  Site Owners can clear the entire Web Express Cache for their site once an hour.
      </p>
      <p>
      <b>When to clear:</b> A page looks incorrect to you while logged in.
      </p>
      <p>
      <b>How to clear:</b> Site Owners can <a href="clear/drupal-full">clear the entire Web Express Cache for the site</a> once an hour.
      </p>
    </div>
  </div>

</div>
