<?php
session_start();

include ("funciones.php");

echo file_get_contents('header.php');
?>

<span class='title'> Sample Output </span>
<br /><br />
<a target='blank' href='imagenes/frustra_example.png'>
<img src='imagenes/frustra_example.png' width='250' height='500'>
</a>
<br /><br />
<?php 
getExploreResultsForm($_SESSION['app']); 

echo file_get_contents('footer.php');
?>
