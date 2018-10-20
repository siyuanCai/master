replace au=subinstr(au,"TurnPageToKnet","",.)
replace au=subinstr(au,"au","",.)
replace au=subinstr(au,"&#xA;","",.)
replace au=subinstr(au,"</a></span><span><aonclick=","",.)
replace au=subinstr(au,"0","",.)
replace au=subinstr(au,"1","",.)
replace au=subinstr(au,"2","",.)
replace au=subinstr(au,"3","",.)
replace au=subinstr(au,"4","",.)
replace au=subinstr(au,"5","",.)
replace au=subinstr(au,"6","",.)
replace au=subinstr(au,"7","",.)
replace au=subinstr(au,"8","",.)
replace au=subinstr(au,"9","",.)
replace au=subinstr(au,"!","",.)
replace au=subinstr(au,";","",.)
replace au=subinstr(au,"',''","",.)
replace au=subinstr(au,")","",.)
replace au=subinstr(au,"'","",.)
replace au=subinstr(au,"(","",.)
replace au=subinstr(au,">","",.)
replace au=subinstr(au,",","",.)
split au,p(*)
drop au2   au4   au6   au8   au10      


replace inst=subinstr(inst,"TurnPageToKnet","",.)
replace inst=subinstr(inst,"&#xA;","",.)
replace inst=subinstr(inst,"</a></span><span><aonclick=","",.)
replace inst=subinstr(inst,"0","",.)
replace inst=subinstr(inst,"1","",.)
replace inst=subinstr(inst,"2","",.)
replace inst=subinstr(inst,"3","",.)
replace inst=subinstr(inst,"4","",.)
replace inst=subinstr(inst,"5","",.)
replace inst=subinstr(inst,"6","",.)
replace inst=subinstr(inst,"7","",.)
replace inst=subinstr(inst,"8","",.)
replace inst=subinstr(inst,"9","",.)
replace inst=subinstr(inst,"!","",.)
replace inst=subinstr(inst,";","",.)
replace inst=subinstr(inst,"',''","",.)
replace inst=subinstr(inst,")","",.)
replace inst=subinstr(inst,">","",.)
replace inst=subinstr(inst,"in',","",.)
replace inst=subinstr(inst,"(","",.)
replace inst=subinstr(inst,"'","",.)
replace inst=subinstr(inst,"邮政编码","",.)
replace inst=subinstr(inst,"。","",.)
replace inst=subinstr(inst,":","",.)
replace inst=subinstr(inst,"in,","",.)
replace inst=subinstr(inst,"&quot","",.)
replace inst=subinstr(inst,"&quot","",.)
replace inst=subinstr(inst,"行长","",.)
replace inst=subinstr(inst,"董事长","",.)
replace inst=subinstr(inst,"副院长","",.)
replace inst=subinstr(inst,"院长","",.)
replace inst=subinstr(inst,"副教授","",.)
replace inst=subinstr(inst,"教授","",.)
replace inst=subinstr(inst,"讲师","",.)
replace inst=subinstr(inst,"研究员","",.)
replace inst=subinstr(inst,"博士后","",.)
replace inst=subinstr(inst,"博士","",.)
replace inst=subinstr(inst,"硕士","",.)
replace inst=subinstr(inst,"研究生","",.)
replace inst=subinstr(inst,"讲座","",.)
replace inst=subinstr(inst,"委员","",.)
replace inst=subinstr(inst,"&amp","",.)
replace inst=subinstr(inst,"作者单位","",.)
split inst,p(*)
drop inst2   inst4   inst6   inst8    inst10

*删除0引用的样本*
destring cit1,gen(cite1)
destring cit2,gen(cite2)
destring cit3,gen(cite3)
destring cit4,gen(cite4)
destring cit5,gen(cite5)
replace cite1=0 if cite1 ==.
replace cite2=0 if cite2 ==.
replace cite3=0 if cite3 ==.
replace cite4=0 if cite4 ==.
replace cite5=0 if cite5 ==.
gen citation = cite1+cite2+cite3+cite4+cite5
drop cit1 cit2 cit3 cit4 cit5
drop if citation==0
*删除课题组的论文*
drop if strmatch(title, "*课题组*")

