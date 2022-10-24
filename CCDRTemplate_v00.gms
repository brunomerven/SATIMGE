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
 MY(T)                   Milestone years / 2022, 2030, 2040, 2050/

 CCDRIndicators / GDP, GDPGrowth, GDPperCapitaGrowth, GDPperCapita, HouseholdCons,
                 PrivateCons, GovCons, PrivateInv, GovInv, NetExports,
                 QVAAgri, QVAIndustry, QVAServices, ExchangeRate,
                 FiscalRevenue, FiscalExpenditure, BudgetDeficit, Emissions, EmissionsperGDP/

 RUN /NZ_9, NZ_9_PAM, NZ_9_WE, NZ_9_PAM_WE, NZ_8, NZ_8_PAM_WE, NZ_8_HiFS, NZ_8_CO2Tax/

* for microsim
l                        labour classes /f-labun, f-labsk/
mFl(F,l)                   Mapping F to l


;

Parameters
* from model
PQHX(C,H,X,T,TT)                 subsidized or taxed price of composite good c
PQX(C,X,T,TT)                 pre-subsidized or taxed price of composite good c

QHX(C,H,X,T,TT)                  qnty consumed of market commodity c by household h
WFX(F,X,T,TT)                    economy-wide wage (rent) for factor f
WFDISTX(F,A,RD,X,T,TT)           factor wage distortion variable
QFSX(F,X,T,TT)                   qnty of factor supply
QFX(F,A,RD,X,T,TT)               qnty demanded of factor f from activity a

QEX(C,RW,X,T,TT)                 qnty of exports
QMX(C,RW,X,T,TT)                 qnty of imports
PEX(C,RW,X,T,TT)                 price of exports
PMX(C,RW,X,T,TT)                 price of imports
EXRX(X,T,TT)                     exchange rate
EGX(X,T,TT)                      total current government expenditure

GVA_FS(FS,T)                     SATIM Sector GVA
GDP_RUN(T)                          GDP Projection for RUN
POP(T)                              Population Projection
QGX(C,X,T,TT)                       qnty of government consumption
GSAVX(X,T,TT)                       government savings
QVAX(A,RD,X,T,TT)                   qnty of aggregate value added
YGX(X,T,TT)                         total current government income
MPSX(INS,X,T,TT)                    marginal propensity to save for dom non-gov inst
TINSX(INS,X,T,TT)                   rate of direct tax on domestic institutions
YIX(INS,X,T,TT)                     income of domestic non-governmental institutions

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
Report(CCDRIndicators,T,RUN)             Indicators for Template

EXR2019                              2019 Exchange Rate ZAR per USD
CO2eq(T,RUN)                         CO2 eq from SATIM

MYGAP(MY)                            Gaps between years (growth calc)
;
*$gdxin  CCDR9GtonJuly.gdx
$gdxin  CCDR_Runs\NZ_9.gdx
$load AC,A,C,F,FLAB,FCAP,INS,INSD,INSDNG,H,RD,X,XC,TT,RW,FS

Sets
FOODC(C)                Food commodities /cawhe, camai, caoce, caveg, caofr, cagra, caoil, catub, capul, caoth,
                                          clani, cmeat, cpfis, cvege, cfats, cdair, cgrai, cstar, cafee, cbake,
                                         csuga, cconf, cpast, cofoo, cbevt/
;

EXR2019 = 14.436;
$call   "gdxxrw i=CCDR_Runs\CO2eq.xlsx o=CCDR_Runs\CO2eq index=index!a6 checkdate"
$gdxin  CCDR_Runs\CO2eq.gdx
$load CO2eq

mFl('flab-p','f-labun') = Yes;
mFl('flab-m','f-labun') = Yes;
mFl('flab-s','f-labsk') = Yes;
mFl('flab-t','f-labsk') = Yes;

File Scen;


MYGAP('2030') = 2030-2022;
MYGAP('2040') = 2040-2030;
MYGAP('2050') = 2050-2040;


