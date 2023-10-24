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
 IT(AC)                  Investment demand categories
 RUN                     simulations
 FS                      TIMES economic sectors
 X                              simulations in eSAGE (CGE)
 XC(X)                          active simulations
 energy(C)


 ALLYEAR                        All Years /1850*2200, 0/
 T(ALLYEAR)                     Time periods /2019*2055/
 TT(T)                   SATIM-eSAGE Iterations
 T1(ALLYEAR)             base year /2019/
 CCDRIndicators / GDPGrowth, GDPperCapitaGrowth, GDPperCapita, HouseholdCons,
                 PrivateCons, GovCons, PrivateInv, GovInv, NetExports,
                 QVAAgri, QVAIndustry, QVAServices, ExchangeRate,
                 FiscalRevenue, FiscalExpenditure, BudgetDeficit, Emissions, EmissionsperGDP, Deficit/


* RUN /NZ_9, NZ_9_PAM, NZ_9_WE, NZ_9_PAM_WE, NZ_8, NZ_8_PAM_WE, NZ_8_HiFS, NZ_8_CO2Tax/
  RUN /8_GT/
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
QF0(F,A,RD)                      quantity demanded of factor f from activity a
SAM(AC,AC)
STAX(AC)
Mtax(AC)
PA0(A)
PQIX(A,C,RD,X,T,TT)              subsidised or taxed price of composite goods
QINT0(C,A)
TAX(A,RD,X,T,TT)

QHX(C,H,X,T,TT)                  qnty consumed of market commodity c by household h
WFX(F,X,T,TT)                    economy-wide wage (rent) for factor f
WF0(F)
WFDISTX(F,A,RD,X,T,TT)           factor wage distortion variable
WFDIST0(F,A,RD)
QFSX(F,X,T,TT)                   qnty of factor supply
QFX(F,A,RD,X,T,TT)               qnty demanded of factor f from activity a
PQH0(C,H)
QINVX(C,IT,X,T,TT)
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
TFPGR(A,RD,X,T)
QINV0(C,IT)                       quantitiy of fixed investment demand
INVSHR2(F,A,RD)                   investment share by sector for each capital type

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
PVAX(A,RD,X,T,TT)                   value added price
PARX(A,RD,X,T,TT)                   output price of activity
QARX(A,RD,X,T,TT)                   level of domestic activity
TMX(C,RW,X,T,TT)                    import tax
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
HHCons(C,T)
GovCons(C,T)
Inv(C,T)
Expt(C,T)
Imp(C,T)
GDP(C,T)
LS(T)


* for CCDR template
*Report(CCDRIndicators,T,RUN)             Indicators for Template
Report(*,T,RUN)             Indicators for Template



EXR2019                              2019 Exchange Rate ZAR per USD
CO2eq(T,RUN)                         CO2 eq from SATIM
;

* $gdxin  test8Gt3iter2-hr
* $gdxin  test9Gt3iter2-hr
$gdxin gdxs\IMGrun_99_20Oct


$load AC,A,C,F,FLAB,FCAP,INS,INSD,INSDNG,H,RD,X,XC,TT,RW,FS,SAM,IT,FLND,energy,TAX

$include KLEM_Report.inc

* $gdxin  test8Gt3iter2-hr
* $gdxin  test9Gt3iter2-hr
$gdxin gdxs\IMGrun_99_20Oct

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
$load GDP_RUN,POP,QGX,EGX,GSAVX,QVAX,PVA0,YGX,MPSX,TINSX,YIX,PQHX,PQX,QHX,WFX,WFDISTX,WFDIST0,QFSX,QFX,QEX
$load PEX,QMX,PMX,GVA_FS,EXRX,PM0,PE0,QE0,PAX,QAX,YIFX,trnsfrx,PARX,QARX,TVAX,PVAX,TMX,te,TQX,QQX,TFX,YFX,
$load TVA0,QINTX,PQI0,QH0,PQ0,EG0,QM0,WF0,QF0,PA0,PQIX,PQH0, QINVX, TFPGR, INVSHR2

GDPperCapita(T)$POP(T) = GDP_RUN(T)/POP(T);

alias(A,AA)

parameter
K_BUinfo(*,K_indicators,T,RUN)
K_ExoData(*,T,Run)
K_Results(*,T,RUN)
K_BUenergy(*,*,C,T)        ;


