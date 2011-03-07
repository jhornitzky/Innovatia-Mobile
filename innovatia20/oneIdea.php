<?

include_once("connector.php");
		
		db_connect();
		
		$ideaName = $_GET['title'];
		
		$rs = mysql_query("SELECT * FROM userIdeas WHERE title='$ideaName'");
	
		while ($row = mysql_fetch_object($rs)) {
		?><h2><?= $row->title ?> </h2>
		<p><?= $row->description ?> </p>
		<p><?= $row->visibility ?></p>
		 <?
		}
		db_close();
?>
