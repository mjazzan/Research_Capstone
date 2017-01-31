clear all
prog drop _all
capture log close
set more off

 * Type your directory here: 
cd "/Users/elmerleezy/Google Drive/Wagner/第三学期/Capstone/Data/Raw"

******************************************
** Graphing **
******************************************

** Create single variable for poverty status 
use all_variable, clear 

gen poverty_st =""
replace poverty_st = "inc_p_asset_p" if inc_p_asset_p ==1
replace poverty_st = "inc_p_asset_np" if inc_p_asset_np ==1
replace poverty_st = "inc_np_asset_p" if inc_np_asset_p ==1
replace poverty_st = "inc_np_asset_np" if inc_np_asset_np ==1

******************************************
** Export **
******************************************

export excel using "/Users/elmerleezy/Google Drive/Wagner/第三学期/Capstone/Capstone 2016-2017/Data/Graphing/all_variable.csv", firstrow(varlabels) replace