*删除约稿、研讨会综述等*
drop if strmatch(title, "*研讨会*")
drop if strmatch(title, "*会议*")
drop if strmatch(title, "*笔谈*")
drop if strmatch(title, "*年会*")
drop if strmatch(title, "*论坛*")
drop if strmatch(title, "*笔会*")
drop if strmatch(title, "*座谈*")
drop if strmatch(title, "*对话*")
drop if strmatch(title, "*演讲*")
drop if strmatch(title, "*讲座*")
*堆叠成面板数据*
gen paperid = _n
rename au aut
reshape long au,i(paperid) j(author)
drop if au ==""

*生成作者数量*
bysort paperid: gen num_author = _N
drop if num_author==1

*改变变量格式*
encode year ,gen(year1) 
drop year
rename year1 year

replace inst3=inst1 if inst3==""
replace inst5=inst1 if inst5=="" & num_author==3 & inst3==inst1
replace inst7=inst1 if inst7=="" & num_author==4 & inst3==inst1 &inst5==""
replace inst5=inst1 if num_author==4 & inst3==inst1 &inst5=="" &inst7==inst1
*手动校对作者与机构是否匹配*

*堆叠回宽型，并删除独作*

reshape wide au,i(paperid) j(author)

*将各机构匹配到城市*
forvalues i=1(2)9{
	merge m:1 inst`i' using  C:\Users\Lenovo\Desktop\CNKI\inst-city-dict`i'.dta
	drop if paperid==.
	drop _merge
	sort paperid 
}
*生成城市-城市组合*
gen pair13 = ""
gen pair15 = ""
gen pair17 = ""
gen pair19 = ""
gen pair35 = ""
gen pair37 = ""
gen pair39 = ""
gen pair57 = ""
gen pair59 = ""
gen pair79 = ""

replace pair13 = city1+"-"+city3
replace pair15 = city1+"-"+city5 if num_author>2
replace pair17 = city1+"-"+city7 if num_author>3
replace pair19 = city1+"-"+city9 if num_author>4
replace pair35 = city3+"-"+city5 if num_author>2
replace pair37 = city3+"-"+city7 if num_author>3
replace pair39 = city3+"-"+city9 if num_author>4
replace pair57 = city5+"-"+city7 if num_author>3
replace pair59 = city5+"-"+city9 if num_author>4
replace pair79 = city7+"-"+city9 if num_author>4
 
