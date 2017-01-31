* as;ldfja;lkdsjf;alkjdf;akljsdf

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

use "CHIP2013_rural_person.dta", clear

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
save rural_independent

* capture the household size of each family
collapse (max) person, by (hhcode)
rename person hhsize 
save rural_hhsize


* Create a new dataset keeping the independent variables of each household head 
use rural_independent
keep if a02==1
save rulhhead_independent


* merge household size and househead datasets,which is one-to-one merging
use rulhhead_independent, clear
sort hhcode

use rural_hhsize, clear
sort hhcode

use rulhhead_independent, clear
merge 1:1 hhcode using rural_hhsize

drop _merge
save rural_independent, replace

******************************************
** Dependent Vairable **
******************************************

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
merge 1:1 hhcode using rural_independent

drop _merge

* change the order of variables
order hhcode coun hhsize person a02 a03 a04_1 a04_2 a05 a06 a07_1 a13_1 a16_1 a19 f01_1 f03 f04 f06_2 f06_3 /*mls_rural*/
save rural_variable


******************************************
** Include Other information **
******************************************

*** Get and Merge Minimum Living Standard(MLS) data
* merge the rural_variable and mls_rural, which is one-to-many merging
use rural_variable, clear
sort coun
save, replace

use mls_rural, clear
sort coun
save, replace

use rural_variable, clear
merge coun using mls_rural

tab _merge
drop _merge*
rename mls_rural mls
save rural_variable, replace

* capture the information of number of kids 
use "CHIP2013_rural_person.dta", clear
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
save, replace

use rural_variable, clear
sort hhcode
save, replace

use rural_child, clear
merge hhcode using rural_variable

tab _merge
drop _merge
save rural_variable, replace

* capture the information of number of the olders 
use rural_charc, clear

gen age=2013-a04_1
gen age2=age
replace age2=1 if age>=60 & a03==1
replace age2=1 if age>=55 & a03==2
replace age2=0 if age<55
replace age2=0 if age<60 & a03==1
collapse (sum) age2, by (hhcode)
rename age2 num_old
save rural_old
*merge the number of old into the rural dataset
use rural_old, clear
sort hhcode
save, replace

use rural_variable, clear
sort hhcode
save, replace

use rural_old, clear
merge hhcode using rural_variable

drop _merge
save rural_variable, replace

******************************************
** Append rural and urban together **
******************************************

use rural_variable, clear 
append using urban_variable 
save all_variable

******************************************
** Clean **
******************************************

* replace all the missing data of liquid assets
rename f03 f03_old
gen f03=f03_old
replace f03 =0 if f03_old ==. 
replace f03 =0 if f03_old ==-1
drop f03_old

rename f04 f04_old
gen f04=f04_old
replace f04 =0 if f04_old ==. 
replace f04 =0 if f04_old ==-1 
drop f04_old

rename f06_2 f06_2_old
gen f06_2=f06_2_old
replace f06_2 =0 if f06_2_old ==. 
replace f06_2 =0 if f06_2_old ==-1 
drop f06_2_old

rename f06_3 f06_3_old
gen f06_3=f06_3_old
replace f06_3 =0 if f06_3_old ==. 
replace f06_3 =0 if f06_3_old ==-1 
drop f06_3_old

******************************************
** Recode **
******************************************

* Gender: recode to 0(male)/1(female)
rename a03 a03_old
gen gender=a03_old
replace gender =0 if a03_old ==1 
replace gender =1 if a03_old ==2 
drop a03_old

* Age: categorise age of household head
gen age=2013-a04_1
gen age_sq=age*age
	* Categorize age
	gen age2=age
	replace age2=1 if age<=29
	replace age2=2 if age>=30 & age<=39
	replace age2=3 if age>=40 & age<=49
	replace age2=4 if age>=50 & age<=59
	replace age2=5 if age>=60 

* Education: categorise education of household head
gen edu=a13_1
gen edu2=edu
replace edu2=1 if edu<=3
replace edu2=2 if edu>=4 & edu<=6
replace edu2=3 if edu==7
replace edu2=4 if edu>=8 
* create dummies for education
gen edu_blhigh = 1 if edu2==1
gen edu_high = 1 if edu2==2
gen edu_23collge = 1 if edu2==3
gen edu_4collgeab = 1 if edu2==4

* replace the missing values
rename edu_blhigh edu_blhigh_old
gen edu_blhigh = edu_blhigh_old 
replace edu_blhigh = 0 if edu_blhigh_old ==.
drop edu_blhigh_old

rename edu_high edu_high_old
gen edu_high = edu_high_old  
replace edu_high = 0 if edu_high_old ==.
drop edu_high_old

rename edu_23collge edu_23collge_old
gen edu_23collge = edu_23collge_old 
replace edu_23collge = 0 if edu_23collge_old ==.
drop edu_23collge_old

rename edu_4collgeab edu_4collgeab_old
gen edu_4collgeab = edu_4collgeab_old 
replace edu_4collgeab = 0 if edu_4collgeab_old ==.
drop edu_4collgeab_old

tab edu2

