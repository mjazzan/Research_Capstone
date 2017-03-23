cd "/Users/elmerleezy/Google Drive/Wagner/Semester 4/Capstone/Capstone 2016-2017/Data/Raw - CFPS/2010"
unicode analyze cfps2010family_report_nat072016.dta
unicode encoding set "GB18030" 
unicode retranslate cfps2010family_report_nat072016.dta, transutf8

unicode analyze *
unicode encoding set "GB18030"
unicode retranslate *, transutf8