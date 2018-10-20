sort pair year
gen ave111=.
replace ave111=(collo_total111[_n-1]+collo_total111[_n]+collo_total111[_n+1])/3
gen lnave111=ln(ave111+1)

*平行趋势检验*
preserve
drop if year<=10 
drop if distance==.
drop if strmatch(pair,"*上海*")=1 | strmatch(pair,"*北京*")=1
collapse (mean) lncollo_total, by(year speedup66)
twoway (line lncollo_total year if speedup66==1 ,xline(18))(line lncollo_total year if speedup66==0,xline(18)),legend(label(1 "处理组") label(2 "控制组")) 	
restore
*event study*
reg lncollo_total speedup66 c.speedup66#i.year DN DN_square pop pop_square  i.pair1 i.year c.dum_city_level?#i.year if year>=7& year<=18 ,r
reg lncollo_total_invg  c.speedup66#i.year lninvg1 lninvg2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12  i.pair1 i.year  if year>=7& year<=24 ,r

reg lncollo_total spp i.pair1 i.year  if year<=24 & year>=7 ,r
est store collo1
reg lncollo_total spp lninvg1 lninvg2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 i.pair1 i.year  if year<=24 & year>=7 ,r
est store collo2
reg lncollo_total_invg spp  i.pair1 i.year if year<=24 & year>=7,r
est store collo3
reg lncollo_total_invg spp lninvg1 lninvg2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 i.pair1 i.year  if year<=24 & year>=7,r
est store collo4
outreg2 [collo1 collo2 collo3 collo4 ] using colloresult.rtf,dec(3) replace

*PPML*
xtpoisson collo_total spp  i.year if year<=24 & year>=7 ,fe r
est store ppml1
xtpoisson collo_total spp inva1 inva2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 i.year  if year<=24 & year>=7 ,fe r
est store ppml2
xtpoisson collo_total_invg spp  i.year if year<=24 & year>=7 ,fe r irr
est store ppml3
xtpoisson collo_total_invg spp invg1 invg2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 i.year if year<=24 & year>=7 ,fe r irr
est store ppml4


ppml lncollo_total spp pair_?  pair_?? pair_??? year_? year_?? if year<=24 & year>=7 ,keep cluster(pair)
est store ppml1
ppml lncollo_total spp lninva1 lninva2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 pair_? pair_?? pair_??? year_? year_??  if year<=24 & year>=7 ,keep cluster(pair)
est store ppml2
ppml lncollo_total_invg spp  pair_?  pair_?? pair_??? year_? year_?? if year<=24 & year>=7 ,keep 
est store ppml3
ppml lncollo_total_invg spp lninvg1 lninvg2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 pair_?  pair_?? pair_??? year_? year_?? if year<=24 & year>=7 ,keep
est store ppml4
outreg2 [ppml1 ppml2 ppml3 ppml4] using ppml.rtf,dec(3) replace 


xtpoisson collo_total spp inva1 inva2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 i.year if year<=24 & year>=7& distance>0 & highinnopair==0,fe r 
est store ppmlcitylevel1
xtpoisson collo_total spp inva1 inva2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 i.year if year<=24 & year>=7& distance>0 & highinnopair==1,fe r
est store ppmlcitylevel2
xtpoisson collo_total spp inva1 inva2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 i.year if year<=24 & year>=7& distance>0 & highinnopair==2,fe r
est store ppmlcitylevel3
xtpoisson lncollo_total_invg spp lninvg1 lninvg2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12  year_? year_?? if year<=24 & year>=7& distance>0 & highinnopair==0,fe r irr
est store ppmlcitylevel4
xtpoisson lncollo_total_invg spp invg1 invg2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12  year_? year_??  if year<=24 & year>=7& distance>0 & highinnopair==1,fe r irr
est store ppmlcitylevel5
xtpoisson lncollo_total_invg spp invg1 invg2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12  year_? year_?? if year<=24 & year>=7& distance>0 & highinnopair==2,fe r irr
est store ppmlcitylevel6

ppml lncollo_total_invg spp lninvg1 lninvg2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 pair_?  pair_?? pair_??? year_? year_?? if year<=24 & year>=7& distance>0 & highinnopair_new==0,keep cluster(pair)
est store ppmlcitylevel4
ppml lncollo_total_invg spp lninvg1 lninvg2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 pair_?  pair_?? pair_??? year_? year_??  if year<=24 & year>=7& distance>0 & highinnopair_new==1,keep cluster(pair)
est store ppmlcitylevel5
ppml lncollo_total_invg spp lninvg1 lninvg2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 pair_?  pair_?? pair_??? year_? year_?? if year<=24 & year>=7& distance>0 & highinnopair_new==2,keep cluster(pair)
est store ppmlcitylevel6
outreg2 [ppmlcitylevel4 ppmlcitylevel5 ppmlcitylevel6 ] using ppmlcitylevel.rtf,dec(3) replace 

