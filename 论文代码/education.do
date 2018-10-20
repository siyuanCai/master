use "G:\数据库\CEPS数据库\CEPS基线调查学生数据.dta"
save "H:\csy\论文使用数据\education\model.dta"
gen score = stdchn+ stdmat+ stdeng

gen sex = a01 -1
gen sport = b16c1 + b16c2/60
gen sportw = b15c1 + b15c2/60
label variable sport "周末运动时间"
label variable sportw "周中运动时间"

gen inc_status = steco_5c

gen hukou = a06

gen age = 2013 - a02a + (9.5-a02b)/12 if fall
replace age = 2013.5 - a02a + (9.5-a02b)/12 if fall<1

gen extraw = b15b1 + b15b2/60
gen extra = b16b1 + b16b2/60

gen sport1 = (5*sportw +2*sport)/7
label variable sport1 "日均运动时长"
gen extra1 = (5*extraw +2*extra)/7
label variable extra1 "日均补课时长"
gen expect = b31
gen sleep = b18a +b18b/60

gen stmocu = b08a
gen stfocu = b08b

drop if extra1 ==.
drop if sex ==.
drop if book ==.
drop if age ==.
drop if hw1 ==.
drop if stfocu ==.
drop if expect ==.
drop if pscore ==.
drop if health ==.
drop if stfedu ==.
drop if hukou ==.
drop if clsids ==.

*作图*
twoway (kdensity score if  s)  ///
	   (kdensity s if ~s), ///
	    xtitle("score")             ///
		legend(label(1 "sport") label(2 "Non-sport"))
*输出统计性表格*
logout, save(sum) word replace:sum score sport1 sport2 sex book num_sib hw1 age  stfocu stmocu expect  stfedu hukou stmedu extra1 cog3pl pscore stonly health
*OLS*
reg score sport1 sport2 clsids schids ctyids,r
est store OLS1
reg score sport1 sport2 sex book num_sib  age  stfocu stmocu expect  stfedu hukou stmedu extra1 clsids schids ctyids,r
est store OLS2
reg score sport1 sport2 sex book num_sib  age  hw1 stfocu stmocu expect  stfedu hukou stmedu extra1 clsids schids ctyids,r
est store OLS3
reg score sport1 sport2 sex book stonly  age  hw1  expect  stfedu hukou stmedu  extra1 clsids schids ctyids,r
est store OLS4
reg score sport1 sport2 sex  num_sib  age  stfocu stmocu expect  hukou  cog3pl clsids schids ctyids,r
est store OLS5
outreg2 [ OLS1 OLS2 OLS3 OLS4 OLS5] using result ,word replace

set seed 1001
gen ranorder = runiform()
sort ranorder

*逐步回归*
global x "sex book num_sib  age  hw1 stfocu stmocu expect  stfedu hukou stmedu extra1 clsids schids ctyids pscore cog3pl health"
logit s $x
stepwise, pr(0.1): logit s $x
stepwise, pr(0.1): probit s $x

*A-I协变量回归*
teffects nnmatch (score sex book age  hw1 stfocu   cog3pl health stfedu hukou extra1 clsids schids ctyids)(s),atet nn(4) ematch(schids ctyids sex clsids)
est store ai1
teffects nnmatch (score sex book age  hw1 stfocu   pscore health stfedu hukou extra1 clsids schids ctyids)(s),atet nn(4) ematch(schids ctyids sex clsids)
est store ai2
teffects nnmatch (score sex book age  hw1 stfocu   cog3pl health stfedu hukou extra1 clsids schids ctyids)(s1),atet nn(4) ematch(schids ctyids sex clsids)
est store ai3
teffects nnmatch (score sex book age  hw1 stfocu   pscore health stfedu hukou extra1 clsids schids ctyids)(s1),atet nn(4) ematch(schids ctyids sex clsids)
est store ai4
teffects nnmatch (score sex book age  hw1 stfocu   cog3pl health stfedu hukou extra1 clsids schids ctyids)(s2),atet nn(4) ematch(schids ctyids sex clsids)
est store ai5
teffects nnmatch (score sex book age  hw1 stfocu   pscore health stfedu hukou extra1 clsids schids ctyids)(s2),atet nn(4) ematch(schids ctyids sex clsids)
est store ai6
outreg2 [ ai1 ai2 ai3 ai4 ai5 ai6] using result-ai ,word replace

teffects nnmatch (score sex book age  hw1 stfocu   cog3pl health stfedu hukou extra1 clsids schids ctyids)(s),ate nn(4) ematch(schids ctyids sex clsids)
est store ai7
teffects nnmatch (score sex book age  hw1 stfocu   pscore health stfedu hukou extra1 clsids schids ctyids)(s),ate nn(4) ematch(schids ctyids sex clsids)
est store ai8
teffects nnmatch (score sex book age  hw1 stfocu   cog3pl health stfedu hukou extra1 clsids schids ctyids)(s1),ate nn(4) ematch(schids ctyids sex clsids)
est store ai9
teffects nnmatch (score sex book age  hw1 stfocu   pscore health stfedu hukou extra1 clsids schids ctyids)(s1),ate nn(4) ematch(schids ctyids sex clsids)
est store ai10
teffects nnmatch (score sex book age  hw1 stfocu   cog3pl health stfedu hukou extra1 clsids schids ctyids)(s2),ate nn(4) ematch(schids ctyids sex clsids)
est store ai11
teffects nnmatch (score sex book age  hw1 stfocu   pscore health stfedu hukou extra1 clsids schids ctyids)(s2),ate nn(4) ematch(schids ctyids sex clsids)
est store ai12
outreg2 [ai7 ai8 ai9 ai10 ai11 ai12] using result-ai1 ,word replace

