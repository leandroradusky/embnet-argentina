<?php

function runFrustratometer($jid, $params, $mail)
{	
	$jobpath = "Results/".$jid."/";
	mkdir($jobpath);
	chdir($jobpath);
	
	$jobtarget = $jid.".pdb"; //trim($params['name']);   
   
    if (trim($params['protein_file']) != "") 
    	exec ("cp /var/www/embnet/Upload/".str_replace("\n", "",$params['protein_file'])." ".$jobtarget);
    if (trim($params['protein_name']) != "") 
    	exec ("cp /var/www/embnet/Upload/".str_replace("\n", "",$params['protein_name'])." ".$jobtarget);
		
	$pythonexec="C:\\Python26\\python.exe db_scripts\\addjob.py ";
	// $pythonexec = "python db_scripts/addjob.py ";
	
	$exec = "'".$pythonexec.$jid." \"ssh root@localhost \\\"cd /var/www/WSEMBNet/Server/Results/$jid;/var/www/WSEMBNet/Server/frust_code2/doitbaby.sh ".$jobtarget." ".$jid."\\\"\"'";
	
	system($exec);
		
	$file = fopen("run.php", 'w');
	fwrite($file,"<?php exec(".$exec."); ?>");
	fclose($file);
	exec("/usr/bin/php run.php > /dev/null &");
	return $jid;
	
}

?>