clear all
prog drop _all
capture log close
set more off

cd "/Users/elmerleezy/Google Drive/Wagner/第三学期/Capstone/Data/Raw"


use "CHIP2013_urban_person.dta", clear

sum coun
*** observations: 19,887  

* keep the independent variables from the "person" dataset including age,sex, gender and so forth
keep hhcode person coun a02 a03 a04_1 a04_2 a05 a06 a07_1 a13_1 a16_1 a19
save urban_independent


* capture the household size of each family
collapse (max) person, by (hhcode)
rename person hhsize 
save urban_hhsize
*** observations:  6,674  

* keep the independent variables of each household head 
use urban_independent
keep if a02==1
save hhead_independent


* merge household size and househead datasets,which is one-to-one merging
use hhead_independent, clear
sort hhcode
save hhead_independent2

use urban_hhsize, clear
sort hhcode
save urban_hhsize2

use hhead_independent2, clear
merge 1:1 hhcode using urban_hhsize2

tab _merge
drop _merge
save urban_independent, replace


use "CHIP2013_urban_household_f_income_asset.dta", clear
* keep the dependent variables of liquid aeests
keep hhcode f01_1 f03 f04 f06_2 f06_3
save urban_dependent

* merge dependent variable dataset and independent variable dataset, which is one-to-one merging
use urban_dependent, clear
sort hhcode
save urban_dependent2

use urban_independent, clear
drop _merge
sort hhcode
save urban_independent2

use urban_dependent2, clear
merge 1:1 hhcode using urban_independent2

tab _merge
drop _merge
save urban_variable


* merge the urban_variable and mls_urban, which is one-to-many merging
use urban_variable, clear
sort coun
save urban_variable2

use mls_urban, clear
sort coun
save mls_urban2

use urban_variable2, clear
merge coun using mls_urban2

tab _merge
drop _merge
save urban_asset


* change the order of variables
order hhcode coun hhsize person a02 a03 a04_1 a04_2 a05 a06 a07_1 a13_1 a16_1 a19 f01_1 f03 f04 f06_2 f06_3 mls2013


* replace all the missing data of liquid assets
gen new_f03=f03
replace new_f03 =0 if f03 ==. 
replace new_f03 =0 if f03 ==-1

gen new_f04=f04
replace new_f04 =0 if f04 ==. 
replace new_f04 =0 if f04 ==-1 

gen new_f06_2=f06_2
replace new_f06_2 =0 if f06_2 ==. 
replace new_f06_2 =0 if f06_2 ==-1

gen new_f06_3=f06_3
replace new_f06_3 =0 if f06_3 ==. 
replace new_f06_3 =0 if f06_3 ==-1

* calculate the total liquid assts of every household
gen liasset=new_f03 + new_f04 + new_f06_2 + new_f06_3

* calculate the asset poverty rate of urban data
gen asset =liasset- mls2013*hhsize*3
gen asset2=asset
replace asset2=1 if asset>=0
replace asset2=0 if asset<0

tab asset2
* the result shows that asset poverty rate of urban data is 9.68%, which matches the result while I use commands to do last week



* calculate the asset poverty using world bank standard $1.25/day. PPP exchange rate of dollars and RMB is 6.196 in 2013
gen asset_A=liasset-1.25*6.196*91.25*hhsize
gen asset_A2=asset_A
replace asset_A2=1 if asset_A>=0
replace asset_A2=0 if asset_A<0

tab asset_A2
* in this case, asset poverty rate is 8.09% when we use $1.25/day



* calculate the asset poverty using world bank standard, $1.9/day. PPP exchange rate of dollars and RMB is 6.196 in 2013
gen asset_B=liasset-1.9*6.196*91.25*hhsize
gen asset_B2=asset_B
replace asset_B2=1 if asset_B>=0
replace asset_B2=0 if asset_B<0

tab asset_B2
* in this case, asset poverty rate is 9.92% when we use $1.9/day



* calculate the asset poverty using world bank standard, $2/day. PPP exchange rate of dollars and RMB is 6.196 in 2013
gen asset_C=liasset-2*6.196*91.25*hhsize
gen asset_C2=asset_C
replace asset_C2=1 if asset_C>=0
replace asset_C2=0 if asset_C<0

tab asset_C2
* in this case, asset poverty rate is 10.02% when we use $2/day



* categorise age of household head
gen age=2013-a04_1
gen age2=age
replace age2=1 if age<=29
replace age2=2 if age>=30 & age<=39
replace age2=3 if age>=40 & age<=49
replace age2=4 if age>=50 & age<=59
replace age2=5 if age>=60 

tab age2


* categorise education of housejold head
gen edu=a13_1
gen edu2=edu
replace edu2=1 if edu<=3
replace edu2=2 if edu>=4 & edu<=6
replace edu2=3 if edu==7
replace edu2=4 if edu>=8 

tab edu2


*categorise ethnicity,political party,marital status,employment and health of household head
tab a06
tab a07_1
tab a05
tab a19
tab a16_1

* get the information of household characteristics:household size and income
su hhsize
su f01_1

save urban_asset, replace



* capture the information of number of kids 
use "$datadir/Users/yuanyuanyang/Desktop/asset building data/urban_person.dta", clear
keep hhcode person coun a03 a04_1
save urban_charc

gen age=2013-a04_1
gen age2=age
replace age2=1 if age<=16
replace age2=0 if age>16
collapse (sum) age2, by (hhcode)
rename age2 num_chil
save urban_child

*merge the number of child into the urban dataset
use urban_child, clear
sort hhcode
save urban_child2

use urban_asset, clear
sort hhcode
save urban_asset2

use urban_child2, clear
merge hhcode using urban_asset2

tab _merge
drop _merge
save urban_asset, replace

* capture the information of number of the olders 
use "$datadir/Users/yuanyuanyang/Desktop/asset building data/urban_charc.dta", clear

gen age=2013-a04_1
gen age2=age
replace age2=1 if age>=60 & a03==1
replace age2=1 if age>=55 & a03==2
replace age2=0 if age<55
replace age2=0 if age<60 & a03==1
collapse (sum) age2, by (hhcode)
rename age2 num_old
save urban_old
*merge the number of child into the urban dataset
use urban_old, clear
sort hhcode
save urban_old2

use urban_asset, clear
sort hhcode
save urban_asset3

use urban_old2, clear
merge hhcode using urban_asset3

tab _merge
drop _merge
save urban_asset, replace
























