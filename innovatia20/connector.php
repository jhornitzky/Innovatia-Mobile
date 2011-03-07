<?
	include_once("config.php"); 
	
	$link = null;
	$dbopen = null;
	
	function db_connect() {
		// connect mysql
		$link = mysql_connect('localhost', 'root', 'return') or die("Failure connecting");
		// if not connected
		if(!is_resource($link)){return false;}
		// select database
		$dbopen = mysql_select_db('innovatia', $link);
		// if failed
		if(!$dbopen){return false;}
	}
		
	function db_close(){
		mysql_close();
		unset($sql,$rs,$link);
	}
	
	function db_connect_i() {
	}
?>
