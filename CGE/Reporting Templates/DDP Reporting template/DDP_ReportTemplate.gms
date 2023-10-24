Sets
* from model
 AC                      global set for model accounts - aggregated microsam accounts
 A(AC)                   activities
 C(AC)                   commodities
 F(AC)                   factors
 FLAB(F)                 labor
 FCAP(F)                 capital
 FLND(F)                 land
 INS(AC)                 institutions
 INSD(INS)               domestic institutions
 INSDNG(INSD)            domestic non-government institutions
 H(INSDNG)               households
 RD(AC)                  domestic or internal regions
 RW(AC)                  world trading regions
 EN(INSDNG)              Enterprises
 TX(AC)                  tax
 IT(AC)
 RUN                     simulations
 FS                      TIMES economic sectors
 PRC(PRC)
 REG
 X                              simulations in eSAGE (CGE)
 XC(X)                          active simulations
 REG
 AY                              All Years /1850*2200, 0/
 T(AY)                          AY /2020,2025,2030,2035,2040,2045,2050,2055/
 TT(T)                   SATIM-eSAGE Iterations
 T1(AY)             base year /2019/
 CCDRIndicators / GDPGrowth, GDPperCapitaGrowth, GDPperCapita, HouseholdCons,
                 PrivateCons, GovCons, PrivateInv, GovInv, NetExports,
                 QVAAgri, QVAIndustry, QVAServices, ExchangeRate,
                 FiscalRevenue, FiscalExpenditure, BudgetDeficit, Emissions, EmissionsperGDP, Deficit/
*gov(INSD)        / gov /
ST(AC)
YT(AC)
I(AC)
total(AC)
MX(AC)
other(AC)
MFSA(FS,A)
MPRCFS(PRC,FS)






* RUN /NZ_9, NZ_9_PAM, NZ_9_WE, NZ_9_PAM_WE, NZ_8, NZ_8_PAM_WE, NZ_8_HiFS, NZ_8_CO2Tax/
  RUN /ReferenceTsitica/
* for microsim
Years(T)
l                        labour classes /f-labun, f-labsk/
mFl(F,l)                   Mapping F to l
;

Parameters
* from model
PQHX(C,H,X,T,TT)                 subsidized or taxed price of composite good c
PQX(C,X,T,TT)                    pre-subsidized or taxed price of composite good c
QQX(C,X,T,TT)
PAX(A,X,T,TT)                    output price of activities
QAX(A,X,T,TT)                    level of domestic activity
QINTX(C,A,X,T,TT)                Quantity of intermediate demand for c from activty a
PQI0(C,A,RD)                     PQ plus subsidy paid on c
PQ0(C)                           Price of composite goods
QH0(C,H)                         the quanity consumed of market commodity c by household h
EG0
QXX
QF0(F,A,RD)                      quantity demanded of factor f from activity a
SAM(AC,AC)
STAX(AC)
Mtax(AC)
QHX(C,H,X,T,TT)                  qnty consumed of market commodity c by household h
WFX(F,X,T,TT)                    economy-wide wage (rent) for factor f
WF0(F)
WFDISTX(F,A,RD,X,T,TT)           factor wage distortion variable
WFDIST0(F,A,RD)
QFSX(F,X,T,TT)                   qnty of factor supply
QFX(F,A,RD,X,T,TT)               qnty demanded of factor f from activity a
QEX(C,RW,X,T,TT)                 qnty of exports
QMX(C,RW,X,T,TT)                 qnty of imports
QE0(C,RW)
PEX(C,RW,X,T,TT)                 price of exports
QM0(C,RW)                        qnty of imports base year
PE0(C,RW)
PMX(C,RW,X,T,TT)                 price of imports
PM0(C,RW)
EXRX(X,T,TT)                     exchange rate
EGX(X,T,TT)                      total current government expenditure

