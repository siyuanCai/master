
clear all
set more off
cap mkdir "C:\Users\Lenovo\Desktop\CNKI"
cd "C:\Users\Lenovo\Desktop\CNKI"



/*
** http://navi.cnki.net/KNavi/JournalDetail?pcode=CJFD&pykm=JJYJ

***********
*** 找规律
***********
**马克思主义绿色发展观与当代中国的绿色发展——兼评环境与发展不相容论

http://kns.cnki.net/kcms/detail/detail.aspx?dbcode=CJFD&
filename=JJYJ201706003&dbname=CJFDTEMP&uid=WEEvREcwSlJHSldRa1FhdXNXYXJxTDB4Z2JNZU0zL1Rpc3dKOUVIcm5KQT0=
$9A4hF_YAuvQ5obgVAqNKPCYcEjKensW4ggI8Fm4gTkoUKaID8j8gFw!!


**金融杠杆、杠杆波动与经济增长

http://kns.cnki.net/kcms/detail/detail.aspx?dbcode=CJFD&
filename=JJYJ201706004&dbname=CJFDTEMP&uid=WEEvREcwSlJHSldRa1FhdXNXYXJxTDB4Z2JNZU0zL1Rpc3dKOUVIcm5KQT0=
$9A4hF_YAuvQ5obgVAqNKPCYcEjKensW4ggI8Fm4gTkoUKaID8j8gFw!!

url 的参数： filename=期刊拼音+年份+月份+第几篇 ,其余参数一样。

**** 又发现 dbname 是不一样的，
http://kns.cnki.net/kcms/detail/detail.aspx?dbcode=CJFD&
filename=JJYJ200812005&dbname=CJFD2008&uid=WEEvREcwSlJHSldRa1FhcTdWZDluTlhlRUo5Q0dRUnZNMUJKeDcrOGZWVT0=
$9A4hF_YAuvQ5obgVAqNKPCYcEjKensW4ggI8Fm4gTkoUKaID8j8gFw!!

**金融杠杆、杠杆波动与经济增长

http://kns.cnki.net/kcms/detail/detail.aspx?dbcode=CJFD&
filename=JJYJ201706004&dbname=CJFDTEMP&uid=WEEvREcwSlJHSldRa1FhdXNXYXJxTDB4Z2JNZU0zL1Rpc3dKOUVIcm5KQT0=
$9A4hF_YAuvQ5obgVAqNKPCYcEjKensW4ggI8Fm4gTkoUKaID8j8gFw!!


===>可替换成下面的url (dbname=CJFD2017)

http://kns.cnki.net/kcms/detail/detail.aspx?dbcode=CJFD&
filename=JJYJ201706004&dbname=CJFD2017&uid=WEEvREcwSlJHSldRa1FhdXNXYXJxTDB4Z2JNZU0zL1Rpc3dKOUVIcm5KQT0=
$9A4hF_YAuvQ5obgVAqNKPCYcEjKensW4ggI8Fm4gTkoUKaID8j8gFw!!

url 参数：dbname=CJFD+ 年份


*/

*******************
*** one try 
*******************

*黄少安,韦倩. 机构投资者投资基金的“适度组合规模”:基于中国数据的实证分析[J]. 经济研究,2007,(12):118-129. 
*网址：http://kns.cnki.net/kcms/detail/detail.aspx?dbcode=CJFD&filename=KJYJ200712012&dbname=CJFD2007&uid=WEEvREcwSlJHSldRa1FhdXNXYXJxTDB4Z2JNZU0zL1Rpc3dKOUVIcm5KQT0=$9A4hF_YAuvQ5obgVAqNKPCYcEjKensW4ggI8Fm4gTkoUKaID8j8gFw!!

