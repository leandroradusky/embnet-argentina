<?php
session_start();

include("funciones.php");

echo file_get_contents('header.php');

getAskForResults();

getAppsList(); 

echo file_get_contents('footer.php');
?>