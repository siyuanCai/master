**************机制分析****************
1.集聚效应，促进了当地经济，技术进步
2.增强了知识流的流动，face-to-face
3.firm & labor sorting & matching
合作距离是否更长。
合作是否更多

学校数量  政府RD投入  三产比例  人均道路面积  互联网用户  

*benchmark regression*
reg lninva1  spp i.city1 i.year  if year<=24 & year>=7 ,r
est store OLS1
reg lninva1 spp DN DN2  policy1 lnpop lnpop2 lnfdi1 lnRD i.city1 i.year if year>=7 ,r
est store OLS2
reg quality  spp i.city1 i.year if year<=24 & year>=7,r
est store OLS3
reg quality  spp  DN DN2  policy1 lnpop lnpop2 lnfdi1 lnRD i.city1 i.year if year>=7,r
est store OLS4

outreg2  [OLS1 OLS2 OLS3 OLS4] using mainresult.rtf,dec(3) replace


*平行趋势检验*
preserve
drop if year<=13
drop if year>=24
drop if strmatch(pair,"*深圳*")==1
collapse (mean) invg, by(year speedup6)
twoway (line invg year if speedup6==1 ,xline(18))(line invg year if speedup6==0,xline(18)),legend(label(1 "处理组") label(2 "控制组"))	
restore	
*event study*
reg lninva1 speedup66 c.speedup66#i.year DN DN2 lnpop lnpop2 lnfdi lnRD policy1 i.year i.city1 if year<=24 & year>=7,r
reg lninvg  speedup66 c.speedup66#i.year DN DN2 lnpop lnpop2 lnfdi lnRD policy1 i.year i.city1 if year<=24& year>=7 ,r
reg quality  speedup66 c.speedup66#i.year DN DN2 policy1 lnpop lnpop2 lnfdi1 lnRD i.year i.city1 if year<=24 & year>=7,r
*regional favoritism*

*坡度*(不加)
reg lninva1 speedup66 post spp slope lngdpiv lnpopiv if year<=24,r
est store slope1
reg lninva1 speedup66 post spp slope lngdpiv lnpopiv i.city1 i.year if year<=24,r
est store slope2
reg lninva1 speedup66 post spp slope lngdpiv lnpopiv i.city1 i.year i.prov#i.year if year<=24 ,r
est store slope3
nbreg inva1 speedup66 post spp slope lngdpiv lnpopiv if year<=24,r
est store slope4
nbreg inva1 speedup66 post spp slope lngdpiv lnpopiv  i.year if year<=24,r 
est store slope5
nbreg inva1 speedup66 post spp slope lngdpiv lnpopiv  i.year i.prov#i.year if year<=24,r 
est store slope6
outreg2  [slope1 slope2 slope3 slope4 slope5 slope6] using slope.rtf,dec(3) replace


*collapsed data*
sort city year
gen ave1=.
replace ave1=(inva1[_n-1]+inva1[_n]+inva1[_n+1])/3
replace lnave1 = ln(ave1+1)
gen aveg = (invg[_n-1]+invg[_n]+invg[_n+1])/3
gen lnaveg = ln(aveg+1)
gen aveq = (quality[_n-1]+quality[_n]+quality[_n+1])/3
reg lnave1 speedup66 post spp i.city1 i.year  if year<=24 & year>=7 ,r
est store ave1
reg lnave1  speedup66 post spp DN DN2 policy1 lnpop lnpop2 lnfdi1 lnRD i.city1 i.year if year>=7,r
est store ave2
reg aveq speedup66 post spp i.city1 i.year  if year<=24 & year>=7 ,r
est store ave3
reg aveq  speedup66 post spp DN DN2 policy1 lnpop lnpop2 lnfdi1 lnRD i.city1 i.year if year>=7 ,r
est store ave4
outreg2  [ave1 ave2 ave3 ave4] using ave.rtf,dec(3) replace


*授权指标*
reg lninvg  spp i.city1 i.year if year<=24 & year>=7,r
est store aveg1
reg lninvg  spp  DN DN2 policy1 lnpop lnpop2 lnfdi1 lnRD i.city1 i.year if year>=7 ,r
est store aveg2
reg lnaveg spp i.city1 i.year  if year<=24 & year>=7 ,r
est store aveg3
reg lnaveg spp DN DN2 policy1 lnpop lnpop2 lnfdi1 lnRD i.city1 i.year if year>=7,r
est store aveg4
outreg2  [aveg1 aveg2 aveg3 aveg4] using aveg.rtf,dec(3) replace
*placebo test*  year from 14-16
forvalues i = 14(1)16{
reg lninva1 speedup66 post`i' spp`i' DN DN2 policy lnpop lnpop2 lnfdi1 lnRD i.city1 i.year if year>=`i'-1 &year<=`i'+1,r 
est store lnDID`i'
}
outreg2 [lnDID14 lnDID15 lnDID16] using lnplacebotesta.rtf,dec(3) replace
forvalues i = 14(1)16{
reg quality speedup66 post`i' spp`i' DN DN2 policy1 lnpop lnpop2 lnfdi1 lnRD i.city1 i.year if year>=`i'-1 &year<=`i'+1,r 
est store qualityDID`i'
}
outreg2 [qualityDID14 qualityDID15 qualityDID16] using placebotestq.rtf,dec(3) replace

