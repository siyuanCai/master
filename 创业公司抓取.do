clear
set more off
cap mkdir E:\数据库\创新\创业公司
cd E:\数据库\创新\创业公司
*创业邦*
local t = 1
set obs 1
qui gen v1=""
qui gen id = ""
qui gen name=""
qui gen starttime =""
qui gen year =""
qui gen city=""
qui gen field = ""
qui gen stage= ""
qui gen address=""
qui gen capital=""
forvalues i = 471560(1)471580{
capture copy "https://www.cyzone.cn/company/`i'.html" "temp.txt",replace
*** cap 防止报错***
	if _rc == 0{
					qui set obs `t' // 不停的增加 obs
					qui replace v1 = fileread("temp.txt") in `t'	
					qui replace id = "`i'" in `t'
					local ++t 
				} // if 结束
	while _rc != 0{
	
	    sleep 10000 // 休息一下，不要被知网发现了
		cap copy "https://www.cyzone.cn/company/`i'.html" "temp.txt",replace
	}		
	if _rc == 601{
	continue
	}
qui replace v1 = ustrregexra(v1,"\r\n","")  // 将换行符和回车键去掉
qui replace v1 = ustrregexra(v1,"\s","") // 将空格替换掉
qui replace name = ustrregexs(1) if ustrregexm(v1,`"<title>(.+)-创业公司"')
qui replace starttime = ustrregexs(1) if ustrregexm(v1,`"<p><spanclass="name">成立日期:</span>(.+)</p><p><spanclass="name">注册资本:"')
qui replace year = substr(starttime,1,4)
qui replace address = ustrregexs(1) if ustrregexm(v1,`"住所:</span>(.+)</p></div>"')
qui replace city = substr(address,1,strpos(address,"市")+2)
qui replace city = substr(address,strpos(address,"省")+3,strpos(address,"市")-strpos(address,"省")) if strmatch(address, "*省*")==1
qui replace stage = ustrregexs(1) if ustrregexm(v1,`"<iclass="i3"></i><span>(.+)</span></li><li><iclass="i6">"')
qui replace field = ustrregexs(1) if ustrregexm(v1,`"<li><iclass="i6"></i><span><ahref="(.+)</a></span></li></ul>"')
qui replace field = substr(field,strpos(field,">")+1,.)
qui replace capital = ustrregexs(1) if ustrregexm(v1,`"</p><p><spanclass="name">注册资本:</span>(.+)</p><p><spanclass="name">住所:"')
}










*清科创投*
clear
set more off
cap mkdir E:\数据库\创新\创业公司
cd E:\数据库\创新\创业公司
local t = 1
set obs 1
qui gen v1=""
qui gen id = ""
qui gen year =""
qui gen city=""
qui gen field = ""
qui gen stage= ""
qui gen title=""

forvalues j=601(1)660{
	local z1 = `j'*100+1
	local z2 = `j'*100+100
	forvalues i = `z1'(1)`z2'{
		capture copy "https://zdb.pedaily.cn/enterprise/show`i'/" "temp.txt",replace
		*** cap 防止报错***
		if _rc == 0{
					qui set obs `t' // 不停的增加 obs
					qui replace v1 = fileread("temp.txt") in `t'	
					qui replace id = "`i'" in `t'
					local ++t 
				} // if 结束
		
		if _rc == 601{
		continue
		}
		while _rc != 0&_rc != 601 {
	
	    sleep 10000 // 休息一下，不要被知网发现了
		cap copy "https://zdb.pedaily.cn/enterprise/show`i'/" "temp.txt",replace
		}	
	qui replace v1 = ustrregexra(v1,"\r\n","")  // 将换行符和回车键去掉
	qui replace v1 = ustrregexra(v1,"\s","") // 将空格替换掉
	qui replace title = ustrregexs(1) if ustrregexm(v1,`"<title>(.+)_投资界</title>"')
	qui replace year = ustrregexs(1) if ustrregexm(v1,`"成立时间：</span>(.+)年</li><li><span>"')
	qui replace city = ustrregexs(1) if ustrregexm(v1,`"注册地点：</span>(.+)</li><li><span>成"')
	qui replace stage = ustrregexs(1) if ustrregexm(v1,`"<spanclass="r">(.+)</span><spanclass="d">"')
	qui replace field = ustrregexs(1) if ustrregexm(v1,`"所属行业：</span>(.+)</li><liclass="link">"')
	}
drop v1
save  E:\数据库\创新\创业公司\\`j'.dta
clear
local t = 1
set obs 1
qui gen v1=""
qui gen id = ""
qui gen year =""
qui gen city=""
qui gen field = ""
qui gen stage= ""
qui gen title=""
}

local url = `"https://zdb.pedaily.cn/enterprise/show19229/"'
copy "`url'" temp.txt,replace
qui set obs 1
gen v1 = fileread("temp.txt")
replace v1 = ustrregexra(v1,"\r\n","")  // 将换行符和回车键去掉
replace v1 = ustrregexra(v1,"\s","") // 将空格替换掉

gen title = ustrregexs(1) if ustrregexm(v1,`"<title>(.+)_投资界</title>"')
gen starttime = ustrregexs(1) if ustrregexm(v1,`"成立时间：</span>(.+)年</li><li><span>"')
replace starttime = substr(starttime,1,6)
replace stage = ustrregexs(1) if ustrregexm(v1,`"<spanclass="r">(.+)</span><spanclass="d">"')
replace city = ustrregexs(1) if ustrregexm(v1,`"注册地点：</span>(.+)</li><li><span>成"')
replace field= ustrregexs(1) if ustrregexm(v1,`"所属行业：</span>(.+)</li><liclass="link">"')