K_BUinfo('ImportE','Value',T,Run)               =   sum(K_Energy_c,QMX(K_Energy_c,'rest','base',T,'2055')*PM0(K_Energy_c,'rest'))*1000 ;
K_BUinfo('ExportsE','Value',T,Run)               =   sum(K_Energy_c,QEX(K_Energy_c,'rest','base',T,'2055')*PE0(K_Energy_c,'rest'))*1000 ;
K_BUinfo('NonEnergyE','Value',T,RUN)              = sum((K_Energy_c,K_NonEnergy_a),QINTX(K_Energy_c,K_NonEnergy_a,'base',T,'2055')*PQI0(K_Energy_c,K_NonEnergy_a,'nat'))*1000;
K_BUinfo('EnergyE','Value',T,RUN)              = sum((K_Energy_c,K_Energy_a),QINTX(K_Energy_c,K_Energy_a,'base',T,'2055')*PQI0(K_Energy_c,K_Energy_a,'nat'))*1000 ;
K_BUinfo('hhdE','Value',T,RUN)                   = sum((K_Energy_c,H),QHX(K_Energy_c,H,'base',T,'2055')*PQH0(K_Energy_c,H))*1000 ;


K_BUinfo('ImportE','Quantity',T,Run)               =   sum(K_Energy_c,QMX(K_Energy_c,'rest','base',T,'2055')) ;
K_BUinfo('ExportsE','Quantity',T,Run)               =   sum(K_Energy_c,QEX(K_Energy_c,'rest','base',T,'2055')) ;
K_BUinfo('NonEnergyE','Quantity',T,RUN)              = sum((K_Energy_c,K_NonEnergy_a),QINTX(K_Energy_c,K_NonEnergy_a,'base',T,'2055'));
K_BUinfo('EnergyE','Quantity',T,RUN)                = sum((K_Energy_c,K_Energy_a),QINTX(K_Energy_c,K_Energy_a,'base',T,'2055')) ;
K_BUinfo('hhdE','Quantity',T,RUN)                   = sum((K_Energy_c,H),QHX(K_Energy_c,H,'base',T,'2055')) ;

K_BUenergy('ImportE','Quantity',c,T)$energy(C)    =   QMX(C,'rest','base',T,'2055') ;
K_BUenergy('ExportsE','Quantity',C,T)$energy(C)     =   QEX(C,'rest','base',T,'2055') ;
K_BUenergy('NonEnergyE','Quantity',C,T)$energy(C)   = sum(K_NonEnergy_a,QINTX(C,K_NonEnergy_a,'base',T,'2055'));
K_BUenergy('EnergyE','Quantity',C,T)$energy(C)       = sum(K_Energy_a,QINTX(C,K_Energy_a,'base',T,'2055')) ;
K_BUenergy('hhdE','Quantity',C,T)$energy(C)           = sum(H,QHX(C,H,'base',T,'2055')) ;

K_BUenergy('ImportE','Price',c,T)$energy(C)    =   PM0(C,'rest')*1000 ;
K_BUenergy('ExportsE','Price',C,T)$energy(C)     =   PE0(C,'rest')*1000  ;
K_BUenergy('NonEnergyE','Price',C,T)$energy(C)   = sum(K_NonEnergy_a,PQI0(C,K_NonEnergy_a,'nat'))*1000;
K_BUenergy('EnergyE','Price',C,T)$energy(C)       = sum(K_Energy_a,PQI0(C,K_Energy_a,'nat'))*1000  ;
K_BUenergy('hhdE','Price',C,T)$energy(C)           = sum(H,PQH0(C,H))*1000 ;


K_BUenergy('ImportE','Value',c,T)$energy(C)    =   QMX(C,'rest','base',T,'2055')*PM0(C,'rest')*1000 ;
K_BUenergy('ExportsE','Value',C,T)$energy(C)     =   QEX(C,'rest','base',T,'2055')*PE0(C,'rest')*1000  ;
K_BUenergy('NonEnergyE','Value',C,T)$energy(C)   = sum(K_NonEnergy_a,QINTX(C,K_NonEnergy_a,'base',T,'2055')*PQI0(C,K_NonEnergy_a,'nat'))*1000;
K_BUenergy('EnergyE','Value',C,T)$energy(C)       = sum(K_Energy_a,QINTX(C,K_Energy_a,'base',T,'2055')*PQI0(C,K_Energy_a,'nat'))*1000  ;
K_BUenergy('hhdE','Value',C,T)$energy(C)           = sum(H,QHX(C,H,'base',T,'2055')*PQH0(C,H))*1000 ;




