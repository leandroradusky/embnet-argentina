<?php
/* Ask results with jobid form
 */
function getAskForResults() {
	echo "<form method='post' action='results.php'>\n";
	echo "<span class='title'>Results</span><br />\n";
	echo "Ask results with your JobID: \n";
	echo "<input type='text' name='jid' id='jid' />\n";
	echo "<input id='buttom2' type='submit' value='Get Results!' />\n";
	echo "</form>\n";
	echo "<br />\n";
	echo "<br />\n";
}

/* Links to all visible applications
 */
function getAppsList() {
	$doc = new DOMDocument();
	$doc -> load("apps.xml");
	$apps = $doc -> getElementsByTagName("app");

	echo "<span class='title'>Application List</span> <br /><br />\n";
	echo "<div id='links' align='left'>\n";
	foreach($apps as $app) {
		$name = $app -> getElementsByTagName("name") -> item(0) -> nodeValue;
		$visible = $app -> getElementsByTagName("visible") -> item(0) -> nodeValue;

		if ($visible == "Yes") echo "<a href='charge.php?app=$name&chains=NO'> $name </a><br />\n";
	}
	echo "</div>\n<br />";
}

/* Returns the required attribute from specified app
 */
function getAppAttribute($appName, $attr) {
	$doc = new DOMDocument();
	$doc -> load("apps.xml");
	$apps = $doc -> getElementsByTagName("app");
	foreach($apps as $app) {
		$name = $app -> getElementsByTagName("name") -> item(0) -> nodeValue;

		if($name == $appName) {
			$attribute = $app -> getElementsByTagName($attr) -> item(0) -> nodeValue;
			return $attribute;
		}
	}
}

/* App's links
 */
function getAppLinks($appName) {
	$doc = new DOMDocument();
	$doc -> load("apps.xml");
	$apps = $doc -> getElementsByTagName("app");

	echo "<div id='links' align='left'><center>\n";
	foreach($apps as $app) {
		$name = $app -> getElementsByTagName("name") -> item(0) -> nodeValue;

		if($name == $appName) {
			$l = "";
			$links = $app -> getElementsByTagName("link");
			foreach($links as $link) {
				$text = $link -> getElementsByTagName("text") -> item(0) -> nodeValue;
				$desc = $link -> getElementsByTagName("desc") -> item(0) -> nodeValue;
				$url = $link -> getElementsByTagName("url") -> item(0) -> nodeValue;

				$l .= "<a href='$url' title='$desc'>$text</a> | ";
			}
			echo substr($l, 0, -2);
		}
	}
	echo "</center></div>\n";
}

/* Get all chains from a given pdb
 */
function getPDBChains($target_path) {
	$target_path = "Upload/" . $target_path;
	$command = "grep '^ATOM' " . $target_path . " |  sed 's/\(^ATOM\)\(.\{17\}\)\(.\{1\}\)\(.*\)/\\3/g' | sort -u | uniq ";
	//echo "<br />".$command."<br />";
	$chains = shell_exec($command);
	$command = "echo  \"\\n\" >> " . $target_path . ";awk '{if(NR == '\$((`grep -n 'ATOM.\{17\}\ ' " . $target_path . "  | tail -n 1 | grep -o '^[0-9]*'` ))' ) {print \"TER\" }}1' " . $target_path . "> " . $target_path . "_tmp;mv " . $target_path . "_tmp " . $target_path;
	//echo $command."<br />";
	shell_exec($command);
	$command = "seq `grep -n -B 1 '^TER' " . $target_path . " | grep '^ATOM.\{17\}\ ' | grep  -o '^\w*' | wc -l ` ";
	//echo $command."<br />";
	$nnchains = shell_exec($command);
	echo "<br>Please, select a chain to process...<br>";
	$eachchain = explode("\n", trim($chains));
	$res = 0;
	for($i = 0, $size = sizeof($eachchain); $i < $size; ++$i) {
		if($eachchain[$i] != "") {
			echo "<input type='checkbox' name='chains[]' value='" . $eachchain[$i] . "'>" . $eachchain[$i] . "</input><br>";
			$res++;
		}
	}
	if(trim($nnchains) != "") {
		$eachchain = explode("\n", trim($nnchains));
		for($i = 0, $size = sizeof($eachchain); $i < $size; ++$i) {
			if($eachchain[$i] != "") {
				echo "<input type='checkbox' name='chains[]' value='nn" . $eachchain[$i] . "'>" . $eachchain[$i] . " unnamed chain</input><br>";
				$res++;
			}
		}
	}
	return $res;
}