xtpoisson collo_total spp inva1 inva2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 i.year if year<=24 & year>=7 & distance>0 & distance<200,fe r
est store ppmldistance1
xtpoisson collo_total spp inva1 inva2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 i.year if year<=24 & year>=7 & distance>=200 & distance<370,fe r
est store ppmldistance2
xtpoisson collo_total spp inva1 inva2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 i.year  if year<=24 & year>=7 & distance>=370,fe r
est store ppmldistance3
xtpoisson collo_total_invg spp invg1 invg2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 i.year if year<=24 & year>=7 & distance>0 & distance<200,fe r
est store ppmldistance5
xtpoisson lncollo_total_invg spp lninvg1 lninvg2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 i.year  if year<=24 & year>=7 & distance>=200 & distance<370,fe r
est store ppmldistance6,fe r
xtpoisson lncollo_total_invg spp lninvg1 lninvg2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 i.year if year<=24 & year>=7 & distance>=370 ,fe r
est store ppmldistance7,fe r

ppml lncollo_total spp lninva1 lninva2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 pair_?  pair_?? pair_??? year_? year_?? if year<=24 & year>=7 & distance>0 & distance<200,keep cluster(pair)
est store ppmldistance1
ppml lncollo_total spp lninva1 lninva2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 pair_?  pair_?? pair_??? year_? year_?? if year<=24 & year>=7 & distance>=200 & distance<370,keep cluster(pair)
est store ppmldistance2
ppml lncollo_total spp lninva1 lninva2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 pair_?  pair_?? pair_??? year_? year_??  if year<=24 & year>=7 & distance>=370,keep cluster(pair)
est store ppmldistance3
ppml lncollo_total_invg spp lninvg1 lninvg2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 pair_?  pair_?? pair_??? year_? year_?? if year<=24 & year>=7 & distance>0 & distance<200,keep cluster(pair)
est store ppmldistance5
ppml lncollo_total_invg spp lninvg1 lninvg2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 pair_?  pair_?? pair_??? year_? year_??  if year<=24 & year>=7 & distance>=200 & distance<370,keep cluster(pair)
est store ppmldistance6,fe r
ppml lncollo_total_invg spp lninvg1 lninvg2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 pair_?  pair_?? pair_??? year_? year_?? if year<=24 & year>=7 & distance>=370 ,keep cluster(pair)
est store ppmldistance7,fe r
outreg2 [ppmldistance1 ppmldistance2 ppmldistance3 ppmldistance5 ppmldistance6 ppmldistance7] using ppmldistance.rtf,dec(3) replace 
*异质性分析*（距离）
ppml collo_total speedup66##post##c.lndistance i.pair1 i.year c.dum_city_level?#i.year if year<=24 & year>=7 & distance>0,r
est store DDD1
reg lncollo_total speedup66##post##c.lndistance lninva1 lninva2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 i.pair1 i.year if year<=24 & year>=7 & distance>0,r
est store DDD2
reg lncollo_total_invg speedup66##post##c.lndistance i.pair1 i.year c.dum_city_level?#i.year if year<=24 & year>=7 & distance>0,r
est store DDD3
reg lncollo_total_invg speedup66##post##c.lndistance DN DN_square pop pop_square i.pair1 i.year c.dum_city_level?#i.year if year<=24 & year>=7 & distance>0,r
est store DDD4
outreg2 [DDD1 DDD2 DDD3 DDD4] using collo_Distance_DDD.rtf,dec(3) replace
reg lncollo_total speedup66##post DN DN_square pop pop_square i.pair1 i.year c.dum_city_level?#i.year if year<=24 & year>=7 & distance>0 & distance<200,r
est store distance1
reg lncollo_total speedup66##post DN DN_square pop pop_square i.pair1 i.year c.dum_city_level?#i.year if year<=24 & year>=7 & distance>=200 & distance<400,r
est store distance2
reg lncollo_total speedup66##post DN DN_square pop pop_square i.pair1 i.year c.dum_city_level?#i.year if year<=24 & year>=7 & distance>=400 & distance<600,r
est store distance3
reg lncollo_total speedup66##post DN DN_square pop pop_square i.pair1 i.year c.dum_city_level?#i.year if year<=24 & year>=7 & distance>=600,r
est store distance4
outreg2 [distance1 distance2 distance3 distance4] using collo_Distance_DID.rtf,dec(3) replace
reg lncollo_total speedup66 c.speedup66#i.year DN DN_square pop pop_square  i.pair1 i.year c.dum_city_level?#i.year if year>=7& year<=24 & distance>0 & distance<200,r
reg lncollo_total speedup66 c.speedup66#i.year DN DN_square pop pop_square  i.pair1 i.year c.dum_city_level?#i.year if year>=7& year<=24 & distance>=200 & distance<370,r
reg lncollo_total speedup66 c.speedup66#i.year DN DN_square pop pop_square  i.pair1 i.year c.dum_city_level?#i.year if year>=7& year<=24 & distance>=370 & distance<640,r
reg lncollo_total speedup66 c.speedup66#i.year DN DN_square pop pop_square  i.pair1 i.year c.dum_city_level?#i.year if year>=7& year<=24 & distance>=600,r