K_BUinfo('ImportE','Price',T,Run)               =   sum(K_Energy_c,PM0(K_Energy_c,'rest')) ;
K_BUinfo('ExportsE','Price',T,Run)               =   sum(K_Energy_c,PE0(K_Energy_c,'rest')) ;
K_BUinfo('NonEnergyE','Price',T,RUN)              = sum((K_Energy_c,K_NonEnergy_a),PQI0(K_Energy_c,K_NonEnergy_a,'nat'));
K_BUinfo('EnergyE','Price',T,RUN)                = sum((K_Energy_c,K_Energy_a),PQI0(K_Energy_c,K_Energy_a,'nat')) ;
K_BUinfo('hhdE','Price',T,RUN)                   = sum((K_Energy_c,H),PQH0(K_Energy_c,H)) ;

K_BUinfo('ImportE2','Price',T,Run)               =   sum(K_Energy_c,PMX(K_Energy_c,'rest','base',T,'2055')) ;
K_BUinfo('ExportsE2','Price',T,Run)               =   sum(K_Energy_c,PEX(K_Energy_c,'rest','base',T,'2055')) ;
*Intrum(A,C,T,RUN) =                               = sum(X,PQIX(K_Energy_c,K_Energy_a,'nat','base',T,'2055'))
*K_BUinfo('NonEnergyE2','Price',T,RUN)              = sum((K_Energy_c,K_NonEnergy_a),sum(RD,PQIX(K_Energy_c,K_NonEnergy_a,'nat','base',T,'2055')));
*K_BUinfo('EnergyE2','Price',T,RUN)                = sum((K_Energy_c,K_Energy_a),PQIX(K_Energy_c,K_Energy_a,'nat','base',T,'2055')) ;
K_BUinfo('hhdE2','Price',T,RUN)                   = sum((K_Energy_c,H),PQHX(K_Energy_c,H,'base',T,'2055')) ;


K_BUinfo('ImportNE','Value',T,Run)               =   sum(K_NonEnergy_c,QMX(K_NonEnergy_c,'rest','base',T,'2055')*PM0(K_NonEnergy_c,'rest'))*1000 ;
K_BUinfo('ExportsNE','Value',T,Run)               =   sum(K_NonEnergy_c,QEX(K_NonEnergy_c,'rest','base',T,'2055')*PE0(K_NonEnergy_c,'rest'))*1000 ;
K_BUinfo('NonEnergyNE','Value',T,RUN)              = sum((K_NonEnergy_c,K_NonEnergy_a),QINTX(K_NonEnergy_c,K_NonEnergy_a,'base',T,'2055')*PQI0(K_NonEnergy_c,K_NonEnergy_a,'nat'))*1000;
K_BUinfo('EnergyNE','Value',T,RUN)                = sum((K_NonEnergy_c,K_Energy_a),QINTX(K_NonEnergy_c,K_Energy_a,'base',T,'2055')*PQI0(K_NonEnergy_c,K_Energy_a,'nat'))*1000 ;
K_BUinfo('hhdNE','Value',T,RUN)                   = sum((K_NonEnergy_c,H),QHX(K_NonEnergy_c,H,'base',T,'2055')*PQH0(K_NonEnergy_c,H))*1000 ;
K_BUinfo('GovNE','Value',T,RUN)                   = sum(C,QGX(C,'base',T,'2055')*PQ0(C))*1000 ;
K_BUinfo('InvNE','Value',T,RUN)                   = sum((K_NonEnergy_c,IT),QINVX(K_NonEnergy_c,IT,'base',T,'2055')*PQ0(K_NonEnergy_c))*1000 ;

K_BUinfo('FlabNE','Value',T,Run)                =   sum((K_NonEnergy_a,FLAB),QFX(FLAB,K_NonEnergy_a,'nat','base',T,'2055')*PA0(K_NonEnergy_a))*1000 ;
K_BUinfo('FlabE','Value',T,Run)                =   sum((K_Energy_a,FLAB),QFX(FLAB,K_Energy_a,'nat','base',T,'2055')*PA0(K_Energy_a))*1000 ;
K_BUinfo('FcapNE','Value',T,Run)                =   sum((K_NonEnergy_a,FCAP),QFX(FCAP,K_NonEnergy_a,'nat','base',T,'2055')*PA0(K_NonEnergy_a))*1000 ;
K_BUinfo('FcapE','Value',T,Run)                =   sum((K_Energy_a,FCAP),QFX(FCAP,K_Energy_a,'nat','base',T,'2055')*PA0(K_Energy_a))*1000 ;
K_BUinfo('FlandNE','Value',T,Run)                =   sum((K_NonEnergy_a,Flnd),QFX(Flnd,K_NonEnergy_a,'nat','base',T,'2055')*PA0(K_NonEnergy_a))*1000 ;
K_BUinfo('FlandE','Value',T,Run)                =   sum((K_Energy_a,Flnd),QFX(Flnd,K_Energy_a,'nat','base',T,'2055')*PA0(K_Energy_a))*1000 ;

