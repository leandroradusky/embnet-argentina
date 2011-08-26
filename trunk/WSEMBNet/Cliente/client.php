<form id="form1" name="form1" method="post" action="">
<table width="23%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td>a: </td>
<td><input name="a" type="text" id="a" size="5" /></td>
</tr>

<tr>
<td>&nbsp;</td>
<td><input type="submit" name="button" id="button" value="Submit" /></td>
</tr>
</table>
</form>
<?php
if(isset($_POST['a']))
{
// turn off the WSDL cache
ini_set("soap.wsdl_cache_enabled", "0");

$client = new SoapClient("http://localhost/WSEMBNet/Server/scramble.wsdl");

$a = $_POST['a'];

$resultado = $client->runApp($a);
print("$resultado");

}
?>