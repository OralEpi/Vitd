*** Syntax template for direct users preparing datasets using child and adult based datasets.

* This version created 29th October 2014 - always create a datafile using the most up to date template.

* This template is based on that used by the data buddy team and they include a number of variables by default.
* To ensure the file works we suggest you keep those in and just add any relevant variables that you need for your project.


****************************************************************************************************************************************************************************************************************************
* To add data other than that included by default you will need to add the relvant files and pathnames in each of the match commands below.
* There is a separate command for mothers, partner, mothers providing data on the child and data provided by the child themselves.
* each has different withdrawal of consent issues so they must be considered separately.
* You will need to replace 'YOUR PATHNAME' in each section with your working directory pathname.

*****************************************************************************************************************************************************************************************************************************.

* MOTHER files - in this section the following files need to be placed:
* Mother completed Qs about herself
* Mother clinic data
* Mother biosamples *

clear
set maxvar 32767	
use "\\ads.bris.ac.uk\filestore\SSCM ALSPAC\Data\Current\Other\Sample Definition\mz_5a.dta", clear
sort aln
gen in_mz=1
merge 1:1 aln using "\\ads.bris.ac.uk\filestore\SSCM ALSPAC\\Data\Current\Quest\Mother\a_3c.dta", nogen
merge 1:1 aln using "\\ads.bris.ac.uk\filestore\SSCM ALSPAC\Data\Current\Quest\Mother\b_4d.dta", nogen
merge 1:1 aln using "\\ads.bris.ac.uk\filestore\SSCM ALSPAC\Data\Current\Quest\Mother\c_7d.dta", nogen
merge 1:1 aln using "\\ads.bris.ac.uk\filestore\SSCM ALSPAC\Data\Useful_data\bestgest\bestgest.dta", nogen

keep aln mz001 mz010 mz010a mz013 mz014 mz028b ///
a006 a525 ///
b032 b650 b663 - b667 ///
c645a c755 c765 c800 - c804 ///
bestgest

* Dealing with withdrawal of consent: For this to work additional variables required have to be inserted before bestgest, so replace the *** line above with additional variables. 
* If none are required remember to delete the *** line.
* An additional do file is called in to set those withdrawing consent to missing so that this is always up to date whenever you run this do file

order aln mz010, first
order bestgest, last

do "\\ads.bris.ac.uk\filestore\SSCM ALSPAC\Data\Syntax\Withdrawal of consent\mother_WoC_040215.do"


save "O:\Documents\Data\mother.dta", replace


*****************************************************************************************************************************************************************************************************************************.
* PARTNER - ***UNBLOCK SECTION WHEN REQUIRED***
* Partner files - in this section the following files need to be placed:
* Partner completed Qs about themself
* Partner clinic data
* Partner biosamples data *

/* use "R:\Data\Current\Quest\Partner\***.dta, clear
merge 1:1 aln using "R:\Data\Current\Quest\Partner\***.dta", nogen
keep aln varlist
save "YOUR PATHNAME\partner.dta", replace */


*****************************************************************************************************************************************************************************************************************************.
* Child BASED files - in this section the following files need to be placed:
* Mother completed Qs about YP

* ALWAYS KEEP THIS SECTION EVEN IF ONLY CHILD COMPLETED REQUESTED, although you will need to remove the *****

use "\\ads.bris.ac.uk\filestore\SSCM ALSPAC\Data\Current\Other\Sample Definition\kz_5b.dta", clear
sort aln qlet
gen in_kz=1
merge 1:1 aln qlet using "\\ads.bris.ac.uk\filestore\SSCM ALSPAC\Data\Current\Other\cohort profile\cp_r1a.dta", nogen

keep aln qlet kz011b kz021 kz030 ///insert niother completed variables
in_core in_alsp in_phase2 in_phase3 tripquad