forvalues i = 14(1)16{
reg lninvg speedup66 post`i' spp`i' DN DN2 policy lnpop lnpop2 lnfdi1 lnRD i.city1 i.year if year>=`i'-1 &year<=`i'+1,r 
est store lnDIDg`i'
}
outreg2 [lnDIDg14 lnDIDg15 lnDIDg16] using lnplacebotestg.rtf,dec(3) replace

*********************异质性分析********************
*高创新能力与低创新能力城市*专利数量
reg lninva1 speedup66##post##highinnocity DN DN2 policy1 lnpop lnpop2 lnfdi1 lnRD i.year i.city1 if year>=7 & year<=24,r
est store school1
reg lnave1 speedup66##post##highinnocity  DN DN2 policy1 lnpop lnpop2 lnfdi1 lnRD i.year i.city1 if year>=7,r
est store school2

reg lninvg  speedup66##post##highinnocity DN DN2 policy1 lnpop lnpop2 lnfdi1 lnRD i.year i.city1 if year>=7 & year<=24,r
est store school3
reg lnaveg  speedup66##post##highinnocity DN DN2 policy1 lnpop lnpop2 lnfdi1 lnRD i.year i.city1 if year>=7,r
est store school4

outreg2  [school1 school2 school3 school4] using school1.rtf,dec(3) replace

*分样本*
reg lninva1 speedup66##post DN DN2 policy1 lnpop lnpop2 lnfdi1 lnRD i.year i.city1 if year>=7 & year<=24 & highinnocity==0,r
est store school1
reg lnave1 speedup66##post##c.DN  DN DN2 policy1 lnpop lnpop2 lnfdi1 lnRD i.year i.city1 if year>=7,r
est store school2

reg lninvg  speedup66##post DN DN2 policy1 lnpop lnpop2 lnfdi1 lnRD i.year i.city1 if year>=7 & year<=24 & highinnocity==0,r
est store school3
reg lnaveg  speedup66##post##c.DN DN DN2 policy1 lnpop lnpop2 lnfdi1 lnRD i.year i.city1 if year>=7,r
est store school4

*与省会或直辖市距离*（不加）
reg lninva1 speedup66##post##c.lndistance DN DN2 policy1 lnpop lnpop2 lnfdi1 lnRD i.year i.city1 if year>=7,r
est store distance1
reg lninva1 speedup66##post DN DN2 policy1 lnpop lnpop2 lnfdi1 lnRD  i.year i.city1 if distance>0 & distance<=100,r
est store distance2
reg lninva1 speedup66##post DN DN2 policy1 lnpop lnpop2 lnfdi1 lnRD  i.year i.city1 if distance>100 & distance<=200 ,r
est store distance3
reg lninva1 speedup66##post DN DN2 policy1 lnpop lnpop2 lnfdi1 lnRD  i.year i.city1 if distance>400 & distance<=500 ,r 
est store distance4
outreg2  [gdpiv1 gdpiv2 gdpiv3 gdpiv4] using gdpiv.rtf,replace

reg lninvg speedup66##post##c.distance DN DN2 policy1 lnpop lnpop2 lnfdi1 lnRD i.year i.city1 ,r
est store distance1
reg lninvg speedup66##post DN DN2 policy1 lnpop lnpop2 lnfdi1 lnRD  i.year i.city1 if distance>0 & distance<=100,r
est store distance2
reg lninvg speedup66##post DN DN2 policy1 lnpop lnpop2 lnfdi1 lnRD  i.year i.city1 if distance>100 & distance<=200 ,r
est store distance3
reg lninvg speedup66##post DN DN2 policy1 lnpop lnpop2 lnfdi1 lnRD  i.year i.city1 if distance>200 & distance<=300 ,r 
est store distance4
*********************福利分析*********************
可达性的增加到底是将别处的资源吸引过来，还是能够形成集聚效应。
空间计量

reg pop spp i.city1 i.year if year<=24 & year>=7,r