LOOP(RUN,

put_utilities Scen 'gdxin' / "CCDR_Runs\",RUN.TL:50;
execute_load GDP_RUN,POP,QGX,EGX,GSAVX,QVAX,YGX,MPSX,TINSX,YIX,PQHX,PQX,QHX,WFX,WFDISTX,QFSX,QFX,QEX,PEX,QMX,PMX,GVA_FS,EXRX;

* HouseholdCons,
*                 , , ,
*                 , , , ,
*                 , ,

Report('GDP',T,RUN) = GDP_RUN(T);

GDPperCapita(T)$POP(T) = GDP_RUN(T)/POP(T);
* note we're using GDP at factor costs real = GVA for GDP
LOOP(MY,
Report('GDPGrowth',MY,RUN)$GDP_RUN(MY-1) = ((GDP_RUN(MY)/GDP_RUN(MY-1))**(1/MYGAP(MY))-1)*100;
Report('GDPperCapitaGrowth',MY,RUN)$GDPperCapita(MY-1) = ((GDPperCapita(MY)/GDPperCapita(MY-1))**(1/MYGAP(MY))-1)*100;
*end of MY loop
);
* USD per capita
Report('GDPperCapita',T,RUN) = GDPperCapita(T)*1000000/EXR2019;
* USD per capita. Using 2019 prices for now. This may have to reviewed since prices are real throughout the period?
Report('HouseholdCons',T,RUN)$POP(T) = SUM((C,H),PQHX(C,H,'base','2019','2050')*QHX(C,H,'base',T,'2050'))/POP(T)*1000000/EXR2019;

Report('PrivateCons',T,RUN)$GDP_RUN(T) = SUM((C,H),PQHX(C,H,'base','2019','2050')*QHX(C,H,'base',T,'2050'))/GDP_RUN(T)*100;
Report('GovCons',T,RUN)$GDP_RUN(T) = SUM(C,PQX(C,'base','2019','2050')*QGX(C,'base',T,'2050'))/GDP_RUN(T)*100;

Report('PrivateInv',T,RUN)$GDP_RUN(T) = SUM(INSDNG,MPSX(INSDNG,'base',T,'2050')*(1-tinsx(INSDNG,'base',T,'2050'))*YIX(INSDNG,'base',T,'2050'))/GDP_RUN(T)*100;
Report('GovInv',T,RUN)$GDP_RUN(T) = GSAVX('base',T,'2050')/GDP_RUN(T)*100;

Report('NetExports',T,RUN)$GDP_RUN(T) = SUM(C,QEX(C,'rest','base',T,'2050')*PEX(C,'rest','base',T,'2050')-QMX(C,'rest','base',T,'2050')*PMX(C,'rest','base',T,'2050'))/GDP_RUN(T)*100;

Report('QVAAgri',T,RUN)$GDP_RUN(T) = GVA_FS('agr',T)/GDP_RUN(T)*100;
Report('QVAServices',T,RUN)$GDP_RUN(T) = GVA_FS('COM',T)/GDP_RUN(T)*100;
Report('QVAIndustry',T,RUN)$GDP_RUN(T) = (GDP_RUN(T)-GVA_FS('agr',T)-GVA_FS('COM',T))/GDP_RUN(T)*100;

Report('ExchangeRate',T,RUN) = EXRX('base',T,'2050');

Report('FiscalRevenue',T,RUN)$GDP_RUN(T) = YGX('base',T,'2050')/GDP_RUN(T)*100;
Report('FiscalExpenditure',T,RUN)$GDP_RUN(T) = EGX('base',T,'2050')/GDP_RUN(T)*100;

Report('BudgetDeficit',T,RUN)$GDP_RUN(T) = GSAVX('base',T,'2050')/GDP_RUN(T)*100;

Report('Emissions',T,RUN) = CO2eq(T,RUN);
Report('EmissionsperGDP',T,RUN)$GDP_RUN(T) = CO2eq(T,RUN)/GDP_RUN(T)*1000;

* end of RUN loop
);

$ontext
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