local url = `"http://kns.cnki.net/KCMS/detail/detail.aspx?dbcode=CJFQ&dbname=CJFDLAST2018&filename=ZNJJ201711001&v=MDQ4MDBQeVBCWkxHNEg5Yk5ybzlGWllSOGVYMUx1eFlTN0RoMVQzcVRyV00xRnJDVVJMS2ZZK2RxRnkzbVc3M0k="'
copy "`url'" temp.txt,replace
qui set obs 1
gen v1 = fileread("temp.txt")
replace v1 = ustrregexra(v1,"\r\n","")  // 将换行符和回车键去掉
replace v1 = ustrregexra(v1,"\s","") // 将空格替换掉
*<title>机构投资者投资基金的“适度组合规模”:基于中国数据的实证分析-中国知网
gen title= ustrregexs(1) if ustrregexm(v1,`"<title>(.+)-中国知网"')
*下载：</label><b>1804</b></span><span 
gen download = ustrregexs(1) if ustrregexm(v1,`"下载：</label><b>([0-9]+)</b>"')
gen au =  ustrregexs(1) if ustrregexm(v1,`"TurnPageToKnet\('au',(.+)</a></span></div><divclass="orgn">"')
gen inst =  ustrregexs(1) if ustrregexm(v1,`"TurnPageToKnet\('in','(.+)</a></span></div><divclass="link">"')
gen fund =  ustrregexs(1) if ustrregexm(v1,`"TurnPageToKnet\('fu','(.+)</a></p><p><labelid="catalog_KEYWORD"')
gen type = ustrregexs(1) if ustrregexm(v1,`">分类号：</label>(.+)</p><p><labelid="catalog_divimg"')

*** 通过检查，点击引证文献
*** http://kns.cnki.net/kcms/detail/frame/list.aspx?dbcode=CJFD&filename=jjyj200712012&dbname=CJFD2007&RefType=3&vl=

*** http://kns.cnki.net/kcms/detail/frame/list.aspx?dbcode=CJFQ&filename=jjyj200101001&dbname=CJFD2001&RefType=3&vl=
local url = "http://kns.cnki.net/kcms/detail/frame/list.aspx?dbcode=CJFQ&filename=KJYj201708008&dbname=CJFDLAST2018&RefType=3&vl="
copy "`url'" temp.txt,replace
qui gen v2 = fileread("temp.txt") 
qui gen cit1= ustrregexs(1) if ustrregexm(v2,`"id="pc_CJFQ">([0-9]+)</span>条"')
qui gen cit2= ustrregexs(1) if ustrregexm(v2,`"id="pc_CDFD">([0-9]+)</span>条"')
qui gen cit3= ustrregexs(1) if ustrregexm(v2,`"id="pc_CMFD">([0-9]+)</span>条"')

** 	中小金融机构发展与中小企业融资	林毅夫; 李永军	经济研究	2001/01	
** http://kns.cnki.net/kns/detail/detail.aspx?QueryID=1&CurRec=2&DbCode=CJFQ&dbname=CJFD2001&filename=JJYJ200101001&urlid=&yx=
qui gen cit4 =  ustrregexs(1) if ustrregexm(v2,`"id="pc_CPFD">([0-9]+)</span>条"')
qui gen cit5 =  ustrregexs(1) if ustrregexm(v2,`"id="pc_IPFD">([0-9]+)</span>条"')


****************************
*** 循环抓取
****************************

foreach journal in CJYJ{

clear
global datapath = "C:\Users\Lenovo\Desktop\CNKI\CNKI_`journal'"
cap mkdir $datapath
cd $datapath

local t = 1
set obs 1
qui gen journal = ""
qui gen v1 =""
qui gen year =""
qui gen month = ""
qui gen article= ""
forvalues year = 2000(1)2017{
	foreach month in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 s1 s2 s3 {
		forvalues i = 0(1)40{
		
			if `i' < 10{
				local i = "00" + "`i'"
			}
			else{
				local i = "0" + "`i'"
			}
			capture copy "http://kns.cnki.net/kcms/detail/detail.aspx?dbcode=CJFD&filename=`journal'`year'`month'`i'&dbname=CJFDLAST`year'&uid=WEEvREcwSlJHSldRa1Fhb09jMjQxdjhUcytyMHNhQXNacE5pNGYxcnRqUT0=$9A4hF_YAuvQ5obgVAqNKPCYcEjKensW4ggI8Fm4gTkoUKaID8j8gFw!!" "1.txt",replace
			*** cap 防止报错
			if _rc == 0{
					** 如果成功抓取，则运行以下命令			
					*dis in yellow "`year'年`month'月`i'篇"
					qui set obs `t' // 不停的增加 obs
					qui replace v1 = fileread("1.txt") in `t'	
					qui replace journal = "`journal'"  in `t'
					qui replace year = "`year'" in `t'
					qui replace month = "`month'" in `t'
					qui replace article = "`i'" in `t'
					local ++t 
				} // if 结束
		} // i (第几篇的循环结束)
	}	// month (月份循环结束)				
} // year (年份循环结束)

replace v1 = ustrregexra(v1,"\r\n","") 
replace v1 = ustrregexra(v1,"\s","")
gen title= ustrregexs(1) if ustrregexm(v1,`"<title>(.+)-中国知网"') 
gen download = ustrregexs(1) if ustrregexm(v1,`"下载：</label><b>([0-9]+)</b>"')
gen au =  ustrregexs(1) if ustrregexm(v1,`"TurnPageToKnet\('au',(.+)</a></span></div><divclass="orgn">"')
gen inst =  ustrregexs(1) if ustrregexm(v1,`"TurnPageToKnet\('in','(.+)</a></span></div><divclass="link">"')
gen fund =  ustrregexs(1) if ustrregexm(v1,`"TurnPageToKnet\('fu','(.+)</a></p><p><labelid="catalog_KEYWORD"')
gen type = ustrregexs(1) if ustrregexm(v1,`">分类号：</label>(.+)</p><p><labelid="catalog_divimg"')
**** 抓取了一个期刊（JJYJ）2000-2017的所有文章信息
**** 下面开始逐篇抓取引用信息
gen v2 =""
local N = _N
forvalues j = 1(1)`N'{

	local year = year[`j']
	local month = month[`j']
	local i = article[`j']
	cap copy "http://kns.cnki.net/kcms/detail/frame/list.aspx?dbcode=CJFD&filename=`journal'`year'`month'`i'&dbname=CJFDLAST`year'&RefType=3&vl=" 2.txt,replace
	while _rc ~= 0{
	
	    sleep 10000 // 休息一下，不要被知网发现了
		cap copy "http://kns.cnki.net/kcms/detail/frame/list.aspx?dbcode=CJFD&filename=`journal'`year'`month'`i'&dbname=CJFDLAST`year'&RefType=3&vl=" 2.txt,replace
	}
	
	qui replace v2 = fileread("2.txt") in `j'

}
	qui gen cit1= ustrregexs(1) if ustrregexm(v2,`"id="pc_CJFQ">([0-9]+)</span>条"')
	qui gen cit2= ustrregexs(1) if ustrregexm(v2,`"id="pc_CDFD">([0-9]+)</span>条"')
	qui gen cit3= ustrregexs(1) if ustrregexm(v2,`"id="pc_CMFD">([0-9]+)</span>条"')
	qui gen cit4 =  ustrregexs(1) if ustrregexm(v2,`"id="pc_CPFD">([0-9]+)</span>条"')
	qui gen cit5 =  ustrregexs(1) if ustrregexm(v2,`"id="pc_IPFD">([0-9]+)</span>条"')
	qui drop v1 v2
	
*** 成功抓取了一本杂志所有文章的基本信息和引用数据
	save `journal',replace			

}			
