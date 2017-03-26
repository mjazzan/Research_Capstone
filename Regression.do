clear all
prog drop _all
capture log close
set more off

use family_head_all_restrict1, clear

** Different categores of asset
gen liasset= rowtotal(asset_cash_deposit asset_financial)
gen totasset =   rowtotal(asset_cash_deposit asset_financial house_price)
gen netasset =   rowtotal(asset_cash_deposit asset_financial house_price -debt_tot)

* Calculate the asset poverty rate 
gen liasset_index =liasset/(1.9*6.196*91.25*familysize)
gen totasset_index =totasset/(1.9*6.196*91.25*familysize)
gen netasset_index =netasset/(1.9*6.196*91.25*familysize)

gen liasset_p  = liasset_index 
gen totasset_p = totasset_index
gen netasset_p = netasset_index

replace asset_p1=0 if asset_index>=1
replace asset_p1=1 if asset_index<1

gen liasset_p  = 0 if  liasset_index >= 1 
gen liasset_p  = 1 if  liasset_index < 1 
gen totasset_p = 0 if  totasset_index >= 1
gen totasset_p = 1 if  totasset_index < 1
gen netasset_p = 0 if  netasset_index >= 1
gen netasset_p = 1 if  netasset_index < 1

tab asset_p1

* Calculate the income poverty (world bank standard, $1.9/day). PPP exchange rate of dollars and RMB is 6.196 in 2013
gen income_index=f01_1/(1.9*6.196*91.25*familysize)

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

xi: reg lnYearly_gva allmanufacturing manu_post post labor_reg labpost i.state i.NIC_io, robust
