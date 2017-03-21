* Create dummy for Beijing 
gen Beijing=coun
replace Beijing=1 if coun<=110229
replace Beijing=0 if coun>110229

* Create dummy for Shanxi 
gen Shanxi=coun
replace Shanxi=1 if coun>=140106 & coun<=141127
replace Shanxi=0 if coun<140106 | coun>141127

* Create dummy for Liaoning 
gen Liaoning=coun
replace Liaoning=1 if coun>=210106 & coun<=211421
replace Liaoning=0 if coun<210106 | coun>211421


* Create dummy for Jiangsu 
gen Jiangsu=coun
replace Jiangsu=1 if coun>=320205 & coun<=321284
replace Jiangsu=0 if coun<320205 | coun>321284


* Create dummy for Anhui 
gen Anhui=coun
replace Anhui=1 if coun>=340103 & coun<=341723
replace Anhui=0 if coun<340103 | coun>341723


* Create dummy for Shandong 
gen Shandong=coun
replace Shandong=1 if coun>=370105 & coun<=371626
replace Shandong=0 if coun<370105 | coun>371626


* Create dummy for Henan 
gen Henan=coun
replace Henan=1 if coun>=410105 & coun<=419001
replace Henan=0 if coun<410105 | coun>419001


* Create dummy for Hubei 
gen Hubei=coun
replace Hubei=1 if coun>=420111 & coun<=429006
replace Hubei=0 if coun<420111 | coun>429006


* Create dummy for Hunan 
gen Hunan=coun
replace Hunan=1 if coun>=430111 & coun<=431382
replace Hunan=0 if coun<430111 | coun>431382


* Create dummy for Guangdong
gen Guangdong=coun
replace Guangdong=1 if coun>=440111 & coun<=445381
replace Guangdong=0 if coun<440111 | coun>445381


* Create dummy for Chongqing 
gen Chongqing=coun
replace Chongqing=1 if coun>=500102 & coun<=500234
replace Chongqing=0 if coun<500102 | coun>500234


* Create dummy for Sichuan 
gen Sichuan=coun
replace Sichuan=1 if coun>=510121 & coun<=512021
replace Sichuan=0 if coun<510121 | coun>512021


* Create dummy for Yunnan 
gen Yunnan=coun
replace Yunnan=1 if coun>=530103 & coun<=533103
replace Yunnan=0 if coun<530103 | coun>533103

* Create dummy for Gansu 
gen Gansu=coun
replace Gansu=1 if coun>=620102
replace Gansu=0 if coun<620102

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

