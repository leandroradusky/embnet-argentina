<?php
session_start();
include("funciones.php");
$_SERVER['app'] = $_GET['app'];
$_SESSION['app'] = $_GET['app'];

echo file_get_contents('header.php');

getAskForResults();
?>

<span class="title"><?php echo getAppAttribute($_GET["app"], "name"); ?> </span>
<br />

<!-- Muestro la descripción de la aplicación cargada -->
<br />
<?php echo getAppAttribute($_GET["app"], "desc"); ?>
<br />

<!-- Muestro la lista de links de interés -->
<br />
<?php echo getAppLinks($_GET["app"]); ?>		
<br />

<div id="charge">
	<!-- Armo el formulario para la carga de datos -->
	<br />
	<?php
	if ($_GET["chains"] == "YES")
	 echo getFilterChainsForm($_GET["app"], $_POST, $_FILES);
	else
	 echo getAppForm($_GET["app"]); ?>		
	<br />
</div>

<?php
echo file_get_contents('footer.php');
?>