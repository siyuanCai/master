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
qui gen stage= ""
qui gen title=""
qui gen capital_type=""
qui gen enterprise_type=""
qui gen address=""
qui gen address1=""
forvalues j=16(1)200{
	local z1 = `j'*100+1
	local z2 = `j'*100+100
	forvalues i = `z1'(1)`z2'{
		capture copy "https://zdb.pedaily.cn/company/show`i'/" "temp.txt",replace
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
		cap copy "https://zdb.pedaily.cn/company/show`i'/" "temp.txt",replace
		}	
	qui replace v1 = ustrregexra(v1,"\r\n","")  // 将换行符和回车键去掉
	qui replace v1 = ustrregexra(v1,"\s","") // 将空格替换掉
	qui replace title = ustrregexs(1) if ustrregexm(v1,`"<title>(.+)_投资界</title>"')
	qui replace year = ustrregexs(1) if ustrregexm(v1,`"成立时间：</span>(.+)年</li><li><span>"')
	qui replace address = ustrregexs(1) if ustrregexm(v1,`"地址：</span>(.+)<br/></p><p><span>邮"')|ustrregexm(v1,`"地址：</span>(.+)<br/></p></div><!--管"')
	qui replace stage = ustrregexs(1) if ustrregexm(v1,`"投资阶段：</span>(.+)</li></ul></div></div><divclass="box-fix-r">"')
	qui replace capital_type = ustrregexs(1) if ustrregexm(v1,`"资本类型：</span>(.+)</li><li><span>机构性"')
	qui replace enterprise_type = ustrregexs(1) if ustrregexm(v1,`"质：</span>(.+)</li><li><span>注册地点"')
	qui replace city = substr(address,1,strpos(address,"市")+2)
	qui replace city = substr(address,strpos(address,"省")+3,strpos(address,"市")-strpos(address,"省")) if strmatch(address, "*省*")==1
	
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
qui gen stage= ""
qui gen title=""
qui gen capital_type=""
qui gen enterprise_type=""
qui gen address=""
}
local url = `"https://zdb.pedaily.cn/company/show5949/"'
copy "`url'" temp.txt,replace
qui set obs 1
replace v1 = fileread("temp.txt")
replace v1 = ustrregexra(v1,"\r\n","")  // 将换行符和回车键去掉
replace v1 = ustrregexra(v1,"\s","") // 将空格替换掉
