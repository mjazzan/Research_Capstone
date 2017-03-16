cd "D:\long term care\CHARLS\stata\data\household_and_community_questionnaire_data" 
unicode analyze psu.dta
unicode encoding set "GB18030" 
unicode retranslate psu.dta, transutf8

unicode analyze *
unicode encoding set "GB18030"
unicode retranslate *, transutf8