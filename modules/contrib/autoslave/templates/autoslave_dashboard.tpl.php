<script src="//d3js.org/d3.v3.min.js"></script>
<h2>Database Infrastructure</h2>
<?php if (!empty($hashkey_link)) :?>
<div class="autoslave-hashkey-link alert alert-block alert-success messages status">
  <?php print $hashkey_link; ?>
</div>
<?php endif; ?>
<div class="db-charts">
  <div class="db-infrastructure">
    <div class="db-legend">
      Legend:<br><br>
      <div class="legend update">&nbsp;</div>Update<br>
      <span class="legend insert">&nbsp;</span>Insert<br>
      <span class="legend select">&nbsp;</span>Select<br>
    <?php if (!empty($hashkey_link)) :?>
      <span id="id-force-cron-span">&nbsp;
        <a id="force-cron-anchor" href="#">Dashboard cron</a>
      </span>
    <?php endif; ?>
    </div>
<?php for ($srvnum = 1; $srvnum <= $num_servers; $srvnum++) : ?>
    <div class="server-status server-<?php echo $srvnum; ?>">
      <div class="chart"></div>
      <div class="dbstatus"></div>
    </div>
<?php endfor; ?>
  </div>
</div>

<div class="db-selectmaster">
  <div class="db-choice">
<?php for ($mnum = 1; $mnum <= $num_masters; $mnum++) : ?>
    <div data-enable-ui="<?php print empty($hashkey_link);?>" class="master-status server-<?php echo $mnum; ?>">
      <div class="masterstatus"></div>
      <div class="masteraction">
        <div class="master-fail">Manually invalidate this server.</div><br>
      </div>
    </div>
<?php endfor; ?>
  </div>
</div>

<?php print $wait_div; ?>
<!--
The following example is based on https://bl.ocks.org/mbostock/1134768
A good simple program is here http://bl.ocks.org/anotherjavadude/2940908
-->

<style>
.axis text {
  font: 10px sans-serif;
}

.axis line,
.axis path {
  fill: none;
  stroke: #000;
  shape-rendering: crispEdges;
}

.axis--x path {
  display: none;
}
</style>

<script>
$ = jQuery;
var margin = {top: 20, right: 50, bottom: 30, left: 20},
    width = 400 - margin.left - margin.right,
    height = 286 - margin.top - margin.bottom;

var x = d3.scale.ordinal().rangeRoundBands([0, width]);
var y = d3.scale.linear().rangeRound([height, 0]);
var z = d3.scale.category10();

var xAxis = d3.svg.axis()
  .scale(x)
  .orient("bottom");

var yAxis = d3.svg.axis()
  .scale(y)
  .orient("right");

var server_status = [];
server_status = <?php echo $json_slave_status; ?>;
master_status = <?php echo $json_master_status; ?>;

var data = <?php echo $json_data;?>;

var servers = <?php echo $json_servers;?>;
for (srv in servers) {
  var srvnum = (+srv+1);
  var cls = '.server-status.server-' + srvnum + ' .chart';
  var svg = d3.select(cls)
    .append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
  if (typeof data == "object" && data != null) {
    if (typeof data[srvnum] == "object" && data[srvnum] != null) {
      drawThis(srvnum);
    }
  }

  var stats = $('.server-status.server-' + srvnum + ' .dbstatus');
  $(stats).empty().append(server_status[srvnum]);
}

var masters = <?php echo $json_masters;?>;

for (mas in masters) {
  var masnum = (+mas+1);
  var masterstatus = $('.master-status.server-' + masnum + ' .masterstatus');
  $(masterstatus).empty().append(master_status[masnum]);
}

function drawThis(srvnum) {
  var remapped = ['c1', 'c2', 'c3'].map(function(dat, i) {
    return data[srvnum].map(function(d, ii) {
      return {x: ii, y: d[i] };
    })
  });

  var layers = d3.layout.stack()(remapped);

  x.domain(layers[0].map(function(d) { return d.x; }));
  y.domain([0, d3.max(layers[layers.length - 1], function(d) { return d.y0 + d.y; })]).nice();

  var layer = svg.selectAll(".layer")
    .data(layers)
    .enter().append("g")
    .attr("class", "layer")
    .style("fill", function(d, i) { return z(i); });

  // Draw the data
  layer.selectAll("rect")
    .data(function(d) { return d; })
    .enter().append("rect")
    .attr("x", function(d) { return x(d.x); })
    .attr("y", function(d) { return y(d.y + d.y0); })
    .attr("height", function(d) { return y(d.y0) - y(d.y + d.y0); })
    .attr("width", x.rangeBand() - 1);

  // Draw the X axis
  svg.append("g")
    .attr("class", "axis axis--x")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis);

  // Draw the Y axis
  svg.append("g")
    .attr("class", "axis axis--y")
    .attr("transform", "translate(" + width + ",0)")
    .call(yAxis);
}
</script>