*稳健性检验*
*PSM*
bootstrap r(att) r(atu) r(ate),reps(500):psmatch2 s sex book age  hw1 stfocu  cog3pl health stfedu hukou extra1 clsids schids ctyids,out(score) n(4) ate ties logit common
est store psm1
bootstrap r(att) r(atu) r(ate),reps(500):psmatch2 s sex book age  hw1 stfocu  pscore health stfedu hukou extra1 clsids schids ctyids,out(score) n(4) ate ties logit common
est store psm2
bootstrap r(att) r(atu) r(ate),reps(500):psmatch2 s1 sex book age  hw1 stfocu cog3pl health stfedu hukou extra1 clsids schids ctyids,out(score) n(4) ate ties logit common
est store psm3
bootstrap r(att) r(atu) r(ate),reps(500):psmatch2 s1 sex book age  hw1 stfocu   pscore health stfedu hukou extra1 clsids schids ctyids,out(score) n(4) ate ties logit common
est store psm4
bootstrap r(att) r(atu) r(ate),reps(500):psmatch2 s2 sex book age  hw1 stfocu  cog3pl health stfedu hukou extra1 clsids schids ctyids,out(score) n(4) ate ties logit common
est store psm5
bootstrap r(att) r(atu) r(ate),reps(500):psmatch2 s2 sex book age  hw1 stfocu   pscore health stfedu hukou extra1 clsids schids ctyids,out(score) n(4) ate ties logit common
est store psm6
outreg2 [psm1 psm2 psm3 psm4] using result-psm ,word replace

*CEM(没有使用)*
cem sex book(2.5 3.5) age(12 14 16) hw1(1 2 3 4 5 6) stfocu(3.5 6.5 7.5 10) expect(1.5 5.5 7.5 8.5) pscore(0 10 45 55) health(2.5 3.5) stfedu(2.5 4.5 6.5 8.5) hukou extra1(1 2 3 4 5) schids ctyids,tr(s)
cem sex book(2.5 3.5) age(12 14 16) hw1(1 2 3 4 5 6) stfocu(3.5 6.5 7.5 10) expect(1.5 3.5 5.5 7.5 8.5) pscore(0 10 45 55) health(2.5 3.5) stfedu(2.5 4.5 6.5 8.5) hukou extra1(1 2 3 4 5) schids ctyids,tr(s)
cem sex book(2.5 3.5) age(11 12 13 14 15 16) hw1(1 2 3 4 5 6) stfocu(3.5 6.5 7.5 10) expect(1.5 5.5 7.5 8.5) pscore(0 10 45 55) health(2.5 3.5) stfedu(2.5 4.5 6.5 8.5) hukou extra1(1 2 3 4 5) schids ctyids,tr(s)
reg score sport1 sport2 clsids schids ctyids [iweight=cem_weights],r
est store CEM1
reg score sport1 sport2 sex book num_sib  age  stfocu stmocu expect  stfedu hukou stmedu extra1 clsids schids ctyids[iweight=cem_weights],r
est store CEM2
reg score sport1 sport2 sex book num_sib  age  hw1 stfocu stmocu expect  stfedu hukou stmedu extra1 clsids schids ctyids[iweight=cem_weights],r
est store CEM3
reg score sport1 sport2 sex book stonly  age  hw1  expect  stfedu hukou stmedu extra1 clsids schids ctyids[iweight=cem_weights],r
est store CEM4
reg score sport1 sport2 sex  num_sib  age  stfocu stmocu expect  hukou  cog3pl clsids schids ctyids[iweight=cem_weights],r
est store CEM5
outreg2 [ CEM1 CEM2 CEM3 CEM4 CEM5] using result-cem ,word replace

*CDH方法*
poparms (s_dummy sex book num_sib  age  stfocu stmocu expect  stfedu hukou stmedu extra1 clsids schids ctyids) (score sex book num_sib  age  stfocu stmocu expect  stfedu hukou stmedu extra1 clsids schids ctyids),vce(bootstrap,reps(500))

*伪干预*

teffects nnmatch (score sex book age  hw1 stfocu   cog3pl health stfedu hukou extra1 clsids schids ctyids)(sj),atet nn(4) ematch(schids ctyids sex clsids)
est store aicg1
teffects nnmatch (score sex book age  hw1 stfocu   pscore health stfedu hukou extra1 clsids schids ctyids)(sj),atet nn(4) ematch(schids ctyids sex clsids)
est store aicg2
teffects nnmatch (score sex book age  hw1 stfocu   cog3pl health stfedu hukou extra1 clsids schids ctyids)(sj),ate nn(4) ematch(schids ctyids sex clsids)
est store aicg7
teffects nnmatch (score sex book age  hw1 stfocu   pscore health stfedu hukou extra1 clsids schids ctyids)(sj),ate nn(4) ematch(schids ctyids sex clsids)
est store aicg8
bootstrap r(att) r(atu) r(ate),reps(500):psmatch2 sj sex book age  hw1 stfocu  cog3pl health stfedu hukou extra1 clsids schids ctyids,out(score) n(4) ate ties logit common
est store psmcg1
bootstrap r(att) r(atu) r(ate),reps(500):psmatch2 sj sex book age  hw1 stfocu  pscore health stfedu hukou extra1 clsids schids ctyids,out(score) n(4) ate ties logit common
est store psmcg2
outreg2 [aicg1 aicg2 aicg7 aicg8 psmcg1 psmcg2] using result-aicg ,word replace
