<?php
require_once("./connector.php");



/**
 * This page is RESTful webservices only over HTTP.
 */ 

//print "Hitting AJAX";
 db_connect();
 //CHECK LOGIN FIRST
 $userName = $_POST['username']; 
 $password = $_POST['password']; 
 
 //Check for nulls and empty strings
 /*
 if ($userName == null || $password == null || $userName == "" || $password == "") {
	 print "Authentication Required";
 }
 */
/*
 $db_connection = new mysqli("localhost", "root", "return", "innovatia");
 $statement = $db_connection->prepare("SELECT * FROM users WHERE name = ? AND password = ?");
 $statement->bind_param('ss',$userName, $password);
 $rs = $statement->execute(); 
 * */
 
 if ($rs != null) {
 }
 db_close();
 
 db_connect();
	$action = $_POST['action'];
	if ($action == "saveOrUpdate") {
		$title =$_POST['title'];

		$rs = mysql_query("SELECT * FROM userIdeas WHERE username='$userName' AND title='$title'");
		
		if(mysql_num_rows($rs) > 0) {
			$db_connection = new mysqli("localhost", "root", "return", "innovatia");
			$statement = $db_connection->prepare("UPDATE userIdeas SET description=?, 
				licence=?, visibility=?, clientid=? WHERE title=? AND username=?");
 			$statement->bind_param('ssssss', $_POST['description'], $_POST['licence'], 
				$_POST['visibility'], $_POST['clientid'],$_POST['title'], $_POST['username']);
			$rs = $statement->execute();
			echo "Successful update!!!";
		} else {
			$db_connection = new mysqli("localhost", "root", "return", "innovatia");
			$statement = $db_connection->prepare("INSERT INTO userIdeas (title, description, 
				licence, visibility, username, clientid) VALUES (?, ? , ? , ? , ?, ?) ");
 			$statement->bind_param('ssssss',$_POST['title'], $_POST['description'], $_POST['licence'], 
				$_POST['visibility'], $_POST['username'], $_POST['clientid']);
			$rs = $statement->execute();
			echo "Successful insert!!!";
		}
	} else if ($action == "delete") {
		$title =$_POST['title'];
		mysql_query("DELETE FROM userIdeas WHERE username='$userName' AND title='$title'");
	} else if ($action == "getSyncData") {
		$rs = mysql_query("SELECT * FROM userIdeas WHERE username='$userName'");
		echo "<ideas> <lastsync>0000-00-00 00:00:00</lastsync>"; //FIXME search DB for that UID which has the latest sync date for that client
		while ($row = mysql_fetch_object($rs)) {
			echo "<idea>";
			echo "<title>".$row->title."</title>";
			echo "<desc>".$row->description."</desc>";
			echo "<lastupdated>".$row->lastupdated."</lastupdated>";
			echo "</idea>";
		}
  		echo "</ideas>"; 
	}
db_close();

?>
