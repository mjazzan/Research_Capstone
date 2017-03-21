*******************
*  Startup
*******************

clear all
prog drop _all
capture log close
set more off

 * Type your directory here: 
cd "/Users/elmerleezy/Google Drive/Wagner/第三学期/Capstone/Data/Raw"

use all_variable, clear
keep if inc_p_asset_p 
* sample size 453
save inc_p_asset_p, replace 

use all_variable, clear
keep if inc_p_asset_np
save inc_p_asset_np, replace
* sample size 1053

use all_variable, clear
keep if inc_np_asset_p
save inc_np_asset_p, replace
* sample size 1540

use all_variable, clear
keep if inc_np_asset_np
save inc_np_asset_np, replace
* sample size 14118



use inc_p_asset_p, clear
logit inc_p_asset_p gender age age_sq edu_high edu_23collge edu_4collgeab married ethnicity party health hhsize num_chil num_old Shanxi Liaoning Jiangsu Anhui Shandong Henan Hubei Hunan Guangdong Chongqing Sichuan Yunnan Gansu
outreg2 using myreg2.doc, replace ctitle(income poor and asset poor)

use inc_p_asset_np, clear
logit inc_p_asset_np gender age age_sq edu_high edu_23collge edu_4collgeab married ethnicity party health hhsize num_chil num_old Shanxi Liaoning Jiangsu Anhui Shandong Henan Hubei Hunan Guangdong Chongqing Sichuan Yunnan Gansu
outreg2 using myreg2.doc, append ctitle(income poor and asset not poor)

use inc_np_asset_p, clear
logit inc_np_asset_p gender age age_sq edu_high edu_23collge edu_4collgeab married ethnicity party health hhsize num_chil num_old Shanxi Liaoning Jiangsu Anhui Shandong Henan Hubei Hunan Guangdong Chongqing Sichuan Yunnan Gansu
outreg2 using myreg2.doc, append ctitle(income not poor and asset poor)

use inc_np_asset_np, clear
logit inc_np_asset_np gender age age_sq edu_high edu_23collge edu_4collgeab married ethnicity party health hhsize num_chil num_old Shanxi Liaoning Jiangsu Anhui Shandong Henan Hubei Hunan Guangdong Chongqing Sichuan Yunnan Gansu
outreg2 using myreg2.doc, append ctitle(income not poor and asset not poor)

** SUMMARY

use inc_p_asset_p, clear
use inc_p_asset_np, clear
use inc_np_asset_p, clear
use inc_np_asset_np, clear

tab age2
tab edu2


tab gender
tab age2
tab ethnicity
tab party
tab married
tab employed
tab edu2
tab health
sum hhsize
sum num_chil
sum num_old
sum f01_1
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

use all_variable, clear
outreg2 using sum.xls, replace sum(detail) keep(gender age2 ethnicity party married employed edu2 health hhsize num_chil num_old f01_1 Beijing Shanxi Liaoning Jiangsu Anhui Shandong Henan Hubei Hunan Guangdong Chongqing Sichuan Yunnan Gansu) eqkeep(N sum)
use inc_p_asset_p, clear
outreg2 using sum.xls, append sum(detail) keep(gender age2 ethnicity party married employed edu2 health hhsize num_chil num_old f01_1 Beijing Shanxi Liaoning Jiangsu Anhui Shandong Henan Hubei Hunan Guangdong Chongqing Sichuan Yunnan Gansu) eqkeep(N sum)
use inc_p_asset_np, clear
outreg2 using sum.xls, append sum(detail) keep(gender age2 ethnicity party married employed edu2 health hhsize num_chil num_old f01_1 Beijing Shanxi Liaoning Jiangsu Anhui Shandong Henan Hubei Hunan Guangdong Chongqing Sichuan Yunnan Gansu) eqkeep(N sum)
use inc_np_asset_p, clear
outreg2 using sum.xls, append sum(detail) keep(gender age2 ethnicity party married employed edu2 health hhsize num_chil num_old f01_1 Beijing Shanxi Liaoning Jiangsu Anhui Shandong Henan Hubei Hunan Guangdong Chongqing Sichuan Yunnan Gansu) eqkeep(N sum)
use inc_np_asset_np, clear
outreg2 using sum.xls, append sum(detail) keep(gender age2 ethnicity party married employed edu2 health hhsize num_chil num_old f01_1 Beijing Shanxi Liaoning Jiangsu Anhui Shandong Henan Hubei Hunan Guangdong Chongqing Sichuan Yunnan Gansu) eqkeep(N sum)













