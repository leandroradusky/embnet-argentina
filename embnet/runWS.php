<?php
include("funciones.php");

set_time_limit(0);
if (isset($_POST['chains']))
{
	if (sizeof($_POST['chains']) > 0) 
		generateFileFromChains($_POST['chains'], $_POST['protein_file'].$_POST['protein_name']);
}
$xml = generateAppRun($_GET['app'], $_POST, $_FILES);

$file = fopen("Upload/xml", 'w');
fwrite($file,$xml);
fclose($file);

if (substr($xml,0,5) == "error")
{
	print("Error generating run.");
	print(substr($xml, 5));
} 
else
{
	//Si el trabajo ya existe lo traigo
	$resultado = jobExists($_GET['app'],$_POST['protein_name'],$_POST['chains']);
	
	if ($resultado == -1)
	{	
		ini_set("soap.wsdl_cache_enabled", "0");
		
		$client = new SoapClient("http://localhost/WSEMBNet/Server/scramble.wsdl");
		
		$resultado = $client->runApp($xml, $_POST['mail']);
			
		setRunMap($_GET['app'],$resultado,$_POST['protein_name'],$_POST['chains']);
	}
	header( 'Location: results.php?jid='.$resultado);
}
?>