K_BUinfo('AtaxNE','Value',T,Run)                =   sum(K_NonEnergy_a,QAX(K_NonEnergy_a,'base',T,'2055')*PA0(K_NonEnergy_a)*TAX(K_NonEnergy_a,'nat','base',T,'2055'))*1000 ;
K_BUinfo('AtaxE','Value',T,Run)                =   sum(K_Energy_a,QAX(K_Energy_a,'base',T,'2055')*PA0(K_Energy_a)*TAX(K_Energy_a,'nat','base',T,'2055'))*1000 ;


HHCons(C,T)   =  Sum(H,QHX(C,H,'BASE',T,'2055')*PQX(C,'base',T,'2055'));
GovCons(C,T)  =  QGX(C,'BASE',T,'2055')*PQX(C,'base',T,'2055');
Inv(C,T)      = sum(IT,QINVX(C,IT,'base',T,'2055')*PQX(C,'base',T,'2055')) ;
Expt(C,T)     = QMX(C,'rest','BASE',T,'2055')*PMX(C,'rest','base',T,'2055');
Imp(C,T)      = QEX(C,'rest','BASE',T,'2055')*PEX(C,'rest','base',T,'2055') ;
GDP(C,T)      = HHCons(C,T)+ GovCons(C,T)+ Inv(C,T) + Expt(C,T) - Imp(C,T) ;
LS(T)         =sum((FLAB,A),QFX(FLAB,A,'nat','base',T,'2055'))                   ;

K_Results('RealGDP',T,RUN)                  = sum(A,PVA0(A,'nat')*(1-TVA0(A,'nat'))*QVAX(A,'nat','base',T,'2055'));
K_Results('NEoutput',T,Run)                 = sum((K_NonEnergy_c,A),QINTX(K_NonEnergy_c,A,'base',T,'2055')*PQI0(K_NonEnergy_c,A,'nat'))*1000;
K_Results('Energyoutput',T,Run)             = sum((K_Energy_c,A),QINTX(K_Energy_c,A,'base',T,'2055')*PQI0(K_Energy_c,A,'nat'))*1000;
K_Results('NEconsumption',T,RUN)            = sum((K_NonEnergy_c,H),QHX(K_NonEnergy_c,H,'base',T,'2055')*PQH0(K_NonEnergy_c,H))*1000 ;
K_Results('EnergyConsumption',T,RUN)        = sum((K_Energy_c,H),QHX(K_Energy_c,H,'base',T,'2055')*PQH0(K_Energy_c,H))*1000 ;
K_Results('Investment',T,RUN)               = sum((C,IT),QINVX(C,IT,'base',T,'2055')*PQX(C,'base',T,'2055'));
K_Results('RatiowpK',T,Run)                 =sum((FLAB,A),WFX(FLAB,'base',T,'2055')*QFX(FLAB,A,'nat','base',T,'2055'))/sum((FCAP,A),WFX(FCAP,'base',T,'2055')*QFX(FCAP,A,'nat','base',T,'2055'))  ;
K_Results('Capital',T,Run)                  =sum((FCAP,A),WFX(FCAP,'base',T,'2055')*QFX(FCAP,A,'nat','base',T,'2055'))     ;



K_ExoData('TFPGR',T,Run)  =    sum(A,TFPGR(A,'nat','base',T)) ;
K_Exodata('fp',T,Run) = sum(A,QVAX(A,'nat','base',T,'2055')) ;
K_ExoData('TFP',T,Run) = sum(A,TFPGR(A,'nat','base',T)*QVAX(A,'nat','base',T,'2055'))  ;
K_Exodata('tradebalance',T,Run)  =  sum(C,QEX(C,'rest','BASE',T,'2055')*PE0(C,'rest')-QMX(C,'rest','BASE',T,'2055')*PM0(C,'rest'))/sum(C,GDP(C,T));
K_Exodata('Labour',T,Run)      =   LS(T)     ;
K_Exodata('Pop',T,Run)      = POP(T)       ;


*K_ExoData('etax',T,Run)= TAX(K_energy_a,'nat','base',T,'2055')

* Non-energy output
* None-energy output
* Non-energy household consumption
* energy household consumption
* volume of investment
* Ratio of w to pk
* Capital stock
* labour productivity


execute_unload "KLEMdata.gdx" K_BUinfo K_Results K_ExoData K_BUenergy;
execute 'gdxdump KLEMdata.gdx output=KLEMdata_00.csv symb=K_BUinfo format=csv header="Indicator,AC,H,Year,Scenario,SATIMGE"';

