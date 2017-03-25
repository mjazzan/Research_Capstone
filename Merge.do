clear all
prog drop _all
capture log close
set more off

cd "/Users/elmerleezy/Google Drive/Wagner/Semester 4/Capstone/Capstone 2016-2017/Data/Raw - CFPS"

use family_head_2010, clear
gen year = 2010
save, replace

use family_head_2012, clear
drop edu_highest
rename edu_latest edu_highest
gen year = 2012
save, replace

use family_head_2014, clear
drop edu_highest
rename edu_latest edu_highest
gen year = 2014
sort fid12
save,replace

append using family_head_2012
append using family_head_2010
sort fid10
save family_head_all,replace

use family_head_all, clear 
bysort fid10: gen num_obs=_n
table num_obs
* drop num_obs
replace fid10 = fid12 if fid10==.


*** Check Variables 

* Debt - test restriction
sum debt_tot if year == 2010 & f_income < 2000000 & debt_tot < 2000000
sum debt_tot if year == 2012 & f_income < 2000000 & debt_tot < 2000000
sum debt_tot if year == 2014 & f_income < 2000000 & debt_tot < 2000000

graph twoway (scatter debt_tot f_income, ms(o) mc(gs4) msize(small))

* Children
table children if year == 2010
table children if year == 2012
table children if year == 2014
	/* in year 2010 there are only 6k in the children dataset and are all merged. Children is constant*/

* asset_financial houseprice

sum asset_financial if year == 2010 & f_income < 2000000 & asset_financial < 5000000
sum asset_financial if year == 2012 & f_income < 2000000 & asset_financial < 5000000
sum asset_financial if year == 2014 & f_income < 2000000 & asset_financial < 5000000


graph twoway (scatter asset_financial f_income, ms(o) mc(gs4) msize(small))
	/* asset in 2010 is much bigger; back and redefine*/




















