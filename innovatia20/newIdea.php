<?php
require_once("./theme_skin/topTheme.php");
?>
<script type="text/javascript">
	function submitIdea() {
		$.post("innovatia_ajax.php", $("#newIdeaForm").serialize() );
	}
</script>
<form id="newIdeaForm">
	<h2>Submit New Idea</h2>
	<span>Title</span><input name="title" type="text"/><br/>
	<span>Description</span><input name="description" type="text"/><br/>
	<span>Licence</span><input name="licence" type="text"/><br/>
	<span>Visibility</span><input name="visibility" type="text"/><br/>
	<span>Username</span><input name="username" type="text"/><br/>
	<input name="action" type="hidden" value="saveOrUpdate"/>
	<a href="#" onclick="submitIdea()">Submit Idea</a>
</form>
<?php
require_once("./theme_skin/bottomTheme.php");
?>
			