GVA_FS(FS,T)                     SATIM Sector GVA
GDP_RUN(T)                          GDP Projection for RUN
POP(T)                              Population Projection
QGX(C,X,T,TT)                       qnty of government consumption
GSAVX(X,T,TT)                       government savings
QVAX(A,RD,X,T,TT)                   qnty of aggregate value added
PVA0(A,RD)
YGX(X,T,TT)                         total current government income
MPSX(INS,X,T,TT)                    marginal propensity to save for dom non-gov inst
TINSX(INS,X,T,TT)                   rate of direct tax on domestic institutions
YIX(INS,X,T,TT)                     income of domestic non-governmental institutions
YIFX(INS,F,X,T,TT)                  income of institutions ins from factor f
YG_ITAXX(X,T,TT)                    indirect current government income
TRNSFRX(INS,AC,X,T,TT)              transfers from institutions ins or factors ac to institutions
TAX(A,RD,X,T,TT)                    activity tax rate
TVAX(A,RD,X,T,TT)                   indirect value added tax rate
PVAX(A,RD,X,T,TT)                   value added price
PARX(A,RD,X,T,TT)                   output price of activity
QARX(A,RD,X,T,TT)                   level of domestic activity
TMX(C,RW,X,T,TT)                    import tax
TE(C,RW)
TQX(C,X,T,TT)
TFX(F,X,T,TT)                    factor tax rate
YFX(F,X,T,TT)                    factor income
PQGX
TVA0(A,RD)
TCST_INVC(REG,AY,PRC)
INVCOST(RUN,AY,PRC)
* tmp params
wagebill(F,A,T)                    wage bill by factor and activity
wagebill2(A,T)                   wage bill by aggregate factors
GDPperCapita(T)                    GDP per capita
* for microsim
CPI_SA(T)                           CPI
empl_SA(A,T)                      labour demand by category and sector
hcons_SA(T)                         Total household consumption
hconssf_SA(T)                       Total household food consumption
hconsnf_SA(T)                       Total household non-food consumption
swage_SA(A,T)                       Sector wage by skill
unemp_SA(T)                         Unemployed population
wage_SA(T)                        Aggregate wage
QINVX
TotalFactorInc(T)                  Total Factor Income
LabourInc(T)                       Labour income
CapitalInc(T)
LandInc(T)
GOV(T)
IndirectTaxes(T)
* for CCDR template
*Report(CCDRIndicators,T,RUN)             Indicators for Template
Report(*,T,RUN)                   Indicators for Template
HHCons(C,T)
GovCons(C,T)
Inv(C,T)
Expt(C,T)
Imp(C,T)
GDP(C,T)
HPOPX(H,X,T,TT)



EXR                              2019 Exchange Rate 2019 ZAR to 2015 USD
CO2eq(T,RUN)                         CO2 eq from SATIM
;
$gdxin  gdxs\test8Gt3iter2-hr
* $gdxin  test9Gt3iter2-hr
*$gdxin IMGrun_99_20Oct

$load AC,A,C,F,FLAB,FCAP,INS,INSD,INSDNG,H,RD,X,XC,TT,RW,FS,SAM,TX,MFSA,IT,FLND,PRC,REG, MPRCFS

EXR = 15.674;

mFl('flab-p','f-labun') = Yes;
mFl('flab-m','f-labun') = Yes;
mFl('flab-s','f-labsk') = Yes;
mFl('flab-t','f-labsk') = Yes;


SET
L2SECT
L3SECT
ML2SECT(L2SECT,L3SECT,AC)
INST1
INST2
MINST(INST1,PRC)
;

* Generating an Aggregated SAM for KLEM
$SETGLOBAL map "Map.xlsx"
$call "gdxxrw i=Map.xlsx o=Map.gdx index=index!a6"
$gdxin Map.gdx
$load L2SECT L3SECT ML2SECT
;

Years('2020') = Yes;
Years('2030')= Yes;
Years('2040')= Yes;
Years('2050')= Yes;