save "C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\maindata.dta", replace
*分年计数并merge到maindata中*
forvalues i=1(1)18{
	drop if year != `i'
	local z = `i'-1
	save C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\maindatapart200`z'.dta,replace
	foreach j in 13 15 17 19 35 37 39 57 59 79{
		bys year pair`j':egen collo_num`j'=count(year)
		keep pair`j' collo_num`j' citation
		duplicates drop pair`j',force
		drop if pair==""
		rename pair`j' pair
		rename citation citation`j'
		save C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\maindata200`z'-`j'.dta,replace
		use C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\maindatapart200`z'.dta
	}
	use C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\maindata.dta
}
forvalues i=0(1)9{
	use C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\maindata200`i'.dta
	foreach j in 13 15 17 19 35 37 39 57 59 79{
		merge m:1 pair using C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\maindata200`i'-`j'.dta
		drop if year==.
		drop _merge
		replace collo_num`j' = 0 if collo_num`j'==.
		replace citation`j' = 0 if citation`j'==.
		save C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\maindata200`i'.dta,replace
}
	egen collo_total = rowtotal(collo_num13 collo_num15 collo_num17 collo_num19 collo_num35 collo_num37 collo_num39 collo_num57 collo_num59 collo_num79)
	egen cit_total = rowtotal(citation13 citation15 citation17 citation19 citation35 citation37 citation39 citation57 citation59 citation79)
	save C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\maindata200`i'.dta,replace
}

forvalues i=10(1)17{
	use C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\maindata20`i'.dta
	foreach j in 13 15 17 19 35 37 39 57 59 79{
		merge m:1 pair using C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\maindata200`i'-`j'.dta
		drop if year==.
		drop _merge
		replace collo_num`j' = 0 if collo_num`j'==.
		replace citation`j' = 0 if citation`j'==.
		save C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\maindata20`i'.dta,replace
}
	egen collo_total = rowtotal(collo_num13 collo_num15 collo_num17 collo_num19 collo_num35 collo_num37 collo_num39 collo_num57 collo_num59 collo_num79)
	egen cit_total = rowtotal(citation13 citation15 citation17 citation19 citation35 citation37 citation39 citation57 citation59 citation79)
	save C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\maindata20`i'.dta,replace
}
use C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\maindata2000.dta, clear
save C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\maindata1.dta,replace


foreach i in  01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17{
 append using C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\maindata20`i'.dta
 drop collo_num13-collo_num79 citation13
 save C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\maindata1,replace
}
replace city1="襄阳市" if city1=="襄樊市"
replace city2="襄阳市" if city2=="襄樊市"
drop pair 
gen pair = city1+"-"+city2
merge m:1 pair using C:\Users\Lenovo\Desktop\CNKI\pair-distance-dict.dta
drop if _merge==2
drop _merge
replace distance = 0 if city1==city2
gen ln_distance = ln(distance+1)
gen ln_distance2 = ln_distance*ln_distance
bysort city1 year:egen pub_city1 = sum(collo_total)
bysort city2 year:egen pub_city2 = sum(collo_total)

tab year,gen(dum_year)
save C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\maindata1,replace
save C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\cit_dict.dta,replace

*生成cit_dict*
keep city1 city2 year cit_total pair distance
bysort city1 year:egen cit_city1 = sum( cit_total )
bysort city2 year:egen cit_city2 = sum( cit_total )
drop if distance!=0
gen cit_city = cit_city1+cit_city2
tostring year,gen(year1)
gen dict = city1+year1
keep dict cit_city
save C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\cit_dict.dta,replace

*生成pub_dict*
use C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\maindata1.dta
save C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\pub_dict.dta,replace
keep city1 city2 year pub_city1 pub_city2 pair distance
drop if distance!=0
gen pub_city = pub_city1+pub_city2
tostring year,gen(year1)
gen dict = city1+year1
keep dict pub_city
save C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\pub_dict.dta,replace

*将A-B B-A合并*
use C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\maindata1.dta
bysort distance year:egen collo_total1 = sum(collo_total) if distance!= 0
bysort distance year:egen citation = sum(cit_total) if distance!= 0
replace collo_total1 = collo_total if distance== 0
replace citation = cit_total if distance== 0
tostring distance,gen(distance1) force
tostring year,gen(year1) 
gen dict = distance1+"-"+year1
duplicates drop dict if distance!=0 ,force
drop dict distance1 collo_total cit_total
rename collo_total1 collo_total

save C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\maindata1.dta, replace


*生成mass-pub*
gen dict= city1+year1
merge m:1 dict using C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\pub_dict.dta
drop _merge  dict pub_city1 pub_city2
gen dict=city2+year1
rename pub_city pub1_city
merge m:1 dict using C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\pub_dict.dta
rename pub_city pub2_city
drop  dict _merge
save C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\maindata1.dta, replace

*生成mass-cit*
gen dict = city1+year1
merge m:1 dict using C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\cit_dict.dta
drop _merge  dict 
gen dict=city2+year1
rename cit_city cit1_city
merge m:1 dict using C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\cit_dict.dta
rename cit_city cit2_city
drop  dict _merge
save C:\Users\Lenovo\Desktop\CNKI\CNKI_GJJR\maindata1.dta, replace


*生成city-pair-level*
forvalues i=1(1)2{
merge m:1 city`i' using C:\Users\Lenovo\Desktop\CNKI\city`i'-level-dict.dta
drop _merge
}
gen city_pair_level = city1_level+city2_level
tab city_pair_level,gen(dum_city_level)


*每一个期刊数据加总*
 foreach j in GGGL JJYJ GJJR JCYJ JJDL JJKX REFO SJJZ SJYJ SJYZ SLJY ZGRK ZNCG ZNJJ NJWT JRYJ NKGP JCJJ CYJJ CJYJ KJYJ SJJJ GLSJ GGYY{
use "C:\Users\Lenovo\Desktop\CNKI\CNKI_`j'（over）\maindata2.dta"


keep if distance ==0
gen dict  = pair+year1
keep dict collo_total citation 
	foreach i in collo_total citation {
	rename `i' `i'_`j'
	}
save C:\Users\Lenovo\Desktop\CNKI\merge\内部\CNKI_`j'.dta

use "C:\Users\Lenovo\Desktop\CNKI\CNKI_`j'（over）\maindata2.dta"
drop if distance==0
tostring distance ,gen(distance1) force
gen dict = distance1+"-"+year1
keep dict collo_total citation 
	foreach i in collo_total citation {
	rename `i' `i'_`j'
	}
save C:\Users\Lenovo\Desktop\CNKI\merge\合作\CNKI_`j'.dta

}

foreach j in JJXU GGGL JJYJ GJJR JCYJ JJDL JJKX REFO SJJZ SJYJ SJYZ SLJY ZGRK ZNCG ZNJJ NJWT JRYJ NKGP JCJJ CYJJ CJYJ KJYJ SJJJ GLSJ GGYY{
use C:\Users\Lenovo\Desktop\CNKI\merge\内部\CNKI_`j'.dta
sort dict
save C:\Users\Lenovo\Desktop\CNKI\merge\内部\CNKI_`j'.dta,replace 
}
foreach j in JJXU GGGL JJYJ GJJR JCYJ JJDL JJKX REFO SJJZ SJYJ SJYZ SLJY ZGRK ZNCG ZNJJ NJWT JRYJ NKGP JCJJ CYJJ CJYJ KJYJ SJJJ GLSJ GGYY{
use "C:\Users\Lenovo\Desktop\CNKI\merge\内部\内部合作主数据.dta"
sort dict 
merge dict using C:\Users\Lenovo\Desktop\CNKI\merge\内部\CNKI_`j'.dta
drop _merge 
save "C:\Users\Lenovo\Desktop\CNKI\merge\内部\内部合作主数据.dta",replace 
}
foreach j in JJXU GGGL JJYJ GJJR JCYJ JJDL JJKX REFO SJJZ SJYJ SJYZ SLJY ZGRK ZNCG ZNJJ NJWT JRYJ NKGP JCJJ CYJJ CJYJ KJYJ SJJJ GLSJ GGYY{
use C:\Users\Lenovo\Desktop\CNKI\merge\合作\CNKI_`j'.dta
sort dict
save C:\Users\Lenovo\Desktop\CNKI\merge\合作\CNKI_`j'.dta,replace 
}
foreach j in JJXU GGGL JJYJ GJJR JCYJ JJDL JJKX REFO SJJZ SJYJ SJYZ SLJY ZGRK ZNCG ZNJJ NJWT JRYJ NKGP JCJJ CYJJ CJYJ KJYJ SJJJ GLSJ GGYY{
use "C:\Users\Lenovo\Desktop\CNKI\merge\合作\合作创新主数据.dta"
sort dict 
merge dict using C:\Users\Lenovo\Desktop\CNKI\merge\合作\CNKI_`j'.dta
drop _merge 
save "C:\Users\Lenovo\Desktop\CNKI\merge\合作\合作创新主数据.dta",replace 
}

egen collo_total  = rowtotal(collo_total_JJXU collo_total_GGGL collo_total_JJYJ collo_total_GJJR collo_total_JCYJ collo_total_JJDL collo_total_JJKX collo_total_REFO collo_total_SJJZ collo_total_SJYJ collo_total_SJYZ collo_total_SLJY collo_total_ZGRK collo_total_ZNCG collo_total_ZNJJ collo_total_NJWT collo_total_JRYJ collo_total_NKGP collo_total_JCJJ collo_total_CYJJ collo_total_CJYJ collo_total_KJYJ collo_total_SJJJ collo_total_GLSJ collo_total_GGYY collo_total_ZSHK)
egen citation  = rowtotal(citation_JJXU citation_GGGL citation_JJYJ citation_GJJR citation_JCYJ citation_JJDL citation_JJKX citation_REFO citation_SJJZ citation_SJYJ citation_SJYZ citation_SLJY citation_ZGRK citation_ZNCG citation_ZNJJ citation_NJWT citation_JRYJ citation_NKGP citation_JCJJ citation_CYJJ citation_CJYJ citation_KJYJ citation_SJJJ citation_GLSJ citation_GGYY citation_ZSHK)

*生成总mass-pub\mass-cit*
gen dict= city2+year1
merge m:1 dict using C:\Users\Lenovo\Desktop\CNKI\pub_dict.dta
drop _merge  
merge m:1 dict using C:\Users\Lenovo\Desktop\CNKI\cit_dict.dta
drop _merge  dict
rename pub1_city pub2_city
rename cit1_city cit2_city
gen dict=city1+year1
merge m:1 dict using C:\Users\Lenovo\Desktop\CNKI\pub_dict.dta
drop  _merge
merge m:1 dict using C:\Users\Lenovo\Desktop\CNKI\cit_dict.dta
drop _merge 