/* After select chains re-write the pdb file
 */
function generateFileFromChains($chains, $target_path) {
	if(sizeof($chains) == 0)
		return 0;

	$target_path = "Upload/" . $target_path;
	//here I filter the choosed chain
	foreach($chains as $chain) {
		if(strlen($chain) > 1) {
			//we have a nn
			//lets get the nn order
			$chain = escapeshellcmd($chain);
			$nnchain = substr($chain, 2);
			$command = "/var/www/WSEMBNet/Server/frust_code2/nnchain " . $target_path . " " . $nnchain . " >> " . $target_path . "_filt";
			shell_exec($command);
		} else {
			$command = "/var/www/WSEMBNet/Server/frust_code2/chain " . $target_path . " " . $chain . " >> " . $target_path . "_filt";
			shell_exec($command);
		}
	}
	shell_exec("mv " . $target_path . "_filt " . $target_path . "");

	return 1;
}

/* shows the charge form re-formatted to select protein chains
 */
function getFilterChainsForm($appName, $post, $files) {
	// Subo los archivos a la carpeta upload
	if($files['protein_file']['name'] != "") {
		$error = saveAllUploadedFiles($files);
		if(substr($error, 0, 5) == "error")
			return "error The file was not uploaded." . "<br>" . substr($error, 5);
	} else if($post['protein_name'] != "") {
		exec("echo " . $post['protein_name'] . "> Upload/name");
		exec("http_proxy=proxy.uba.ar:8080 wget -O - http://www.rcsb.org/pdb/files/" . $post['protein_name'] . ".pdb.gz | gunzip - > Upload/" . $post['protein_name'] . ".pdb");
	} else {
		echo "Protein file not specified!";
		echo "<div id='buttom' align='right'>\n";
		echo "<input type='button' value = 'Go back!' onclick='history.back()' />\n";
		echo "</div>";

		return ;
	}
	$chain = 0;
	$icon = "<img src='imagenes/iconList.gif' width='10' height='10'>&nbsp;&nbsp;\n";
	echo "<form name='myForm' method='POST' action='runWS.php?app=$appName' enctype='multipart/form-data'>\n";

	$doc = new DOMDocument();
	$doc -> load("apps.xml");
	$apps = $doc -> getElementsByTagName("app");

	foreach($apps as $app) {
		$name = $app -> getElementsByTagName("name") -> item(0) -> nodeValue;

		if($name == $appName) {
			echo "<input type='hidden' name='MAX_FILE_SIZE' value='99999999' />";

			$fields = $app -> getElementsByTagName("field");
			foreach($fields as $field) {
				$name = $field -> getElementsByTagName("name") -> item(0) -> nodeValue;
				$type = $field -> getElementsByTagName("type") -> item(0) -> nodeValue;
				$text = $field -> getElementsByTagName("text") -> item(0) -> nodeValue;

				echo "<br />\n";
				echo $icon;
				echo "$text";
				if($type == "ftp_pdb") 
				{
					if($post[$name] != "") 
					{
						echo "<input type='hidden' name='$name' value='" . $post[$name] . ".pdb' />";
						echo "File uploaded ok, select chain:";
						$chain = getPDBChains($post[$name] . ".pdb");

						echo "<script src='jmol/Jmol.js'></script>\n";
						echo " <script> jmolInitialize('jmol'); jmolCheckBrowser('popup', '../../browsercheck', 'onClick');";
						echo "jmolApplet(400,'load Upload/" . $post[$name] . ".pdb; color background white; wireframe off; cartoon on; color cartoon chain; cpk off; ');</script>";
					}
				} 
				else if($type == "prot_file") 
				{
					if($files[$name]['name'] != "") 
					{
						echo "<input type='hidden' name='$name' value='" . $files[$name]['name'] . "' />";
						echo "File uploaded ok, select chain:";
						$chain = getPDBChains($files[$name]['name']);

						echo "<script src='jmol/Jmol.js'></script>\n";
						echo " <script> jmolInitialize('jmol'); jmolCheckBrowser('popup', '../../browsercheck', 'onClick');";
						echo "jmolApplet(400,'load Upload/" . $files[$name]['name'] . "; color background white; wireframe off; cartoon on; color cartoon chain; cpk off; ');</script>";
					}
				}
				else if($type == "file") 
				{
					if($files[$name]['name'] != "") 
					{
						echo "<input type='hidden' name='$name' value='" . $files[$name]['name'] . "' />";
						echo "File ".$files[$name]['name']." uploaded ok";
					}
				} 
				else 
				{
					echo "<input name='$name' type='$type' value='";
					echo $post[$name];
					echo "'/>\n";
				}
				echo "<br />\n";

			}
		}
	}

	echo "<br />\n";
	echo $icon;
	echo "Insert your mail (optional): \n";
	echo "<input name='mail' type='text' value='";
	echo $post['mail'];
	echo "'/>\n";
	echo "<br />\n";
	echo "<div id='buttom' align='right'>\n";
	echo "<input type='submit' value = 'Execute' />\n";
	echo "</div>";
	echo "<br />\n";
	echo "</form>\n";

	if($chain == 1)
		echo "<script language='JavaScript'>document.myForm.submit();</script>";
}