alias(*,u);
file ordered /ordered.txt/;
loop(SortedUels(u,L3SECT), put ordered L3SECT.tl:0 '  ');
putclose ordered;


alias(L3SECT,SECT),(AC,AACC) ;

$gdxin  gdxs\test8Gt3iter2-hr
* $gdxin  test9Gt3iter2-hr
*$gdxin IMGrun_99_20Oct

$load GDP_RUN,POP,QGX,EGX,GSAVX,QVAX,PVA0,YGX,MPSX,TINSX,YIX,PQHX,PQX,QHX,WFX,WFDISTX,WFDIST0
$load QFSX,QFX,QEX,PEX,QMX,PMX,GVA_FS,EXRX,PM0,PE0,QE0,PAX,QAX,YIFX,trnsfrx,PARX,QARX,TAX,TVAX
$load PVAX,TMX,te,TQX,QQX,TFX,YFX,TVA0,QINTX,PQI0,QH0,PQ0,EG0,QM0,WF0,QF0,QINVX,HPOPX,YG_ITAXX
$load TCST_INVC, INVCOST


*GDPperCapita(T)$POP(T) = GDP_RUN(T)/POP(T);
* empl_SA(l,A,T) = sum(F$mFl(F,l),QFX(F,A,'nat','base',T,'2050'));
HHCons(C,T)   =  Sum(H,QHX(C,H,'BASE',T,'2055')*PQ0(C));
GovCons(C,T)  =  QGX(C,'BASE',T,'2055')*PQ0(C);
Inv(C,T)      = sum(IT,QINVX(C,IT,'base',T,'2055')*PQ0(C)) ;
Imp(C,T)     = QMX(C,'rest','BASE',T,'2055')*PM0(C,'rest');
Expt(C,T)      = QEX(C,'rest','BASE',T,'2055')*PE0(C,'rest') ;
GDP(C,T)      = HHCons(C,T)+ GovCons(C,T)+ Inv(C,T) + Expt(C,T) - Imp(C,T) ;
LabourInc(T) = sum(FLAB,YFX(FLAB,'base',T,'2055'))  ;
CapitalInc(T)       = sum(FCAP,YFX(FCAP,'base',T,'2055'))      ;
LandInc(T)      = sum(FLND,YFX(FLND,'base',T,'2055'))        ;
IndirectTaxes(T) =  YG_ITAXX('base',T,'2055')           ;
TotalFactorInc(T) =  LabourInc(T)+CapitalInc(T)+LandInc(T)+IndirectTaxes(T)   ;



CPI_SA(T)$Sum((C,H),QHX(C,H,'base',T,'2055')) = Sum((C,H),PQHX(C,H,'base',T,'2055')*QHX(C,H,'base',T,'2055'))/Sum((C,H),QHX(C,H,'base',T,'2055'));
*hconssf_SA(T) = Sum((FOODC,H),PQHX(FOODC,H,'base',T,'2055')*QHX(FOODC,H,'base',T,'2055'));

*hconsnf_SA(T) = hcons_SA(T)-hconssf_SA(T);

swage_SA(A,T) = sum(F,WFX(F,'base',T,'2055')*WFDISTX(F,A,'nat','base',T,'2055'));

wagebill(F,A,T) = WFX(F,'base',T,'2055')*WFDISTX(F,A,'nat','base',T,'2055')*QFX(F,A,'nat','base',T,'2055');
wagebill2(A,T) = sum(F,wagebill(F,A,T));

wage_SA(T) = sum(A,wagebill2(A,T))/sum((F,A),QFX(F,A,'nat','base',T,'2055')) ;



parameter
DDP_report(*,T,RUN)
DDP_report1(*,*,T,RUN)
DDP_report2(*,*,*,T,RUN)
DDP_Prices(*,T,run)
;

