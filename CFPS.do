clear all
prog drop _all
capture log close
set more off

cd "/Users/elmerleezy/Google Drive/Wagner/Semester 4/Capstone/Capstone 2016-2017/Data/Raw - CFPS"

****************************************************************
*** Household Head Analysis ***
****************************************************************

** gender age party ethinicity(minzu), highest level of edu(pw1r), current marital status(qea0), 
** self-eval health(qp201), employment(employ2014), type of employer(qg2)
use ecfps2014adult_2016, clear
keep pid fid14 p_income cfps_gender cfps2014_age cfps_party cfps_minzu cfps2012_latest_edu pw1r qea0 qp201 employ2014 qg2
save head_independent

********get the info of hh head             (13944 households)
*****keep the person with the largest amount of personal income
use head_independent
bysort fid14: egen head=max(p_income)
keep if head==p_income


********within a household, keep the first one when their personal income are the same   (female：37.86%,  age45)
bysort fid14: gen head_order=_n
keep if head_order==1
tab cfps_gender
su cfps2014_age 
tab cfps2012_latest_edu
tab qea0
tab qp201
tab employ2014  
*****Notes:variables like party and ethinicity have a lot of missing

****************************************************************
*** Family  Analysis ***
****************************************************************

** number of old       （0.62 on average）
use head_independent
gen old=0
replace old=1 if cfps2014_age>=60
collapse (sum) old, by (fid14)
su old
save old

** number of dependent    （1.24 on average）
use head_independent
gen depen=0
replace depen=1 if p_income==0 & cfps2014_age>=16
collapse (sum) depen, by (fid14)
su depen
save depen

** number of children       （0.62 on average）
use cfps2014child_20161230, clear
gen children=0
replace children=1 if cfps2014_age<16
collapse (sum) children, by (fid14)
su children
save children

****************************************
*** Financial Information ***
****************************************

***************get the info of income and expenses  （income:55534, expense:57387）
use cfps2014famecon_20161230, replace
keep fid14 fid12 fid10 provcd14 countyid14 familysize fincome1 finc fr501 fs201 expense fexp fq2 fq6 fr2 ft1 ft101 ft301 ft302
sum fincome1
su expense
save income+expenses

* fr501: rent income fs201: land rent income fs501: income from renting other things
* fs6: durable goods
* fq2 fq6 fr2: house price
* ft1 ft101: cash/saving deposit
* ft201 ft202: amount of financial asset and income from them
* ft301 ft302: mortgage total and annual
* ft501 ft601 ft602: owe bank, friend, other institution











