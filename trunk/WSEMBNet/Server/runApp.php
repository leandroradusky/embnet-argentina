<?php

include("scriptsApps.php");

function runApp($xml_text, $_mail)
{
	
	$file = fopen("xml", 'w');
	fwrite($file,$xml_text);
	fclose($file);
		
	/*  PARSING DEL XML DE CORRIDA
	 */
	$xml = new DOMDocument();
	
	$xml = DOMDocument::loadXML($xml_text);
	
	$app = $xml -> getElementsByTagName("app") -> item(0) -> nodeValue;
	
	$jid = $xml -> getElementsByTagName("date") -> item(0) -> nodeValue;
	
	$mail = $xml -> getElementsByTagName("mail") -> item(0) -> nodeValue;

	$params = $xml -> getElementsByTagName("parameter");
	
	foreach ($params as $param)
	{
		$name= $param-> getElementsByTagName("name") -> item(0) -> nodeValue;
		$value= $param-> getElementsByTagName("value") -> item(0) -> nodeValue;
		
		$param_list[$name] = $value; 
	}

	/*  Llamada a cada método con los parámetros
	 */
	
	if ($app == "Frustratometer") $jid = runFrustratometer($jid, $param_list, $mail);

	/*  RETURN job id
	 */
	
	return $jid;
}

// turn off the wsdl cache
ini_set("soap.wsdl_cache_enabled", "0");

$server = new SoapServer("scramble.wsdl");

$server->addFunction("runApp");

$server->handle();

?>