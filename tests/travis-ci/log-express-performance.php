<?php
#!/usr/bin/env drush

$results = db_query('SELECT * FROM {performance_detail} p')->fetchAll();

$average_results['memory'] = number_format(db_query('SELECT AVG(bytes) AS mem FROM {performance_detail} p')->fetchField() / 1000000, 2, '.', '');
$average_results['load'] = number_format(db_query('SELECT AVG(ms) AS lt FROM {performance_detail} p')->fetchField() / 1000, 2, '.', '');
$average_results['query_count'] = number_format(db_query('SELECT AVG(query_count) AS qc FROM {performance_detail} p')->fetchField(), 2, '.', '');
$average_results['query_time'] = number_format(db_query('SELECT AVG(query_timer) AS qt FROM {performance_detail} p')->fetchField(), 2, '.', '');

$output = array();
foreach ($results as $result) {
// Stash content for each path
  $output[$result->path]['path'] = $result->path;
  $output[$result->path]['memory'][] = $result->bytes;
  $output[$result->path]['load'][] = $result->ms;
  $output[$result->path]['query_count'][] = $result->query_count;
  $output[$result->path]['query_timer'][] = $result->query_timer;
}

usort($output, function ($a, $b) {
  return count($a['memory']) < count($b['memory']);
});


print_r('Average Memory Consumption: ' . $average_results['memory'] . "MB\n");
print_r('Average Load Time: ' . $average_results['load'] . " Seconds\n");
print_r('Average Query Count: ' . $average_results['query_count'] . "\n");
print_r('Average Query Time: ' . $average_results['query_time'] . " Seconds\n");
print_r("\n");

// Build output to screen. Only top 10.
$i = 0;
foreach ($output as $key => $path) {
  if ($i >= 15) {
    return;
  }
  $count = count($path['memory']);
  $memory_sum = array_sum($path['memory']);
  $load_sum = array_sum($path['load']);
  $query_count_sum = array_sum($path['query_count']);
  $query_time_sum = array_sum($path['query_timer']);


  $memory_average = number_format(($memory_sum / $count / 1000000), 2, '.', '');
  $load_average = number_format(($load_sum / $count / 1000), 2, '.', '');
  $query_count_average = number_format(($query_count_sum / $count), 2, '.', '');
  $query_time_average = number_format(($query_time_sum / $count), 2, '.', '');
  print_r('Path: ' . $path['path'] . "\n");
  print_r('Accessed: ' . $count . "\n");
  print_r('Memory Consumption: ' . $memory_average . "MB\n");
  print_r('Load Time: ' . $load_average . " Seconds\n");
  print_r('Query Count: ' . $query_count_average . "\n");
  print_r('Query Time: ' . $query_time_average . " Milliseconds\n");
  print_r("\n");
  $i++;
}