/* Load data form
 */
function getAppForm($appName) {
	$icon = "<img src='imagenes/iconList.gif' width='10' height='10'>&nbsp;&nbsp;\n";
	echo "<form method='POST' action='charge.php?app=$appName&chains=YES' enctype='multipart/form-data'>\n";
	echo "<input type='hidden' name='MAX_FILE_SIZE' value='100000'> \n";

	$doc = new DOMDocument();
	$doc -> load("apps.xml");
	$apps = $doc -> getElementsByTagName("app");
	foreach($apps as $app) {
		$name = $app -> getElementsByTagName("name") -> item(0) -> nodeValue;

		if($name == $appName) {
			echo "<input type='hidden' name='MAX_FILE_SIZE' value='99999999' />";

			$fields = $app -> getElementsByTagName("field");
			foreach($fields as $field) {
				$name = $field -> getElementsByTagName("name") -> item(0) -> nodeValue;
				$type = $field -> getElementsByTagName("type") -> item(0) -> nodeValue;
				$text = $field -> getElementsByTagName("text") -> item(0) -> nodeValue;

				if ($type == "prot_file") $type = "file";
				
				if($type == "ftp_pdb")
					$type = "text";
				echo "<br />\n";
				echo $icon;
				echo "$text";
				echo "<input name='$name' type='$type' />\n";
				echo "<br />\n";

			}
		}
	}

	echo "<br />\n";
	echo $icon;
	echo "Insert your mail (optional): \n";
	echo "<input name='mail' type='text' />\n";
	echo "<br />\n";
	echo "<div id='buttom' align='right'>\n";
	echo "<input type='submit' value = 'Execute' />\n";
	echo "</div>";
	echo "<br />\n";
	echo "</form>\n";
}

/* Returns file text content
 */
function getFileContent($path) {
	if($path != "Upload/") {
		$gestor = fopen($path, "r");
		$contenido = fread($gestor, filesize($path));
		fclose($gestor);
		return $contenido;
	} else
		return "";
}

/* Move to upload folder all uploaded files
 */
function saveAllUploadedFiles($files) {
	set_time_limit(0);
	foreach($files as $file) {
		if(!move_uploaded_file($file['tmp_name'], "Upload/" . $file['name']))
			return "error" . $file['tmp_name'] . $file['name'] . $file['error'];
	}
	return "";
}

/* Generate run scripts to call webservice
 */
