<?php
require_once("./theme_skin/topTheme.php");
?>

<h2>Ideas</h2>
<?php
require_once("./connector.php");

/**
 * This page is displays ideas from DB
 */ 
 
 db_connect();

	$rs = mysql_query("SELECT * FROM userIdeas");
	
	while ($row = mysql_fetch_object($rs)) {
		?><a href="#" onclick="window.open('oneIdea.php?title=<?= $row->title ?>');"> <?= $row->title ?> </a> <?
	}
	
db_close();

?>
<?php
require_once("./theme_skin/bottomTheme.php");
?>
