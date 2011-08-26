<?php
if (!isset($_POST['jid'])) 
{
	if (!isset($_GET['jid']))
		$_POST['jid'] = 1;
	else
		$_POST['jid'] = $_GET['jid'];
}	
include("funciones.php");

echo file_get_contents('header.php');

echo getResultsForm($_POST['jid']);

echo file_get_contents('footer.php');

?>