function generateAppRun($appName, $post, $files) {
	$xml = "<run>\n";
	$xml .= "<app>$appName</app>\n";
	$xml .= "<date>" . date("Ymd") . time() . "</date>\n";
	$xml .= "<mail>" . $post['mail'] . "</mail>\n";
	$xml .= "<parameters>\n";

	$doc = new DOMDocument();
	$doc -> load("apps.xml");
	$apps = $doc -> getElementsByTagName("app");
	foreach($apps as $app) {
		$name = $app -> getElementsByTagName("name") -> item(0) -> nodeValue;

		if($name == $appName) {
			$fields = $app -> getElementsByTagName("field");
			foreach($fields as $field) {
				$name = $field -> getElementsByTagName("name") -> item(0) -> nodeValue;
				$type = $field -> getElementsByTagName("type") -> item(0) -> nodeValue;

				$xml .= "<parameter>\n";
				$xml .= "<name>$name</name>\n";
				$xml .= "<value>\n";
				if($type == "text")
					$xml .= $post[$name];
				if($type == "file" || $type == "prot_file") {
					if(isset($post[$name]) && $post[$name] != "") {
						$xml .= $post[$name];
					}
				}
				if($type == "ftp_pdb") {
					if(isset($post[$name]) && $post[$name] != "") {
						$xml .= $post[$name];
					}
				}
				$xml .= "</value>\n";
				$xml .= "</parameter>\n";

			}
		}
	}
	$xml .= "</parameters>\n";
	$xml .= "</run>";

	return $xml;
}

/* shows jobid's results form
 */
