///Tom Dudding, Simon Haworth, Nic Timpson
///Date: 24th June 2015
///Version 1
///Project: GWAS rare varient vitamin D
///Stage: Phenotype variable generation
///withdrawl of consent dealt with prior to using this file

//Need to run "\\ads.bris.ac.uk\filestore\MyFiles\Staff3\td8069\Documents\Data\WINDOWSdata_extraction_childgwas.do"
//before to extract variables and remove WOC participants

clear all
set more off

cd "/Volumes/td8069/Documents/Data"

capture log close
capture erase "vitdgwas.log"
log using "vitdgwas.log", replace

 use "vitdgwaschilddata.dta", clear

 
 //combining vitamin d from different clinics
gen vitd_all = vitdtot_F7
replace vitd_all = vitdtot_F9 if vitd_all==.
replace vitd_all = vitdtot_F11 if vitd_all==.
lab variable vitd_all "Total vitamin D all ages (nmol/L)"

//combining bmi form different clinics
gen bmi_all = f7ms026a if vitdtot_F7!=.
replace bmi_all = f9ms026a if vitdtot_F9 !=.
replace bmi_all = fems026a if vitdtot_F11 !=.
lab variable bmi_all "BMI at age of vitamin d sample (kg/m2)"
replace bmi_all =. if bmi_all==-9 | bmi_all==-1

//Generating variable of age at vitamin D sample
gen agevitd = f7003a  if vitdtot_F7!=.
replace agevitd = f9003a if vitdtot_F9 !=.
replace agevitd = fe003a if vitdtot_F11 !=.
lab variable agevitd "Age at vitamin d sample (days)"

//generating season variable at each clinic
gen season7 = .
replace season7 =0 if  f7001 >6 & f7001 < 10
replace season7 =1 if  f7001 >9 & f7001 < 13
replace season7 =2 if  f7001 >0 & f7001 < 4
replace season7 =3 if  f7001 >3 & f7001 < 7

gen season9 = .
replace season9 =0 if  f9001 >6 & f9001 < 10
replace season9 =1 if  f9001 >9 & f9001 < 13
replace season9 =2 if  f9001 >0 & f9001 < 4
replace season9 =3 if  f9001 >3 & f9001 < 7
 
gen season11 = .
replace season11 =0 if  fe001 >6 & fe001 < 10
replace season11 =1 if  fe001 >9 & fe001 < 13
replace season11 =2 if  fe001 >0 & fe001 < 4
replace season11 =3 if  fe001 >3 & fe001 < 7
 
//assign clinic season variable
gen season_all = season7 if vitdtot_F7!=.
replace season_all = season9 if vitdtot_F9 !=.
replace season_all = season11 if vitdtot_F11 !=.
lab variable season_all "Season of vitamin D sample"
label define season_lb 0"Summer" 1"Fall" 2"Winter" 3"Spring"
label values season* season_lb


//A//log transformation of vitamin D
gen lnvitd_all = log(vitd_all)
lab var lnvitd_all "Natural Log vitamin D"

//B// NA

//C//residualise for age sex bmi and season

regress lnvitd_all agevitd kz021 bmi_all i.season_all
 
predict resid_vitd, resid

//hist resid_vitd

egen meanlnvitd = mean(lnvitd_all)
gen new_lnvitd = meanlnvitd + resid_vitd


//D// Z score

egen stdnew_lnvitd = std(new_lnvitd)

//dropping outliers
drop if stdnew_lnvitd >5 | stdnew_lnvitd <-5

//drop missing data
drop if stdnew_lnvitd==.



//Exporting file
export delim aln stdnew_lnvitd using "vitd_phenotype.tab", delimiter(tab) replace