reg lncollo_total_invg speedup66##post DN DN_square pop pop_square i.pair1 i.year c.dum_city_level?#i.year if year<=24 & year>=7 & distance>0 & distance<200,r
est store distance5
reg lncollo_total_invg speedup66##post DN DN_square pop pop_square i.pair1 i.year c.dum_city_level?#i.year if year<=24 & year>=7 & distance>=200 & distance<370,r
est store distance6
reg lncollo_total_invg speedup66##post DN DN_square pop pop_square i.pair1 i.year c.dum_city_level?#i.year if year<=24 & year>=7 & distance>=370 & distance<600,r
est store distance7
reg lncollo_total_invg speedup66##post DN DN_square pop pop_square i.pair1 i.year c.dum_city_level?#i.year if year<=24 & year>=7 & distance>=640,r
est store distance8
outreg2 [distance5 distance6 distance7 distance8] using collo_Distance_DID.rtf,dec(3) replace
reg lncollo_total_invg speedup66 c.speedup66#i.year DN DN_square pop pop_square  i.pair1 i.year c.dum_city_level?#i.year if year>=7& year<=24 & distance>0 & distance<200,r
reg lncollo_total_invg speedup66 c.speedup66#i.year DN DN_square pop pop_square  i.pair1 i.year c.dum_city_level?#i.year if year>=7& year<=24 & distance>=200 & distance<370,r
reg lncollo_total_invg speedup66 c.speedup66#i.year DN DN_square pop pop_square  i.pair1 i.year c.dum_city_level?#i.year if year>=7& year<=24 & distance>=370 & distance<640,r
reg lncollo_total_invg speedup66 c.speedup66#i.year DN DN_square pop pop_square  i.pair1 i.year c.dum_city_level?#i.year if year>=7& year<=24 & distance>=640,r


*异质性分析*（城市等级）
reg lncollo_total speedup66##post lninva1 lninva2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 i.pair1 i.year if year<=24 & year>=7 & distance>0 & highinnopair_new==0,r
est store citylevel1
reg lncollo_total speedup66##post lninva1 lninva2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 i.pair1 i.year if year<=24 & year>=7 & distance>0 & highinnopair_new==1,r
est store citylevel2
reg lncollo_total spp lninva1 lninva2 lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 i.pair1 i.year if year<=24 & year>=7 & distance>0 & highinnopair_new==2,r
est store citylevel3
outreg2 [citylevel1 citylevel2 citylevel3] using collo_citylevel_DID.rtf,dec(3) replace

reg lncollo_total speedup66 c.speedup66#i.year DN DN_square pop pop_square i.pair1 i.year c.dum_city_level?#i.year if year<=24 & year>=7 & distance>0 & dum_city_level1==1,r
reg lncollo_total speedup66 c.speedup66#i.year DN DN_square pop pop_square i.pair1 i.year c.dum_city_level?#i.year if year<=24 & year>=7 & distance>0 & (dum_city_level2==1|dum_city_level4==1),r
reg lncollo_total speedup66 c.speedup66#i.year DN DN_square pop pop_square i.pair1 i.year c.dum_city_level?#i.year if year<=24 & year>=7 & distance>0 & (dum_city_level3==1|dum_city_level5==1),r



reg lncollo_total_invg speedup66##post invg1_lag invg2_lag lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 i.pair1 i.year c.dum_city_level?#i.year if year<=24 & year>=7 & distance>0 & highinnopair==0,r
est store citylevel4
reg lncollo_total_invg speedup66##post invg1_lag invg2_lag lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 i.pair1 i.year c.dum_city_level?#i.year if year<=24 & year>=7 & distance>0 &  highinnopair==1,r
est store citylevel5
reg lncollo_total_invg speedup66##post invg1_lag invg2_lag lnfdi1 lnfdi2 lnRD1 lnRD2 policy11 policy12 i.pair1 i.year c.dum_city_level?#i.year if year<=24 & year>=7 & distance>0 & highinnopair==2,r
est store citylevel6
outreg2 [citylevel4 citylevel5 citylevel6] using collo_invg_citylevel_DID.rtf,dec(3) replace

