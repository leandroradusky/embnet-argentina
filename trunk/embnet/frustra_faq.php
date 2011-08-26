<?php
echo file_get_contents('header.php');
?>
 
<ul> 
	<li> 
	<b> 
	What are those lines joining the Calphas over my structure?
	</b><br><br> 
	 
	They are a cartoon of the interactions between pairs of aminoacids:
	'<font color="green">minimally frustrated</font>' interactions are favorable for folding the
	provided sequence in the provided structure.
	<font color="red">Highly frustrated</font> interactions are in conflict with folding the
	provided sequence and structure. They reflect that other evolutionary
	pressures (besides folding) might be at play selecting them. They are
	usually found enriched in proteins functional sites (visit our
	<a href="frustra_study_cases.php">study cases page</a>).
	<br><br><br></li> 
	<li> 
	<b> 
	What are those graphs below the structure?
	</b><br><br> 
	 
	The first one is a 'contact map', each dot represents
	pair-interactions between aminoacids, numbered on the axis. They are
	colored according to their frustration index.
	The other ones are projections of the contact information on the sequence space.
	 
	<br><br><br></li> 
	<li> 
	<b> 
	What are the '<font color="gray"><b>neutral</b></font>' contacts?
	</b><br><br> 
	 
	'<font color="gray"><b>Neutral</b></font>' interactions are not particularly favorable nor
	unfavorable for folding. They might reflect intrinsic evolutionary
	drift. For clarity, the neutral contacts are not draw on the structure
	by default.
	 
	<br><br><br></li> 
	<li> 
	<b> 
	Can I download the results?
	</b><br><br> 
	Yes you can. Fetch the results page of your job by entering your job ID in the field below, or by following the link contained in the email we sent you. Then click in the Download link in the bottom of the results page.
	 
	<br><br><br></li> 
	<li> 
	<b> 
	Hey! You changed the numbering of my pdb file ! ?
	</b><br><br> 
	 
	We might have, sorry. In the present release the pdb files are
	renumbered starting from 1, gaps are ignored, and only the most common
	20 aminoacids are taken into account.
	 
	<br><br><br></li> 
	<li> 
	<b> 
	What about secondary structure propensity ?
	</b><br><br> 
	 
	At present the server does not take into account any secondary
	structure energy. Only the tertiary contact energies are evaluated
	according to the <a href="frustra_references.php#12">AMW energy function [12]</a>.
	 
	<br><br><br></li> 
	<li> 
	<b> 
	What about side-chain rotamers ?
	</b><br><br> 
	 
	No energetic terms for side-chains are explicitly taken into
	account. Only Calpha and Cbeta positions and energies are evaluated in
	the AMW energy function.
	 
	<br><br><br></li> 
	<li> 
	 
	<b> 
	 
	Are my results confidential?
	</b><br><br> 
	 
	No they are not. Anyone can see/download any calculation that is
	performed on this server. Only your email address and job association
	are kept confidential.
	 
	<br><br><br></li> 
	<li> 
	<b> 
	May I use the frustratometer results ?
	</b><br><br> 
	 
	We'll be glad if they are useful. Please cite us in case you do.
	 
	
	 
</ul>
<?php
echo file_get_contents('footer.php');
?>
