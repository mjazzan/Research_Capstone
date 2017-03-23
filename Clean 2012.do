clear all
prog drop _all
capture log close
set more off

cd "/Users/elmerleezy/Google Drive/Wagner/Semester 4/Capstone/Capstone 2016-2017/Data/Raw - CFPS/2012"

****************************************************************
*** Household Head Analysis ***
****************************************************************

** gender age party ethinicity(minzu), highest level of edu attained(sw1r), current marital status(qe104), 
** self-eval health(qp201), employment(employ)
** type of employer not available for this dataset
* in 2012, personal income is (income)

use Ecfps2012adultcombined_032015, clear
keep pid fid12 income cfps2012_gender cfps2012_age cfps_party cfps_minzu cfps2011_latest_edu sw1r qe104 qp201 employ
save independent_2012

********get the info of hh head            
*****keep the person with the largest amount of personal income
use independent_2012, clear 
bysort fid12: egen head=max(income)
keep if head==income


********within a household, keep the first one when their personal income are the same 
* (13,281 households)
bysort fid12: gen head_order=_n
keep if head_order==1
save head_independent_2012,replace

tab cfps2012_gender
su cfps2012_age 
tab cfps2012_latest_edu
tab qe104
tab qp201
tab employ  
*****Notes:variables like party and ethinicity have a lot of missing

****************************************************************
*** Family  Analysis ***
****************************************************************

** number of old       （0.62 on average）
use independent_2012, clear
gen old=0
replace old=1 if cfps2012_age>=60
collapse (sum) old, by (fid12)
su old
save old_2012, replace

** number of dependent    （1.36 on average）
use independent_2012, clear
gen depen=0
replace depen=1 if income==0 & cfps2012_age>=16
collapse (sum) depen, by (fid12)
su depen
save depen_2012, replace

** number of children       （1.44 on average）
use Ecfps2012childcombined_032015, clear
gen children=0
replace children=1 if cfps2012_age<16
collapse (sum) children, by (fid12)
su children
save children_2012, replace

****************************************
*** Financial Information ***
****************************************

***************get the info of income and expenses  （income:55534, expense:57387）
use cfps2012family_092015compress, clear
keep fid12 fid10 provcd countyid familysize fincome1 fr501m expense fq1 houseprice1 fr2a ft1 ft2 ft301 ft401 ft501 ft701 fr301 ft801 ft802

* recode these values into missing
mvdecode _all, mv(-8)
mvdecode _all, mv(-1)
mvdecode _all, mv(-2)

* rename all the variables 
	* gen fincome_tot
gen fincome_rent = fr501m
	* gen fincome_rtland 
	* gen expense_annual

gen house_ownership = fq1
gen house_price = houseprice1*10000
gen house_price_other = fr2a*10000
egen house_price_tot = rowtotal(house_price house_price_other)

	* gen asset_cash
	* gen asset_deposit
gen asset_cash_deposit = ft1

egen asset_financial = rowtotal(ft301 ft401 ft501 ft701)
	* gen asset_financial_income
gen debt_mortgage_tot = fr301
gen debt_bank = ft801
gen debt_frind_other_ins = ft802
egen debt_tot = rowtotal(debt_mortgage_tot  debt_bank  debt_frind_other_ins)

sum fincome1
su expense
sum house_price_tot
sum asset_cash_deposit
sum asset_financial
sum debt_tot
save family_2012, replace

* fincome1: pure hh income; finc: total income
** IN THIS YEAR, THERE IS NO FINC
* fproperty_1: property income 
* ftransfer_1: transfer income
* fr501m: rent income; in this year Obs-129 mean-3.813953
* fs201: land rent income ** IN THIS YEAR THIS IS THE AREA OF LAND RENTED
* fs501: income from renting other things: 13,315, mean - 15.99196
* fs6: durable goods

* fexp: expense for the last 12 months** THIS IS NOT USEBLE THIS YEAR
* fq2 = houseprice1
* fq6: Non
* fr2a: other house price ** SIGNIFICANTLY DIFFERENT FROM LAST YEAR

* ft1： cash/saving deposit ** IN THIS YEAR, FT1 INCLUDE BOTH CASH & DEPOSIT - Mean: 25168
* ft2: interest from deposit
* ft301: gov bond
* ft401: stock
* ft501: financial fund
* FT701	Total current market value of other financial assets held by family now(yuan)
* fr301： mortgage total 
* ft801 ft802: loan from bank and friends

*** Merge family and household head independent_2012 ***
use head_independent_2012, clear
sort fid12

use old_2012, clear
sort fid12

use depen_2012, clear
sort fid12

use children_2012, clear
sort fid12

use family_2012, clear
sort fid12
merge 1:1 fid12 using old
drop _merge
save family_2012, replace

use family_2012, clear
sort fid12
merge 1:1 fid12 using depen
drop _merge
save family_2012, replace

use family_2012, clear
sort fid12
merge 1:1 fid12 using children
drop _merge
save family_2012, replace

use family_2012, clear
sort fid12
merge 1:1 fid12 using head_independent_2012

** restrict the sample (total 13777)
keep if _merge==3
drop if fid12==.

drop _merge
save family_head_2012, replace


