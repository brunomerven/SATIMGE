Sets
* from model
 AC                      global set for model accounts - aggregated microsam accounts
 A(AC)                   activities
 C(AC)                   commodities
 F(AC)                   factors
 FLAB(F)                 labor
 FCAP(F)                 capital
 INS(AC)                 institutions
 INSD(INS)               domestic institutions
 INSDNG(INSD)            domestic non-government institutions
 H(INSDNG)               households
 RD(AC)                  domestic or internal regions
 RW(AC)                  world trading regions
 RUN                     simulations
 FS                      TIMES economic sectors
 X                              simulations in eSAGE (CGE)
 XC(X)                          active simulations

 ALLYEAR                        All Years /1850*2200, 0/
 T(ALLYEAR)                     Time periods /2005*2070/
 TT(T)                   SATIM-eSAGE Iterations
 T1(ALLYEAR)             base year /2019/
 CCDRIndicators / GDPGrowth, GDPperCapitaGrowth, GDPperCapita, HouseholdCons,
                 PrivateCons, GovCons, PrivateInv, GovInv, NetExports,
                 QVAAgri, QVAIndustry, QVAServices, ExchangeRate,
                 FiscalRevenue, FiscalExpenditure, BudgetDeficit, Emissions, EmissionsperGDP, Deficit/
K_Energy_c(C)      KLEM Energy Sectors
K_NonEnergy_c(C)   KLEM Non-Energy Sectors
K_Energy_a(A)      KLEM Energy Sectors
K_NonEnergy_a(A)   KLEM Non-Energy Sectors
K_labour(F)
K_Capital(F)
K_Land(F)

* RUN /NZ_9, NZ_9_PAM, NZ_9_WE, NZ_9_PAM_WE, NZ_8, NZ_8_PAM_WE, NZ_8_HiFS, NZ_8_CO2Tax/
  RUN /NZ_8/
* for microsim
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
TRNSFRX(INS,AC,X,T,TT)              transfers from institutions ins or factors ac to institutions
TAX(A,RD,X,T,TT)                    activity tax rate
TVAX(A,RD,X,T,TT)                   indirect value added tax rate
PVAX(A,RD,X,T,TT)                value added price
PARX(A,RD,X,T,TT)
QARX(A,RD,X,T,TT)
TMX(C,RW,X,T,TT)                 import tax
TE(C,RW)
TQX(C,X,T,TT)
TFX(F,X,T,TT)                    factor tax rate
YFX(F,X,T,TT)                    factor income
TVA0(A,RD)

* tmp params
wagebill(F,A,T)                    wage bill by factor and activity
wagebill2(l,A,T)                   wage bill by aggregate factors
GDPperCapita(T)                    GDP per capita

* for microsim
CPI_SA(T)                           CPI
empl_SA(l,A,T)                      labour demand by category and sector
hcons_SA(T)                         Total household consumption
hconssf_SA(T)                       Total household food consumption
hconsnf_SA(T)                       Total household non-food consumption
swage_SA(A,l,T)                     Sector wage by skill
unemp_SA(T)                         Unemployed population
wage_SA(l,T)                        Aggregate wage

* for CCDR template
*Report(CCDRIndicators,T,RUN)             Indicators for Template
Report(*,T,RUN)             Indicators for Template



EXR2019                              2019 Exchange Rate ZAR per USD
CO2eq(T,RUN)                         CO2 eq from SATIM
;
*$gdxin  CCDR8GtonJuly.gdx
$gdxin  CCDR_Runs\NZ_9.gdx
$load AC,A,C,F,FLAB,FCAP,INS,INSD,INSDNG,H,RD,X,XC,TT,RW,FS


Sets
FOODC(C)                Food commodities /cawhe, camai, caoce, caveg, caofr, cagra, caoil, catub, capul, caoth,
                                          clani, cmeat, cpfis, cvege, cfats, cdair, cgrai, cstar, cafee, cbake,
                                         csuga, cconf, cpast, cofoo, cbevt/

;


EXR2019 = 14.436;
$ontext
 $call   "gdxxrw i=CO2eq.xlsx o=CO2eq.gdx index=index!A1";
 $gdxin  CO2eq.gdx
       $load CO2eq
