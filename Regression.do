clear all
prog drop _all
capture log close
set more off

cd "/Users/elmerleezy/Google Drive/Wagner/Semester 4/Capstone/Capstone 2016-2017/Data/Raw - CFPS"

use family_head_all_restrict1, clear

** Different categores of asset
egen liasset= rowtotal(asset_cash_deposit asset_financial)
egen totasset =   rowtotal(asset_cash_deposit asset_financial house_price)
gen debt_tot_neg = debt_tot*-1
egen netasset =   rowtotal(asset_cash_deposit asset_financial house_price debt_tot_neg) 

* Calculate the asset poverty rate 
/*NEED DATA: different poverty lines across years*/
gen liasset_index =liasset/(1.9*6.196*91.25*familysize)
gen totasset_index =totasset/(1.9*6.196*91.25*familysize)
gen netasset_index =netasset/(1.9*6.196*91.25*familysize)

gen liasset_p  = liasset_index 
gen totasset_p = totasset_index
gen netasset_p = netasset_index

replace liasset_p  = 0 if  liasset_index >= 1 
replace liasset_p  = 1 if  liasset_index < 1 
replace totasset_p = 0 if  totasset_index >= 1
replace totasset_p = 1 if  totasset_index < 1
replace netasset_p = 0 if  netasset_index >= 1
replace netasset_p = 1 if  netasset_index < 1

tab liasset_p 
tab totasset_p
tab netasset_p

* Calculate the income poverty (world bank standard, $1.9/day). 
* (PPP exchange rate of dollars and RMB is 6.196 in 2013)
/*NEED DATA: different poverty lines across years*/
gen income_index=f_income/(1.9*6.196*365*familysize)

gen income_p=income_index
replace income_p=0 if income_index>=1
replace income_p=1 if income_index<1

tab income_p


gen poverty = 1 if income_p ==1 & netasset_p ==1 
gen inc_p_asset_p = poverty
replace inc_p_asset_p = 0 if poverty ==.
drop poverty 

gen poverty = 1 if income_p ==1 & netasset_p ==0 
gen inc_p_asset_np = poverty
replace inc_p_asset_np = 0 if poverty ==.
drop poverty

gen poverty = 1 if income_p ==0 & netasset_p ==1
gen inc_np_asset_p = poverty
replace inc_np_asset_p = 0 if poverty ==.
drop poverty

gen poverty = 1 if income_p ==0 & netasset_p ==0
gen inc_np_asset_np = poverty
replace inc_np_asset_np = 0 if poverty ==.
drop poverty

tab inc_p_asset_p
tab inc_p_asset_np
tab inc_np_asset_p
tab inc_np_asset_np

save regression1, replace

xi: reg inc_p_asset_p f_income expense familysize house_ownership house_price asset_cash_deposit //
asset_financial debt_tot old depen children ethnicity age party gender edu_highest marriage health p_income employ i.state i.NIC_io, robust











