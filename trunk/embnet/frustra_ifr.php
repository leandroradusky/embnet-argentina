<?php
echo file_get_contents('header.php');
?>

<span class="title"> Interpreting results </span>
<br />
<br />
The frustration index measures of how favorable a particular contact
is relative to the set of all possible contacts in that location,
normalized using the variance of that distribution. For initial
inspection, the server classifies the individual contacts as to their
frustration index value.
</p> 
<p> 
A contact is defined as '<font color="green">minimally frustrated</font>' if its native energy is at the lower end of the distribution of decoy energies, having a frustration index as measured with a Z-score of 0.78 or higher magnitude [<a href="reference.php#11">11</a>], that is, the majority of (but by no means all!) other amino acid pairs in that position would be unfavorable.
</p> 
<p> 
Conversely, a contact is defined as '<font color="red">highly frustrated</font>' if <i>E<sup>0</sup></i> is at
the other end of the distribution with a local frustration index lower
than -1, that is, most other amino acid pairs at that location would
be more favorable for folding than the native ones by more than one
standard deviation of that distribution. If the native energy is in
between these limits, the contact is defined as '<font color="gray"><b>neutral</b></font>'.
</p> 
<p> 
A frustration index may depend on the choice of parts in which the
protein's whole energy is divided. It therefore becomes natural to
divide the energy up in a way that is at least roughly comparable to
what natural selection can do: examine the changes in energy upon
making mutations. The server provides two complementary ways for
localizing frustration that differ in how the set of decoys is
constructed:
</p> 
<ol> 
<li> 
<h4>Mutational Frustration</h4> 
<p> 
(How favourable are the native residues relative to other residues in
that location?)
<br> 
The decoy set is made randomizing the identities of the interacting
amino acids <i>i,j</i>, keeping all other interaction parameters at their
native value. This scheme effectively evaluates every possible
mutation of the amino acid pair that forms a particular contact in a
robustly fixed structure. It is worth noting that the energy change
upon a residue pair mutation not only comes directly from the
particular contact probed, but also changes through interactions of
each residue with other residues not in the mutated pair, and those
contributions will also vary upon mutation.
</p> 
</li> 
<li> 
<h4>Configurational Frustration</h4> 
<p> 
(How favourable are the native interactions between two residues
relative to other interactions these residues can form in other
compact structures?)
<br> 
This way of measuring frustration imagines that the residues are not
only changed in identity but are also displaced in location. The
energy variance thus reflects contributions to different energies of
other compact conformations. In this calculation the decoy set
involves randomizing not just the identities but also the distance and
densities of the interacting amino acids <i>i,j</i>. This scheme effectively
evaluates the native pair with respect to a set of structural decoys
that might be encountered in the folding process.
</p> 
</li> 
</ol> 
 
<br> 
<h3>Physiological rationale</h3> 
 
<p> 
Most of the polipeptide sequences found in the biosphere fold into
defined structural elements forming domains. In order to fold robustly
in biologically relevant timescales, the heteropolymer must be
'<font color="green">minimally frustrated</font>', and thus have an energy landscape that
resembles a rough funnel. It is not folding per se what determines
protein evolution, but the 'biological function' that the polipeptides
create. 
<br> 
The complexity of protein sequences suggests they may contain
conflicting signals encoding folding and function. Yet searching the
immense energy landscape of a protein for the native structure would
be slow if the landscape were very rugged due to many conflicting
local interactions. Minimal frustration implies protein structure is
also robust to mutation. Neither protein's kinetic foldability nor
their mutational robustness deny the possibility that some frustration
from conflicting signals may be present locally in some proteins. Such
local frustration, being tolerable, might naturally arise from random
neutral evolution. Local frustration also could be a functionally
useful adaptation.
<br> 
The possible adaptive value for a molecule to have
spatially localized frustration arises from the way such frustration
may sculpt protein dynamics for specific functions. In a monomeric
protein the alternate configurations caused by locally frustrating an
otherwise largely unfrustrated structure could provide specific
control of the thermal motions, so the protein can function much like
a macroscopic machine having only a few moving parts. Alternatively a
site frustrated in a monomeric protein may become less frustrated in
the final larger assembly containing that protein, thus guiding
specific association.
</p> 
<p > 
<a href="frustra_faq.php">Frequently Asked Questions</a> 
</p> 

<?php
echo file_get_contents('footer.php');
?>