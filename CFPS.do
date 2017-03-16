clear all
prog drop _all
capture log close
set more off

cd "/Users/elmerleezy/Google Drive/Wagner/Semester 4/Capstone/Capstone 2016-2017/Data/Raw - CFPS"

****************************************************************
*** Household Head Analysis ***
****************************************************************

** gender age party ethinicity(minzu)
use "$datadir/Users/yuanyuanyang/Desktop/cfps/adult2104.dta", clear
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

****************************************
*** Financial Information ***
****************************************

***************get the info of income and expenses  （income:55534, expense:57387）
use family2014
keep fid14 fincome1 expense
sum fincome1
su expense
save income+expense