DDP_report('PopulationSize',Years,Run)               =   POP(Years)/1000 ;
*DDP_report('AverageHHincome',Years,Run)                    =  sum(H,YIX(H,Years,'2055')/EXR ;


DDP_report('TotalGDP',Years,Run)                    =  sum(C,GDP(C,years))/EXR ;
DDP_report('GDPperCapita',Years,Run)                = (sum(C,GDP(C,years))*1000)/(POP(Years)/1000)/EXR ;
DDP_report('HHconsumption',Years,Run)               =  sum(C,HHCons(C,years))/sum(C,GDP(C,years));
DDP_report('GOVconsumption',Years,Run)              =  sum(C,GOVCons(C,years))/sum(C,GDP(C,years));
DDP_report('Investment',Years,Run)                  = sum(C,Inv(C,years))/sum(C,GDP(C,years));
DDP_report('Imports',years,RUN)                     = sum(C,-IMP(C,years))/sum(C,GDP(C,years));
DDP_report('Exports',years,RUN)                     = sum(C,Expt(C,years))/sum(C,GDP(C,years));
DDP_report('LabourInc',years,RUN)                    = LabourInc(years)/TotalFactorInc(years)      ;
DDP_report('GOS',years,RUN)                          = (CapitalInc(years)+LandInc(years))/TotalFactorInc(years)  ;
DDP_report('IndirectTax',years,RUN)                 = IndirectTaxes(years)/TotalFactorInc(years)      ;
DDP_report('Employment',years,RUN)                  =sum((FLAB,A),QFX(FLAB,A,'nat','base',years,'2055'))     ;
DDP_Report('avewage',years,RUN)                    = wage_SA(years)        ;
*DDP_report3(PRC,T,'INVESTMENT')                  = sum(run,INVCOST(RUN,T,PRC));
* DDP_report('GDPPI',years,RUN)$Sum((C,H),QHX(C,H,'base',years,'2055')) = Sum((C,H),PQHX(C,H,'base',years,'2055')*QHX(C,H,'base',years,'2055'))/Sum((C,H),QHX(C,H,'base',years,'2055'));



DDP_report('CPI',years,RUN)$Sum((C,H),QHX(C,H,'base',years,'2055')) = Sum((C,H),PQHX(C,H,'base',years,'2055')*QHX(C,H,'base',years,'2055'))/Sum((C,H),QHX(C,H,'base',years,'2055'));
DDP_report('IPI',years,RUN)$Sum(C,QMX(C,'rest','base',years,'2055')) = Sum(C,PMX(C,'rest','base',years,'2055')*QMX(C,'rest','base',years,'2055'))/Sum(C,QMX(C,'rest','base',years,'2055'));
DDP_report('GDPPI',years,RUN)$Sum(C,QMX(C,'rest','base',years,'2055')) = Sum(C,PMX(C,'rest','base',years,'2055')*QMX(C,'rest','base',years,'2055'))/Sum(C,QMX(C,'rest','base',years,'2055'));
DDP_report('EXR',years,RUN)     = EXRX('Base',Years,'2055')          ;

DDP_report1('ENGInvestment',FS,years,RUN)   = (SUM(PRC$(MPRCFS(PRC,FS)),TCST_INVC('REGION1',years,PRC))/1000)/EXR  ;
DDP_report1('Investment','NA',years,RUN)   =sum((C,IT),QINVX(C,IT,'base',years,'2055')*PQ0(C))/EXR ;
DDP_report1('TotalWage',H,years,RUN)       =YIX(H,'base',years,'2055')              ;
*DDP_report1('EngInvestment','NA',T,RUN)   =sum(PRC,TCST_INVC('REGION1',T,PRC))/1000/EXR ;
*DDP_report1('GVA',
*DDP_report('Investment',years,RUN)                              = INV(years);
*DDP_report2('HHcons',L2SECT,'NA',years,RUN)   = SUM((C,L3SECT)$(ML2SECT(L2SECT,L3SECT,C)),sum(H,QHX(C,H,'base',Years,'2055')*PQ0(c))) ;

DDP_report2('HHcons',L2SECT,L3Sect,years,RUN)   = SUM(C$(ML2SECT(L2SECT,L3SECT,C)),sum(H,QHX(C,H,'base',Years,'2055')*PQ0(c)))/EXR  ;
DDP_report2('Output',L2SECT,L3Sect,years,RUN)   = SUM(A$(ML2SECT(L2SECT,L3SECT,A)),QVAX(A,'NAT','BASE',Years,'2055')*PVA0(A,'NAT'))/EXR  ;
DDP_report2('Exports',L2SECT,L3Sect,years,RUN)   = SUM(C$(ML2SECT(L2SECT,L3SECT,C)),QEX(C,'rest','BASE',Years,'2055')*PE0(C,'rest'))/EXR ;
DDP_report2('Imports',L2SECT,L3Sect,years,RUN)   = SUM(C$(ML2SECT(L2SECT,L3SECT,C)),IMP(C,Years))/EXR;





$EXIT
*K_SAM(K_sectors,K) =                       sum((ac,aacc)$((KLEM(K_sectors,AC))*KLEM(K,AACC)),sam(AC,AACC))*1000  ;

$ontext
* Calculate Employment per SATIM sector
REPORT(PRC,'ACTGRP',TC,RUN,'Employment-p') = sum(FS$MPRCFS2(PRC,FS),sum(A$MFSA(FS,A),QFX('flab-p',A,'nat',XC,TC,'2055')));
REPORT(PRC,'ACTGRP',TC,RUN,'Employment-m') = sum(FS$MPRCFS2(PRC,FS),sum(A$MFSA(FS,A),QFX('flab-m',A,'nat',XC,TC,'2055')));
REPORT(PRC,'ACTGRP',TC,RUN,'Employment-s') = sum(FS$MPRCFS2(PRC,FS),sum(A$MFSA(FS,A),QFX('flab-s',A,'nat',XC,TC,'2055')));
REPORT(PRC,'ACTGRP',TC,RUN,'Employment-t') = sum(FS$MPRCFS2(PRC,FS),sum(A$MFSA(FS,A),QFX('flab-t',A,'nat',XC,TC,'2055')));

CPI_SA(T)$Sum((C,H),QHX(C,H,'base',T,'2055')) = Sum((C,H),PQHX(C,H,'base',T,'2055')*QHX(C,H,'base',T,'2055'))/Sum((C,H),QHX(C,H,'base',T,'2055'));
hconssf_SA(T) = Sum((FOODC,H),PQHX(FOODC,H,'base',T,'2055')*QHX(FOODC,H,'base',T,'2055'));

hconsnf_SA(T) = hcons_SA(T)-hconssf_SA(T);

swage_SA(A,l,T) = sum(F$mFl(F,l),WFX(F,'base',T,'2055')*WFDISTX(F,A,'nat','base',T,'2055'));

wagebill(F,A,T) = WFX(F,'base',T,'2055')*WFDISTX(F,A,'nat','base',T,'2055')*QFX(F,A,'nat','base',T,'2055');
wagebill2(l,A,T) = sum(F$mFl(F,l),wagebill(F,A,T));

wage_SA(l,T)$sum(A,empl_SA(l,A,T)) = sum(A,wagebill2(l,A,T))/sum(A,empl_SA(l,A,T));


$offtext
$EXIT
execute_unload "Tableau.gdx"    hcons_SA(T)            ;



execute_unload "Tableau.gdx" Report2;
execute 'gdxdump Tableau.gdx output=Tableau_00.csv symb=Report2 format=csv header="Indicator,AC,H,Year,Scenario,SATIMGE"';

execute_unload "Tableau.gdx" Report3;
execute 'gdxdump Tableau.gdx output=Tableau_01.csv symb=Report2 format=csv header="Indicator,AC,H,Year,Scenario,SATIMGE"';
$EXIT