* Marriage: 
gen married = a05
replace married = 1 if a05<=3
replace married = 0 if a05>3

* Ethnicity
gen ethnicity = a06
replace ethnicity = 1 if a06==1
replace ethnicity = 0 if a06>1

* Party
gen party = a07_1
replace party = 1 if a07_1==1
replace party = 0 if a07_1>1

* Health
gen health = a16_1
replace health = 1 if a16_1<=2
replace health = 0 if a16_1>2

tab health

* Employment
gen employed = a19
replace employed = 1 if a19==1
replace employed = 0 if a19>1
replace employed = . if a19<1

** SUMMARY
tab gender
tab age2
tab ethnicity
tab party
tab married
tab employed
tab edu2
tab health
su hhsize
sum num_chil
su num_old
su f01_1
tab Beijing
tab Shanxi
tab Liaoning
tab Jiangsu
tab Anhui
tab Shandong
tab Henan
tab Hubei
tab Hunan
tab Guangdong
tab Chongqing
tab Sichuan
tab Yunnan
tab Gansu

save all_variable, replace

******************************************
** Calculate Asset/Income Poverty Rate **
******************************************

use all_variable, clear
* calculate the total liquid assts of every household
gen liasset=f03 + f04 + f06_2 + f06_3

* calculate the asset poverty rate of rural data
gen asset_index =liasset/(mls*hhsize*3)
gen asset_p1=asset_index
replace asset_p1=0 if asset_index>=1
replace asset_p1=1 if asset_index<1

tab asset_p1

* calculate the asset poverty using world bank standard, $1.9/day. PPP exchange rate of dollars and RMB is 6.196 in 2013
gen income_index=f01_1/(1.9*6.196*365*hhsize)

gen income_p1=income_index
replace income_p1=0 if income_index>=1
replace income_p1=1 if income_index<1

tab income_p1
* in this case, asset poverty rate is 19.23% when we use $1.9/day

gen poverty = 1 if income_p1 ==1 & asset_p1 ==1 
gen inc_p_asset_p = poverty
replace inc_p_asset_p = 0 if poverty ==.
drop poverty 

gen poverty = 1 if income_p1 ==1 & asset_p1 ==0 
gen inc_p_asset_np = poverty
replace inc_p_asset_np = 0 if poverty ==.
drop poverty

gen poverty = 1 if income_p1 ==0 & asset_p1 ==1
gen inc_np_asset_p = poverty
replace inc_np_asset_p = 0 if poverty ==.
drop poverty

gen poverty = 1 if income_p1 ==0 & asset_p1 ==0
gen inc_np_asset_np = poverty
replace inc_np_asset_np = 0 if poverty ==.
drop poverty

save all_variable, replace

******************************************
** Regression **
******************************************
use all_variable, clear

logit inc_p_asset_p gender age age_sq edu_high edu_23collge edu_4collgeab married ethnicity party health hhsize num_chil num_old Shanxi Liaoning Jiangsu Anhui Shandong Henan Hubei Hunan Guangdong Chongqing Sichuan Yunnan Gansu
outreg2 using myreg.doc, replace ctitle(income poor and asset poor)

logit inc_p_asset_np gender age age_sq edu_high edu_23collge edu_4collgeab married ethnicity party health hhsize num_chil num_old Shanxi Liaoning Jiangsu Anhui Shandong Henan Hubei Hunan Guangdong Chongqing Sichuan Yunnan Gansu
outreg2 using myreg.doc, append ctitle(income poor and asset not poor)

logit inc_np_asset_p gender age age_sq edu_high edu_23collge edu_4collgeab married ethnicity party health hhsize num_chil num_old Shanxi Liaoning Jiangsu Anhui Shandong Henan Hubei Hunan Guangdong Chongqing Sichuan Yunnan Gansu
outreg2 using myreg.doc, append ctitle(income not poor and asset poor)

logit inc_np_asset_np gender age age_sq edu_high edu_23collge edu_4collgeab married ethnicity party health hhsize num_chil num_old Shanxi Liaoning Jiangsu Anhui Shandong Henan Hubei Hunan Guangdong Chongqing Sichuan Yunnan Gansu
outreg2 using myreg.doc, append ctitle(income not poor and asset not poor)


* the result shows that asset poverty rate of rural data is 12.84%, which matches the result while I use commands to do last week


* calculate the asset poverty using world bank standard $1.25/day. PPP exchange rate of dollars and RMB is 6.196 in 2013
gen asset_A=liasset-1.25*6.196*91.25*hhsize
gen asset_A2=asset_A
replace asset_A2=1 if asset_A>=0
replace asset_A2=0 if asset_A<0

tab asset_A2
* in this case, asset poverty rate is 14.92% when we use $1.25/day



* calculate the asset poverty using world bank standard, $2/day. PPP exchange rate of dollars and RMB is 6.196 in 2013
gen asset_C=liasset-2*6.196*91.25*hhsize
gen asset_C2=asset_C
replace asset_C2=1 if asset_C>=0
replace asset_C2=0 if asset_C<0

tab asset_C2
* in this case, asset poverty rate is 19.49% when we use $2/day

save rural_asset, replace