function getResultsForm($jid) {
	$icon = "<img src='imagenes/iconList.gif' width='10' height='10'>&nbsp;&nbsp;\n";
	$res = "<span class='title'> Results </span>\n";
	$res .= "<br />\n";
	$res .= "<br />\n";
	$res .= "<img src='imagenes/iconList.gif' width='10' height='10'>&nbsp;&nbsp\n";
	$res .= "<b> JobID:</b> $jid <br />\n";
	$res .= "<br />\n";

	$doc = new DOMDocument();
	if(!file_exists("Results/" . $jid . "/results.xml"))
		return $res . "Calculating<br />There are no results for this JobID yet. <br /><br /><div id='buttom' align='right'><input type='button' class onclick='window.location.reload( true );' value='Refresh' /></div>";
	$doc -> load("Results/" . $jid . "/results.xml");
	$results = $doc -> getElementsByTagName("result");
	foreach($results as $result) {
		$jid_actual = $result -> getElementsByTagName("jid") -> item(0) -> nodeValue;
		if($jid == $jid_actual) {
			$app = $result -> getElementsByTagName("app") -> item(0) -> nodeValue;
			$res .= $icon;
			$res .= "<b> Application:</b> " . $app . "\n";
			$res .= "<br /><br />\n";
			$fields = $result -> getElementsByTagName("field");
			foreach($fields as $field) {
				$name = $field -> getElementsByTagName("name") -> item(0) -> nodeValue;
				$type = $field -> getElementsByTagName("type") -> item(0) -> nodeValue;
				$value = $field -> getElementsByTagName("value") -> item(0) -> nodeValue;
				$onclick = $field -> getElementsByTagName("onclick") -> item(0) -> nodeValue;

				if($type == "text" || $type == "ftp_pdb") {
					$res .= $icon;
					$res .= "<b> $name:</b> $value\n";
					$res .= "<br />\n";
				} else if($type == "desc") {
					$res .= $icon;
					$res .= "<b> $name:</b><br /><br />$value\n";
					$res .= "<br />\n";
				} else if($type == "download") {
					$res .= $icon;
					$res .= "<a href='$value'><b>$name</b></a>\n";
					$res .= "<br />\n";
				} else if($type == "img") {
					$res .= $icon;
					$res .= "<b> $name:</b> <br /> <br />";
					if($onclick != "")
						$res .= "<a target='_blank' href='$onclick'> ";
					$res .= "<img src='$value' width='300px' height='300px' />\n";
					if($onclick != "")
						$res .= "</a> ";
					$res .= "<br />\n";
				} else if($type == "title") {
					$res .= " <br /><label class='title2'> $value</label> <br />\n";
				} else if($type == "jmol") {
					$res .= $icon;
					$res .= "<b> $name:</b> <br />";
					$res .= "<script type='text/javascript'>function $name(){";
					$res .= "$value";
					$res .= "}
					function popInJmol(id,scr)
					{
						// jmolInitialize('./jmol/')
						jmolSetDocument(false)
						document.getElementById(\"Jmol\"+id).innerHTML = jmolApplet(300,scr,id)
					}
					</script>";
					$res .= "<div id=\"Jmol" . $name . "\">";
					$res .= "<a id='" . $name . "Snap' href='javascript:void(" . $name . "())' >";
					$res .= "<img src='Results/" . $jid . "/" . $jid . ".pdb.done/" . $name. ".png' width='300px' height='300px' />";
					$res .= "<br/>click to Jmol 3D structure</a></div>  ";
				} else if($type == "begintable") {
					$res .= "<table><tr>";
				} else if($type == "endtable") {
					$res .= "</tr></table>";
				} else if($type == "begintd") {
					$res .= "<td>";
				} else if($type == "endtd") {
					$res .= "</td>";
				}

				$res .= "<br />\n";
			}
		}
	}
	return $res;
}

/* Save results to resultmap
 */
function setRunMap($appName, $jobid, $protein, $chains) {
	if($protein != "") {
		$xml = getFileContent("resultmap.xml");
		$xml = substr($xml, 0, -5);
		$xml .= "<result>\n";
		$xml .= "<app>" . $appName . "</app>\n";
		$xml .= "<jobid>" . $jobid . "</jobid>\n";
		$xml .= "<pdb>\n";
		$xml .= "<id>" . $protein . "</id>\n";
		foreach($chains as $chain) {
			$xml .= "<chain>" . $chain . "</chain>\n";
		}
		$xml .= "</pdb>\n";
		$xml .= "</result>\n";
		$xml .= "</r>\n";
		$file = fopen("resultmap.xml", "w");
		fwrite($file, $xml);
		fclose($file);
	}
}

/* Looks the job in resultmap
 */
function jobExists($appName, $protein, $chains) {
	$doc = new DOMDocument();
	$doc -> load("resultmap.xml");
	$results = $doc -> getElementsByTagName("result");
	foreach($results as $result) {
		$app = $result -> getElementsByTagName("app") -> item(0) -> nodeValue;
		$jid = $result -> getElementsByTagName("jobid") -> item(0) -> nodeValue;
		$id = $result -> getElementsByTagName("id") -> item(0) -> nodeValue;
		$pdb = $result -> getElementsByTagName("pdb");
		$cs = $result -> getElementsByTagName("chain");

		if($app == $appName && $id == $protein) {
			$es = true;
			if(count($chains) != count($cs))
				return -1;
			for($i = 0; $i < max(count($chains), count($cs)); $i++) {
				if(!(trim($chains[$i]) . '' == trim($cs -> item($i) -> nodeValue) . ''))
					$es = false;
			}
			if($es == true)
				return $jid;
		}
	}
	return -1;

}

/* make a sample-output form for the application from the result map
 */
function getExploreResultsForm($appName) {
	$icon = "<img src='imagenes/iconList.gif' width='10' height='10'>&nbsp;&nbsp;\n";

	echo "<span class='title'> Sample Output </span><br /><br /><br />";
	$doc = new DOMDocument();
	$doc -> load("resultmap.xml");
	$results = $doc -> getElementsByTagName("result");
	foreach($results as $result) {
		$app = $result -> getElementsByTagName("app") -> item(0) -> nodeValue;
		if($app == $appName) {
			echo $icon;
			$jid = $result -> getElementsByTagName("jobid") -> item(0) -> nodeValue;
			echo "<a href='results.php?jid=$jid'> ";
			$id = $result -> getElementsByTagName("id") -> item(0) -> nodeValue;
			echo "File: " . $id;
			$cs = $result -> getElementsByTagName("chain");
			if(count($cs) > 0) {
				echo " Chain(s): ";
				foreach($cs as $chain) {
					echo $chain -> textContent;
					echo " ";
				}
			}
			echo "</a><br /><br />\n";

		}
	}
}
?>