*清科创投*
clear
set more off
cap mkdir E:\数据库\创新\创业公司
cd E:\数据库\创新\创业公司
local t = 1
set obs 1
qui gen v1=""
qui gen id = ""
qui gen time =""
qui gen company_rz=""
qui gen stage= ""
qui gen company_tz=""
qui gen enterprise_type=""
qui gen amount=""
qui gen field=""
forvalues j=0(1)196{
	local z1 = `j'*100+1
	local z2 = `j'*100+100
	forvalues i = `z1'(1)`z2'{
		capture copy "https://zdb.pedaily.cn/inv/show`i'/" "temp.txt",replace
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
	
	    sleep 10000 // 休息一下，不要被发现了
		cap copy "https://zdb.pedaily.cn/inv/show`i'/" "temp.txt",replace
		}	
	qui replace v1 = ustrregexra(v1,"\r\n","")  // 将换行符和回车键去掉
	qui replace v1 = ustrregexra(v1,"\s","") // 将空格替换掉
	qui replace company_rz = ustrregexs(1) if ustrregexm(v1,`"融&nbsp;&nbsp;资&nbsp;&nbsp;方：(.+)</a></li><liclass="full"><span>投"')
	
	qui replace time = ustrregexs(1) if ustrregexm(v1,`"融资时间：</span>(.+)</li><li><span>所"')
	qui replace company_tz = ustrregexs(1) if ustrregexm(v1,`"投&nbsp;&nbsp;资&nbsp;&nbsp;方：(.+)</a></li><li><span>金"')
	qui replace stage = ustrregexs(1) if ustrregexm(v1,`"轮次：</span><spanclass="bround">(.+)</li><li><span>融"')
	
	qui replace amount = ustrregexs(1) if ustrregexm(v1,`"金额：</span>(.+)</li><li><span>轮"')
	qui replace field = ustrregexs(1) if ustrregexm(v1,`"所属行业：</span>(.+)</a>&gt;"')
	}
drop v1
save  E:\数据库\创新\创业公司\\`j'.dta,replace
clear
local t = 1
set obs 1
qui gen v1=""
qui gen id = ""
qui gen time =""
qui gen company_rz=""
qui gen stage= ""
qui gen company_tz=""
qui gen enterprise_type=""
qui gen amount=""
qui gen field=""
}


local url = `"https://zdb.pedaily.cn/inv/show19577/"'
copy "`url'" temp.txt,replace
qui set obs 1
replace v1 = fileread("temp.txt")
replace v1 = ustrregexra(v1,"\r\n","")  // 将换行符和回车键去掉
replace v1 = ustrregexra(v1,"\s","") // 将空格替换掉
qui replace stage = ustrregexra(stage,"</span>","")
qui gen company_rz1 = ustrregexs(1) if ustrregexm(company_rz,`">(.+)"')
