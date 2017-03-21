*******************
*  Startup
*******************

clear all
prog drop _all
capture log close
set more off

 * Type your directory here: 
cd "/Users/elmerleezy/Google Drive/Wagner/第三学期/Capstone/Data/Raw"

******************************************
** Independent Vairable **
******************************************

use "CHIP2013_urban_person.dta", clear

* keep the independent variables from the "person" dataset including age,sex, gender and so forth
keep hhcode person coun a02 a03 a04_1 a04_2 a05 a06 a07_1 a13_1 a16_1 a19
label var a02 "Relationship to the household head	1=head, 2=spouse, 3=son/daughter .."
label var a03 "Gender	1=Male, 2=Female"
label var a04_1	"Year of birth"
label var a04_2	"Month of birth"
label var a05 "Marital status	1=first, 2=remarried…"
label var a06 "Ethnicity	1= Han, 2=Zhuang…"
label var a07_1 "Political affiliation	1=communist, 2=Democratic.."
label var a13_1	"Highest level of education	1=no school, 2=elementary, 3=junior middle 4=senior middle 5=vocational senior secondary, 6=specialized secondary 7=polytechnic college 8=undergrad 9=Graduate"
label var a16_1	"current health condition	1=Excellent, 2=Good 3=Average 4=Poor 5=Very poor"
label var a19 "Empoyment/study situation of 2013	1=Employed, 2=Retired from gov't 3=Retired from enterprise 4=student 5=unemployed 6=FT homekeeper 7=Pregnant/maternity leave 8=long-term sick leave 9=Other, neither work/school"
save urban_independent

* capture the household size of each family
collapse (max) person, by (hhcode)
rename person hhsize 
save urban_hhsize


* Create a new dataset keeping the independent variables of each household head 
use urban_independent
keep if a02==1
save urbhhead_independent


* merge household size and househead datasets,which is one-to-one merging
use urbhhead_independent, clear
sort hhcode

use urban_hhsize, clear
sort hhcode

use urbhhead_independent, clear
merge 1:1 hhcode using urban_hhsize

drop _merge
save urban_independent, replace

******************************************
** Dependent Vairable **
******************************************

use "CHIP2013_urban_household_f_income_asset.dta", clear

* keep the dependent variables of liquid aeests
keep hhcode f01_1 f03 f04 f06_2 f06_3
label var f01_1	"Total disposable income of the household in 2013"
label var f03 "The balance of RMB financial assests (the total amount)"
label var f04 "The balance of foreign currency financial assets (Converting into RMB)"
label var f06_2	"Gold (Not including gold ornaments)"
label var f06_3	"Other precious metals and jewelry (Including gold and ornaments)"
save urban_dependent

* merge dependent variable dataset and independent variable dataset, which is one-to-one merging
use urban_dependent, clear
sort hhcode
save urban_dependent2
merge 1:1 hhcode using urban_independent

drop _merge

* change the order of variables
order hhcode coun hhsize person a02 a03 a04_1 a04_2 a05 a06 a07_1 a13_1 a16_1 a19 f01_1 f03 f04 f06_2 f06_3 /*mls_urban*/
save urban_variable


******************************************
** Include Other information **
******************************************

*** Get and Merge Minimum Living Standard(MLS) data
* merge the urban_variable and mls_urban, which is one-to-many merging
use urban_variable, clear
sort coun
save, replace

use mls_urban, clear
sort coun
save, replace

use urban_variable, clear
merge coun using mls_urban

tab _merge
drop _merge*
rename mls2013 mls
save urban_variable, replace

* capture the information of number of kids 
use "CHIP2013_urban_person.dta", clear
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
save, replace

use urban_variable, clear
sort hhcode
save, replace

use urban_child, clear
merge hhcode using urban_variable

tab _merge
drop _merge
save urban_variable, replace

* capture the information of number of the olders 
use urban_charc, clear

gen age=2013-a04_1
gen age2=age
replace age2=1 if age>=60 & a03==1
replace age2=1 if age>=55 & a03==2
replace age2=0 if age<55
replace age2=0 if age<60 & a03==1
collapse (sum) age2, by (hhcode)
rename age2 num_old
save urban_old
*merge the number of old into the urban dataset
use urban_old, clear
sort hhcode
save, replace

use urban_variable, clear
sort hhcode
save, replace

use urban_old, clear
merge hhcode using urban_variable

drop _merge
save urban_variable, replace