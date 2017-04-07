clear all
prog drop _all
capture log close
set more off

cd "/Users/elmerleezy/Google Drive/Wagner/Semester 4/Capstone/Capstone 2016-2017/Data/Raw - CFPS/2014"

****************************************************************
*** Household Head Analysis ***
****************************************************************

*** gender age party ethinicity(minzu), highest level of edu(pw1r), current marital status(qea0), self-eval health(qp201), employment(employ2014), type of employer(qg2)
use ecfps2014adult_2016, clear
keep pid fid14 p_income cfps_gender cfps2014_age cfps_party qa701code cfps2012_latest_edu pw1r qea0 qp201 employ2014 qg2
save independent_2014,replace

*** get the info of hh head             (13944 households)
*** keep the person with the largest amount of personal income
use independent_2014
bysort fid14: egen head=max(p_income)
keep if head==p_income

*** within a household, keep the first one when their personal income are the same   (female：37.86%,  age45)
bysort fid14: gen head_order=_n
keep if head_order==1

rename cfps_gender gender 
rename cfps2014_age age
rename cfps_party party
rename qa701code ethnicity
rename cfps2012_latest_edu edu_highest 
	* to make variable constant we lable cfps2012_latest_edu as the highest education rather than pw1r
* rename pw1r edu_highest
rename qea0 marriage
rename qp201 health
rename employ2014 employ 
drop head_order head qg2 pw1r
save head_independent_2014,replace

tab gender
su age 
tab edu_latest
tab marriage
tab health
tab employ  
*****Notes:variables like party and ethinicity have a lot of missing

****************************************************************
*** Family  Analysis ***
****************************************************************

** number of old       （0.62 on average）
use independent_2014, clear
gen old=0
replace old=1 if cfps2014_age>=60
collapse (sum) old, by (fid14)
su old
save old_2014, replace

** number of dependent    （1.24 on average）
use independent_2014
gen depen=0
replace depen=1 if p_income==0 & cfps2014_age>=16
collapse (sum) depen, by (fid14)
su depen
save depen_2014, replace

** number of children       （0.62 on average）
use cfps2014child_20161230, clear
gen children=0
replace children=1 if cfps2014_age<16
collapse (sum) children, by (fid14)
su children
save children_2014, replace

****************************************
*** Financial Information ***
****************************************

***************get the info of income and expenses  （income:55534, expense:57387）
use cfps2014famecon_20161230, clear 
keep fid14 fid12 fid10 provcd14 countyid14 urban14 familysize fincome1 finc fr501 fs201 expense fexp fq2 fq6 fr2 ft1 ft101 ft201 ft202 ft301 ft302 ft501 ft601 ft602

* recode these values into missing
mvdecode _all, mv(-8)
mvdecode _all, mv(-1)
mvdecode _all, mv(-2)

* rename all the variables 
gen fincome_tot = finc
gen fincome_rent = fr501
gen fincome_rtland = fs201
gen expense_annual = fexp

gen house_ownership = fq2
gen house_price = fq6*10000
gen house_price_other = fr2*10000
egen house_price_tot=rowtotal(house_price house_price_other)
* replace house_price_tot = . if fq6 + fr2 > 1000

gen asset_cash = ft1
gen asset_deposit = ft101
egen asset_cash_deposit = rowtotal(asset_cash asset_deposit)
gen asset_financial = ft201
gen asset_financial_income = ft202

gen debt_mortgage_tot = ft301
gen debt_bank = ft501
gen debt_frind = ft601
gen debt_other_ins = ft602
gen debt_frind_other_ins = debt_frind + debt_other_ins
egen debt_tot = rowtotal(debt_mortgage_tot debt_bank debt_frind debt_other_ins)
rename countyid14 countyid
rename fincome1 f_income
rename provcd14 provcd
rename urban14 urban

* graph twoway (scatter asset_cash_deposit expense, ms(o) mc(gs4) msize(small))

keep fid14 fid12 fid10 provcd countyid urban familysize f_income expense house_ownership house_price house_price_tot asset_cash_deposit asset_financial debt_mortgage_tot debt_frind_other_ins debt_tot
save family_2014, replace

sum f_income
su expense
sum house_price_tot
sum asset_cash_deposit
sum asset_financial
sum debt_tot
* fincome1: pure hh income; finc: total income
* fr501: rent income fs201: land rent income fs501: income from renting other things
* fs6: durable goods
* fq2 fq6 fr2: house price
* ft1 ft101: cash/saving deposit
* ft201 ft202: amount of financial asset and income from them
* ft301 ft302: mortgage total and annual
* ft501 ft601 ft602: owe bank, friend, other institution

*** Merge family and household head independent_2014 ***


use family_2014, clear
sort fid14
merge 1:1 fid14 using old_2014
drop _merge
save family_2014, replace

use family_2014, clear
sort fid14
merge 1:1 fid14 using depen_2014
drop _merge
save family_2014, replace

use family_2014, clear
sort fid14
merge 1:1 fid14 using children_2014
drop _merge
save family_2014, replace

use family_2014, clear
sort fid14
merge 1:1 fid14 using head_independent_2014

** restrict the sample (total 13777)
keep if _merge==3
drop if fid12==.

drop _merge
save family_head_2014, replace