$offtext
;
mFl('flab-p','f-labun') = Yes;
mFl('flab-m','f-labun') = Yes;
mFl('flab-s','f-labsk') = Yes;
mFl('flab-t','f-labsk') = Yes;


File Scen;

*LOOP(RUN,

*put_utilities Scen 'gdxin' / "CCDR_Runs\",RUN.TL:50;
*execute_load GDP_RUN,POP,QGX,EGX,GSAVX,QVAX,YGX,MPSX,TINSX,YIX,PQHX,PQX,QHX,WFX,WFDISTX,QFSX,QFX,QEX,PEX,QMX,PMX,GVA_FS,EXRX;

* $gdxin  CCDR_Runs\NZ_9.gdx
$load GDP_RUN,POP,QGX,EGX,GSAVX,QVAX,PVA0,YGX,MPSX,TINSX,YIX,PQHX,PQX,QHX,WFX,WFDISTX,WFDIST0,QFSX,QFX,QEX,PEX,QMX,PMX,GVA_FS,EXRX,PM0,PE0,QE0,PAX,QAX,YIFX,trnsfrx,PARX,QARX,TAX,TVAX,PVAX,TMX,te,TQX,QQX,TFX,YFX,TVA0,QINTX,PQI0,QH0,PQ0,EG0,QM0,WF0

GDPperCapita(T)$POP(T) = GDP_RUN(T)/POP(T);

*GVA

;
PARAMETER
Report2(*,*,*,T,RUN)
;


* ECONOMY
Report2('GVA',A,'NA',T,RUN)                      = QVAX(A,'NAT','BASE',T,'2050')*PVA0(A,'NAT');
Report2('GDPperCapita','NA','NA',T,RUN)          = GDPperCapita(T)*1000000/EXR2019;
Report2('NominalGDP',A,'NA',T,RUN)               = PVAX(A,'nat','base',T,'2050')*(1-TVAX(A,'nat','base',T,'2050'))*QVAX(A,'nat','base',T,'2050');
Report2('RealGDP',A,'NA',T,RUN)                  = PVA0(A,'nat')*(1-TVA0(A,'nat'))*QVAX(A,'nat','base',T,'2050');


Report2('NetTrade',C,'NA',T,RUN)                 = QMX(C,'rest','BASE',T,'2050')*PM0(C,'rest')-QEX(C,'rest','BASE',T,'2050')*PE0(C,'rest');
Report2('ExchangeRate','NA','NA',T,RUN)          = EGX('base',T,'2050');
* Report2('TradeShare',C,'NA',T,RUN)               =(QMX(C,'rest','BASE',T,'2050')*PM0(C,'rest')-QEX(C,'rest','BASE',T,'2050')*PE0(C,'rest'))/sum(A,(QVAX(A,'NAT','BASE',T,'2050')*PVA0(A,'NAT')));


* EMPLOYMENT
Report2('Welfare',C,H,T,RUN)                     = QHX(C,H,'BASE',T,'2050')*PQHX(C,H,'BASE',T,'2050');
Report2('Employment',A,F,T,RUN)                  = QFX(F,A,'NAT','BASE',T,'2050');

Report2('Population','NA',H,T,RUN)               = POP(T) ;
Report2('AveWage',A,F,T,RUN)                     = WFX(F,'BASE',T,'2050')*WFDISTX(F,A,'NAT','BASE',T,'2050');

*Commodities
Report2('ComodityPrices',C,'NA',T,RUN)           = PQX(C,'BASE',T,'2050') ;

* Activities
Report2('ActivityPrices',A,'NA',T,RUN)           = PAX(A,'BASE',T,'2050');


* Government Revenues
Report2('GovDirTax',A,H,T,RUN)                   =  SUM(INSDNG, TINSX(INSDNG,'base',T,'2050')*YIX(INSDNG,'base',T,'2050')) ;
Report2('GovFacTax','NA',F,T,RUN)                = tfx(F,'base',T,'2050')*YFX(F,'base',T,'2050') ;
Report2('GovFacInc',H,F,T,RUN)                   =  SUM(INS, YIFX(INS,F,'Base',T,'2050')) ;
Report2('GovTrnsfr',INS,AC,T,RUN)                =  trnsfrx(INS,AC,'base',T,'2050')*EXRX('base',T,'2050');
Report2('GovActTax',A,'NA',T,RUN)                = TAX(A,'nat','base',T,'2050')*PAX(A,'base',T,'2050')*QAX(A,'base',T,'2050')  ;
Report2('GovVatTax',A,'NA',T,RUN)                = TVAX(A,'nat','base',T,'2050')*PVAX(A,'nat','base',T,'2050')*QVAX(A,'nat','base',T,'2050') ;
Report2('GovImpTax',C,'NA',T,RUN)                = TMX(C,'rest','base',T,'2050')*QMX(C,'rest','base',T,'2050')*PMX(C,'rest','base',T,'2050')*EXRX('base',T,'2050');
Report2('GovExpTax',C,'NA',T,RUN)                = te(C,'rest')*QEX(C,'rest','base',T,'2050')*PEX(C,'rest','base',T,'2050')*EXRX('base',T,'2050');
Report2('GovComTax',C,'NA',T,RUN)                = TQX(C,'base',T,'2050')*PQX(C,'base',T,'2050')*QQX(C,'base',T,'2050')   ;

* co2d,co2m,co2e,utax??

Report2('GovRev',A,H,T,Run)                      = YGX('BASE',T,'2050') ;
Report2('GovExp',A,H,T,RUN)                      = EGX('base',T,'2050');
Report2('GOVSaving','NA','NA',T,RUN)             = GSAVX('BASE',T,'2050')

* Wages


PARAMETER
Report3(*,*,*,T,RUN)
;

Report3('IntDemand',A,C,T,RUN)                  = QINTX(C,A,'base',T,'2050')*PQI0(C,A,'nat') ;
Report3('Imports',C,'NA',T,RUN)                  = QMX(C,'rest','BASE',T,'2050')*PM0(C,'rest');
Report3('Exports',C,'NA',T,RUN)                  = QEX(C,'rest','BASE',T,'2050')*PE0(C,'rest');

Report3('Hcons',C,'NA',T,RUN) =          Sum(H,(QHX(C,H,'BASE',T,'2050')*PQHX(C,H,'BASE',T,'2050')));



SETS
   K_Sectors KLEM sectors / Energy, NonEnergy/

Parameters
K_SAGE(*,K_Sectors,RUN)       KLEM aggregate indicator values
;

* Define KLEM Sectors
* NonEnergy Sectors
K_NonEnergy_c(C) = Yes;
K_NonEnergy_c('ccoal-low') = No;
K_NonEnergy_c('ccoal-hgh') = No;
K_NonEnergy_c('ccoil') = No;
K_NonEnergy_c('cngas') = No;
K_NonEnergy_c('cpetr-d') = No;
K_NonEnergy_c('cpetr-h') = No;
K_NonEnergy_c('cpetr-k') = No;
K_NonEnergy_c('cpetr-l') = No;
K_NonEnergy_c('chydr') = No;
K_NonEnergy_c('celec') = No;

K_NonEnergy_a(A)=Yes;
K_NonEnergy_a('ahydr')=No;
K_NonEnergy_a('aelec')=No;
K_NonEnergy_a('apetr')=No;
K_NonEnergy_a('acoal')=No;



* Energy Sectors
K_Energy_c(C) = Yes;
K_Energy_c(K_NonEnergy_c)=No;

K_Energy_a(A)=Yes ;
K_Energy_a(K_NonEnergy_a(A))=No;


* Define Factors
K_Labour(F)= YES;
K_Labour('fcap')=No;
K_Labour('fegy')=No;
K_Labour('fsas')=No;
K_Labour('fpsa')=No;
K_Labour('fland')=No;

K_Capital(F)=Yes;
K_Capital(K_Labour)=No;
K_Capital('fegy')=No;
K_Capital('fsas')=No;
K_Capital('fpsa')=No;
K_Capital('fland')=No;

K_Land(F)=Yes;
K_Land(K_Labour)=No;
K_Land('fegy')=No;
K_Land('fsas')=No;
K_Land('fpsa')=No;
K_Land('fcap')=No;




K_SAGE('HHconsumption','NonEnergy',Run)            = sum((K_NonEnergy_c,H),PQ0(K_NonEnergy_c)*QH0(K_NonEnergy_c,H));


K_SAGE('HHConsumption','Energy',Run)               = sum((K_Energy_c,H),PQ0(K_Energy_c)*QH0(K_Energy_c,H));
K_SAGE('PublicConsumption','NonEnergy',Run)        =EG0                                        ;


* Exports and Imports
K_SAGE('Imports', 'NonEnergy',Run)               = sum((K_NonEnergy_c,C),sum(RW,QM0(C,RW)*PM0(C,RW))) ;
K_SAGE('Imports', 'Energy',Run)                  = sum((K_Energy_c,C),sum(RW,QM0(C,RW)*PM0(C,RW))) ;
K_SAGE('Exports', 'NonEnergy',Run)               = sum((K_NonEnergy_c,C),sum(RW,QE0(C,RW)*PE0(C,RW))) ;
K_SAGE('Exports', 'Energy',Run)                  = sum((K_Energy_c,C),sum(RW,QE0(C,RW)*PE0(C,RW))) ;

* Calculating Factor Income
* Labour Income
K_SAGE('LabourIncome','NonEnergy',RUN)          = Sum((K_NonEnergy_a,K_labour),WF0(K_labour)*WFDIST0(K_labour,K_NonEnergy_a,'nat'));




$ontext
* Calculate Employment per SATIM sector
REPORT(PRC,'ACTGRP',TC,RUN,'Employment-p') = sum(FS$MPRCFS2(PRC,FS),sum(A$MFSA(FS,A),QFX('flab-p',A,'nat',XC,TC,'2050')));
REPORT(PRC,'ACTGRP',TC,RUN,'Employment-m') = sum(FS$MPRCFS2(PRC,FS),sum(A$MFSA(FS,A),QFX('flab-m',A,'nat',XC,TC,'2050')));
REPORT(PRC,'ACTGRP',TC,RUN,'Employment-s') = sum(FS$MPRCFS2(PRC,FS),sum(A$MFSA(FS,A),QFX('flab-s',A,'nat',XC,TC,'2050')));
REPORT(PRC,'ACTGRP',TC,RUN,'Employment-t') = sum(FS$MPRCFS2(PRC,FS),sum(A$MFSA(FS,A),QFX('flab-t',A,'nat',XC,TC,'2050')));




CPI_SA(T)$Sum((C,H),QHX(C,H,'base',T,'2050')) = Sum((C,H),PQHX(C,H,'base',T,'2050')*QHX(C,H,'base',T,'2050'))/Sum((C,H),QHX(C,H,'base',T,'2050'));

empl_SA(l,A,T) = sum(F$mFl(F,l),QFX(F,A,'nat','base',T,'2050'));

hcons_SA(T) = Sum((C,H),PQHX(C,H,'base',T,'2050')*QHX(C,H,'base',T,'2050'));


hconssf_SA(T) = Sum((FOODC,H),PQHX(FOODC,H,'base',T,'2050')*QHX(FOODC,H,'base',T,'2050'));

hconsnf_SA(T) = hcons_SA(T)-hconssf_SA(T);

swage_SA(A,l,T) = sum(F$mFl(F,l),WFX(F,'base',T,'2050')*WFDISTX(F,A,'nat','base',T,'2050'));

wagebill(F,A,T) = WFX(F,'base',T,'2050')*WFDISTX(F,A,'nat','base',T,'2050')*QFX(F,A,'nat','base',T,'2050');
wagebill2(l,A,T) = sum(F$mFl(F,l),wagebill(F,A,T));

wage_SA(l,T)$sum(A,empl_SA(l,A,T)) = sum(A,wagebill2(l,A,T))/sum(A,empl_SA(l,A,T));
$offtext

execute_unload "Tableau.gdx"

$EXIT

execute_unload "Tableau.gdx" Report2;
execute 'gdxdump Tableau.gdx output=Tableau_00.csv symb=Report2 format=csv header="Indicator,AC,H,Year,Scenario,SATIMGE"';

execute_unload "Tableau.gdx" Report3;
execute 'gdxdump Tableau.gdx output=Tableau_01.csv symb=Report2 format=csv header="Indicator,AC,H,Year,Scenario,SATIMGE"';
$EXIT
