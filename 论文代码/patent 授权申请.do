**************机制分析****************
1.集聚效应，促进了当地经济，技术进步
2.增强了知识流的流动，face-to-face
3.firm & labor sorting & matching
合作距离是否更长。
合作是否更多

学校数量  政府RD投入  三产比例  人均道路面积  互联网用户  

*benchmark regression*
diff lninvg if year<=24,t( speedup66 ) p( post ) robust
reg lninvg speedup66 post spp  i.city i.year if year<=24,r
reg lninvg speedup66 post spp  i.city i.prov#i.year if year<=24,r
diff lninvg if year<=24 &strmatch(city1,"*深圳*")==0,t( speedup66 ) p( post ) robust
reg lninvg speedup66 post spp  i.city i.year if year<=24 & strmatch(city1,"*深圳*")==0,r
reg lninvg speedup66 post spp  i.city i.prov#i.year if year<=24 & strmatch(city1,"*深圳*")==0,r

*平行趋势检验*
preserve
drop if year<=10 
collapse (mean) lninvg, by(year speedup66)
twoway (line lninvg year if speedup66==1 ,xline(18))(line lninvg year if speedup66==0,xline(18)),legend(label(1 "处理组") label(2 "控制组")) 	
restore	
*event study*
reg lninvg speedup66 c.speedup66#i.year i.year i.prov#i.year i.city  ,r


*regional favoritism*


*collapsed data*
sort city year
gen ave=.
replace ave=(invg[_n-1]+invg[_n]+invg[_n+1])/3
gen lnave = ln(ave+1)
diff lnave if year<=24,t( speedup66 ) p( post ) robust
reg lnave speedup66 post spp  i.city i.year if year<=24,r
reg lnave speedup66 post spp  i.city i.year i.prov#i.year if year<=24,r
*placebo test*  year from 11-15
forvalues i = 11(1)14{
gen post`i' = year>= `i'
gen spp`i' = speedup66*post`i'
reg lninvg speedup66 post`i' spp`i' if year>=`i'-3 &year<=`i'+3,r 
est store lnDID`i'
}
outreg2 [DID11 DID12 DID13 DID14 DID15] using placebotest.rtf
outreg2 [lnDID11 lnDID12 lnDID13 lnDID14 lnDID15] using lnplacebotest.rtf
*********************异质性分析********************
*高创新能力与低创新能力城市*大学数量或专利数量
bys year:egen meaninvg = mean(invg)
gen highinnocity = 0
replace highinnocity=1 if city==		"上海市"
replace highinnocity=1 if city==		"兰州市"
replace highinnocity=1 if city==		"南昌市"
replace highinnocity=1 if city==		"厦门市"
replace highinnocity=1 if city==		"哈尔滨市"
replace highinnocity=1 if city==		"太原市"
replace highinnocity=1 if city==		"成都市"
replace highinnocity=1 if city==		"昆明市"
replace highinnocity=1 if city==		"杭州市"
replace highinnocity=1 if city==		"洛阳市"
replace highinnocity=1 if city==		"淄博市"
replace highinnocity=1 if city==		"深圳市"
replace highinnocity=1 if city==		"石家庄市"
replace highinnocity=1 if city==		"西安市"
replace highinnocity=1 if city==		"贵阳市"
replace highinnocity=1 if city==		"重庆市"
replace highinnocity=1 if city==		"金华市"
replace highinnocity=1 if city==		"青岛市"
 
diff lninvg,t( speedup66 ) p( post ) ddd(highinnocity) robust
*高GDP与低GDP*

*滞后与预期 动态效果*





*********************福利分析*********************
可达性的增加到底是将别处的资源吸引过来，还是能够形成集聚效应。
空间计量


