clear all
prog drop _all
capture log close
set more off

cd "/Users/elmerleezy/Google Drive/Wagner/第三学期/Capstone/Data/Raw"


use "CHIP2013_rural_person.dta", clear

sum coun 
*** observations: 39,065 

describe

* keep the independent variables from the "person" dataset including age,sex, gender and so forth
keep hhcode person coun a02 a03 a04_1 a04_2 a05 a06 a07_1 a13_1 a16_1 a19
label var a02 "Relationship to the household head	1=head, 2=spouse, 3=son/daughter .."
label var a03 "Gender	1=Male, 2=Female"
label var a04_1	"Year of birth"
label var a04_2	"Month of birth"
label var a05 "Marital status	1=first, 2=remarried…"
label var a06 "Ethnicity	1= Han, 2=Zhuang…"
label var a07_1 "Political affiliation	1=communist, 2=Democratic.."
label var a13_1	"Highest level of education	1=no school, 2=elementary.."
label var a16_1	"current health condition	1=Excellent, 2=Good…"
label var a19 "Empoyment/study situation of 2013	1=Employed, 2=Retired from gov't"
save rural_independent


* capture the household size of each family
collapse (max) person, by (hhcode)
rename person hhsize 
save rural_hhsize

sum hhsize
*** observations: 10,490  

* keep the independent variables of each household head 
use "rural_independent.dta", clear
keep if a02==1
save rulhhead_independent


* merge household size and househead datasets,which is one-to-one merging
use rulhhead_independent, clear
sort hhcode
save rulhhead_independent2

use rural_hhsize, clear
sort hhcode
save rural_hhsize2

use rulhhead_independent2, clear
merge 1:1 hhcode using rural_hhsize2

tab _merge
drop _merge
save rural_independent, replace


use "CHIP2013_rural_household_f_income_asset.dta", clear
* keep the dependent variables of liquid aeests
keep hhcode f01_1 f03 f04 f06_2 f06_3
label var f01_1	"Total disposable income of the household in 2013"
label var f03 "The balance of RMB financial assests (the total amount)"
label var f04 "The balance of foreign currency financial assets (Converting into RMB)"
label var f06_2	"Gold (Not including gold ornaments)"
label var f06_3	"Other precious metals and jewelry (Including gold and ornaments)"
save rural_dependent

* merge dependent variable dataset and independent variable dataset, which is one-to-one merging
use rural_dependent, clear
sort hhcode
save rural_dependent2

use rural_independent, clear
sort hhcode
save rural_independent2

use rural_dependent2, clear
merge 1:1 hhcode using rural_independent2

tab _merge
drop _merge
save rural_variable


* merge the urban_variable and mls_urban, which is one-to-many merging
use rural_variable, clear
sort coun
save rural_variable2

use mls_rural, clear
sort coun
save mls_rural2

use rural_variable2, clear
merge coun using mls_rural2

tab _merge
drop _merge
save rural_asset


* change the order of variables
order hhcode coun hhsize person a02 a03 a04_1 a04_2 a05 a06 a07_1 a13_1 a16_1 a19 f01_1 f03 f04 f06_2 f06_3 mls_rural


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

* calculate the asset poverty rate of rural data
gen asset =liasset- mls_rural*hhsize*3
gen asset2=asset
replace asset2=1 if asset>=0
replace asset2=0 if asset<0

tab asset2
* the result shows that asset poverty rate of rural data is 12.84%, which matches the result while I use commands to do last week



* calculate the asset poverty using world bank standard $1.25/day. PPP exchange rate of dollars and RMB is 6.196 in 2013
gen asset_A=liasset-1.25*6.196*91.25*hhsize
gen asset_A2=asset_A
replace asset_A2=1 if asset_A>=0
replace asset_A2=0 if asset_A<0

tab asset_A2
* in this case, asset poverty rate is 14.92% when we use $1.25/day



* calculate the asset poverty using world bank standard, $1.9/day. PPP exchange rate of dollars and RMB is 6.196 in 2013
gen asset_B=liasset-1.9*6.196*91.25*hhsize
gen asset_B2=asset_B
replace asset_B2=1 if asset_B>=0
replace asset_B2=0 if asset_B<0

tab asset_B2
* in this case, asset poverty rate is 19.23% when we use $1.9/day



* calculate the asset poverty using world bank standard, $2/day. PPP exchange rate of dollars and RMB is 6.196 in 2013
gen asset_C=liasset-2*6.196*91.25*hhsize
gen asset_C2=asset_C
replace asset_C2=1 if asset_C>=0
replace asset_C2=0 if asset_C<0

tab asset_C2
* in this case, asset poverty rate is 19.49% when we use $2/day



* categorise age of household head
gen age=2013-a04_1
gen age2=age
replace age2=1 if age<=29
replace age2=2 if age>=30 & age<=39
replace age2=3 if age>=40 & age<=49
replace age2=4 if age>=50 & age<=59
replace age2=5 if age>=60 

tab age2


* categorise education of household head
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

save rural_asset, replace



* capture the information of number of kids 
use "$datadir/Users/yuanyuanyang/Desktop/asset building data/rural_person.dta", clear
keep hhcode person coun a03 a04_1
save rural_charc

gen age=2013-a04_1
gen age2=age
replace age2=1 if age<=16
replace age2=0 if age>16
collapse (sum) age2, by (hhcode)
rename age2 num_chil
save rural_child

*merge the number of child into the rural dataset
use rural_child, clear
sort hhcode
save rural_child2

use rural_asset, clear
sort hhcode
save rural_asset3

use rural_child2, clear
merge hhcode using rural_asset3

tab _merge
drop _merge
save rural_asset, replace

* capture the information of number of the olders 
use "$datadir/Users/yuanyuanyang/Desktop/asset building data/rural_charc.dta", clear

gen age=2013-a04_1
gen age2=age
replace age2=1 if age>=60 & a03==1
replace age2=1 if age>=55 & a03==2
replace age2=0 if age<55
replace age2=0 if age<60 & a03==1
collapse (sum) age2, by (hhcode)
rename age2 num_old
save rural_old
*merge the number of child into the rural dataset
use rural_old, clear
sort hhcode
save rural_old2

use rural_asset, clear
sort hhcode
save rural_asset4

use rural_old2, clear
merge hhcode using rural_asset4

tab _merge
drop _merge
save rural_asset, replace



