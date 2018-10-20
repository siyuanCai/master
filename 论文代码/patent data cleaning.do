drop if strmatch(地址, "*台湾*")
drop if strmatch(地址, "*香港*")
drop if strmatch(地址, "*澳门*")

gen year1 = substr(申请日,1,4)
destring year1,gen(year)
drop 

split 申请人,p(;)
forvalues i=2(1)10{
replace 申请人`i' = "" if length(申请人`i')<=9 |strmatch(申请人`i', "*·*")==1
} 
drop if 申请人2 ==""&申请人3==""&申请人4==""
gen city1 = ""
replace city1 = substr(地址,strpos(地址,"省")+3,strpos(地址,"市")-strpos(地址,"省")) if strmatch(地址, "*省*")==1
replace city1 = substr(地址,strpos(地址,"自治区")+9,strpos(地址,"市")-strpos(地址,"自治区")-6) if strmatch(地址, "*自治区*")==1
replace city1 = substr(地址,strpos(地址,"自治州")+9,strpos(地址,"市")-strpos(地址,"自治州")-6) if strmatch(地址, "*自治州*")==1
replace city1 = substr(地址,strpos(地址,"盟")+3,strpos(地址,"市")-strpos(地址,"盟")) if strmatch(地址, "*盟*")==1
replace city1 = substr(地址,strpos(地址,"市")-6,9) if city1==""

drop if length(city1)<8


forvalues i =1(1)10{
gen app`i'=1 if 申请人`i'!="" & 申请人`i'!="null"
replace app`i'=0 if app`i'==.
}
egen num_app = rowtotal(app1-app9)
drop app1-app9


forvalues i =2(1)9{
gen city`i' = substr(申请人`i',strpos(申请人`i',"(")+1,strpos(申请人`i',")")-strpos(申请人`i',"(")-1) +"市" if strmatch(申请人`i', "*(*")==1 &申请人`i'!=""
replace city`i' ="" if city`i' =="集团市"
replace city`i' ="" if city`i' =="有限公司市"
replace city`i' ="" if city`i' =="中国市"
replace city`i' ="鄂尔多斯市" if city`i' =="多斯市"
replace city`i'  = substr(申请人`i',strpos(申请人`i',"市")-6,9) if city`i'==""&  strmatch(申请人`i', "*市*")==1 
replace city`i'  = substr(申请人`i',1,6)+"市" if city`i'=="" & 申请人`i'!=""
replace city`i'="马鞍山市" if city`i'=="马鞍市"
replace city`i'="" if city`i'!=city1 &strmatch(申请人`i', "*市*")!=1 & strmatch(申请人`i', "*(*")!=1
}
drop if city1==city2 & num_app==2
drop if city1==city2 & city2==city3 & num_app==3
drop if city1==city2 & city2==city3 & city4==city3 &num_app==4
save "E:\数据库\创新\3-83.dta
forvalues i =1(1)9{
gen app`i'=1 if city`i'!=""
replace app`i'=0 if app`i'==.
}
egen num_city = rowtotal(app1-app9)
drop app1-app9
drop if num_city==num_app
save  E:\数据库\创新\middle.dta,replace

drop 申请人6-申请人10
forvalues i= 2(1)5{
rename 申请人`i'  dict
sort dict
merge dict using E:\数据库\创新\city-dict.dta
drop _merge 
rename city city`i'`i'
replace city`i' = city`i'`i' if city`i'==""
drop city`i'`i'
rename dict  申请人`i' 
}
drop if year==.
drop if city1==city2 & num_app==2
drop if city1==city2 & city2==city3 & num_app==3
drop if city1==city2 & city2==city3 & city4==city3 &num_app==4


forvalues i=2(1)5{
replace city`i'="" if city`i'=="null"
}
forvalues i = 1(1)5{
local z = `i'+1
	forvalues j=`z'(1)5{
	gen pair`i'`j' = city`i'+"-"+city`j'
	}
}

foreach j in 12 13 14 15 23 24 25 34 35 45{
replace pair`j' = "" if length( pair`j')<17
}

reshape long pair,i(文献号) j(citypair)
bys year pair :egen collo_num = count(year)