* Dealing with withdrawal of consent: For this to work additional variables required have to be inserted before in_core, so replace the ***** line with additional variables.
* If none are required remember to delete the ***** line.
* An additional do file is called in to set those withdrawing consent to missing so that this is always up to date whenever you run this do file

order aln qlet kz021, first
order in_alsp tripquad, last

do "\\ads.bris.ac.uk\filestore\SSCM ALSPAC\Data\Syntax\Withdrawal of consent\child_based_WoC_040215.do"


save "O:\Documents\Data\childB.dta", replace

*****************************************************************************************************************************************************************************************************************************.
* Child COMPLETED files - in this section the following files need to be placed:
* YP completed Qs
* Puberty Qs
* Child clinic data
* Child biosamples data

* If there are no child completed files, this section can be starred out.
* NOTE: having to keep kz021 tripquad just to make the withdrawal of consent work - these are dropped for this file as the ones in the child BASED file are the important ones and should take priority

use "\\ads.bris.ac.uk\filestore\SSCM ALSPAC\Data\Current\Other\Sample Definition\kz_5b.dta", clear
sort aln qlet
merge 1:1 aln qlet using "\\ads.bris.ac.uk\filestore\SSCM ALSPAC\Data\Current\Other\cohort profile\cp_r1a.dta", nogen
merge 1:1 aln qlet using "\\ads.bris.ac.uk\filestore\SSCM ALSPAC\Data\Current\Other\Samples\Child\Child_bloods_r2a.dta", nogen
merge 1:1 aln qlet using "\\ads.bris.ac.uk\filestore\SSCM ALSPAC\Data\Current\Clinic\Child\f07_3d.dta", nogen
merge 1:1 aln qlet using "\\ads.bris.ac.uk\filestore\SSCM ALSPAC\Data\Current\Clinic\Child\f09_3b.dta", nogen
merge 1:1 aln qlet using "\\ads.bris.ac.uk\filestore\SSCM ALSPAC\Data\Current\Clinic\Child\f11_4b.dta", nogen

keep aln qlet kz021 ///insert clinic variables
Vitdd2_F7 vitdd2i_F7 vitdd3_F7 vitdtot_F7 f7001 f7002 f7003a f7003b f7003c f7ms026a  ///
Vitdd2_F9 vitdd2i_F9 vitdd3_F9 vitdtot_F9 f9001 f9002 f9003a f9003b f9003c f9ms026a ///
Vitdd2_F11 vitdd2i_F11 vitdd3_F11 vitdtot_F11 fe001 fe002 fe003a fe003b fe003c fems026a ///
tripquad

* Dealing with withdrawal of consent: For this to work additional variables required have to be inserted before tripquad, so replace the ***** line with additional variables.
* An additional do file is called in to set those withdrawing consent to missing so that this is always up to date whenever you run this do file

order aln qlet kz021, first
order tripquad, last

do "\\ads.bris.ac.uk\filestore\SSCM ALSPAC\Data\Syntax\Withdrawal of consent\child_completed_WoC_220515.do"


drop kz021 tripquad
save "O:\Documents\Data\childC.dta", replace

*****************************************************************************************************************************************************************************************************************************.
** Matching all data together and saving out the final file*.
* NOTE: any linkage data should be added here*.

use "O:\Documents\Data\childB.dta", clear
merge 1:1 aln qlet using "O:\Documents\Data\childC.dta", nogen
merge m:1 aln using "O:\Documents\Data\mother.dta", nogen
* IF partner data is required please unstar the following line
/* merge m:1 aln using "YOUR PATHWAY\partner.dta", nogen */


* Remove non-alspac children.
drop if in_alsp!=1.

* Remove trips and quads.
drop if tripquad==1

drop in_alsp tripquad
save "O:\Documents\Data\vitdgwaschilddata.dta", replace

*****************************************************************************************************************************************************************************************************************************.
* QC checks*
use "O:\Documents\Data\vitdgwaschilddata.dta", clear

* Check that there are 15445 records.
count
