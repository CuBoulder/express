<?php

$before = microtime(true);
//set this up so we chould use different sql for each table
$tables = array(1,2,3,4,5,6,7,8,9,10);

//  Resolve path back to the settings for this site from the location of the symlink in 
// /data/code/profiles/express/express-2.x.x to
// /data/web/express/[path] on old servers and 
// /data/atlas/code/profiles/express/express-2.9.2
// /data/web/htdocs/express/[path] on the new servers

if (isset($_SERVER['WWWNG_ENV'])) {
 echo 'old server locations</br>';
 $path_of_site = str_replace('/profiles/express/tests/infrastructure/2_truncate_testing_tables.php', '', $_SERVER['REQUEST_URI']);
 $path_to_settings = '/data/web/express' . $path_of_site . '/sites/default/settings.local_post.php';
}

if (isset($_ENV['OSR_ENV'])) {
  echo 'new server locations</br>';
  $path_of_site = str_replace('/profiles/express/tests/infrastructure/2_truncate_testing_tables.php', '', $_SERVER['REQUEST_URI']);
  $path_to_settings = '/data/web/htdocs/express' . $path_of_site . '/sites/default/settings.php';
  echo $path_to_settings;
}

// If it isn't the new or old servers, assume it's VALET do development purposes
if (!isset($path_to_settings)) { 
  echo 'local development locations</br>';
	$path_of_site = '/' . str_replace('.test', '', $_SERVER['HTTP_HOST']);
	// Because Valet is stored in the user's dir, we have to use relative paths
	$path_to_settings = '../../../../../../web' . $path_of_site . '/sites/default/settings.php';
}

if (file_exists($path_to_settings)) {
  echo 'settings.php found at ' . $path_to_settings . '</br>';
  require_once($path_to_settings);
}

// set array values from settings.php to variables that are easier to work with
$servername = $databases['default']['default']['host'] . ':' . $databases['default']['default']['port'];
$username = $databases['default']['default']['username'];
$password = $databases['default']['default']['password'];
$database = $databases['default']['default']['database'];

try {
  $conn = new PDO("mysql:host=$servername;dbname=$database", $username, $password);
  // set the PDO error mode to exception
  $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
  echo "Connected successfully <br />"; 
  
  foreach ($tables as $table) {
		// sql to truncate table
		$sql = "TRUNCATE test_table$table";
	
		 // use exec() because no results are returned
		$conn->exec($sql);
		echo "test_table$table truncated successfully <br />";
  }
  $after = microtime(true);
  echo "Time=" . round(($after-$before), 2) . " seconds";
  $conn->close();  
}

catch(PDOException $e) {
  echo "Connection failed: " . $e->getMessage() . " <br />";
}


?>