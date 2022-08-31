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

 X                              simulations in eSAGE (CGE)
 XC(X)                          active simulations

 ALLYEAR                        All Years /1850*2200, 0/
 T(ALLYEAR)                     Time periods /2005*2070/
 TT(T)                   SATIM-eSAGE Iterations

* for microsim
l                        labour classes /f-labun, f-labsk/
mFl(F,l)                   Mapping F to l
;

Parameters
* from model
PQHX(C,H,X,T,TT)                 subsidized or taxed price of composite good c
QHX(C,H,X,T,TT)                  qnty consumed of market commodity c by household h
WFX(F,X,T,TT)                    economy-wide wage (rent) for factor f
WFDISTX(F,A,RD,X,T,TT)           factor wage distortion variable
QFSX(F,X,T,TT)                   qnty of factor supply
QFX(F,A,RD,X,T,TT)               qnty demanded of factor f from activity a

* tmp params
wagebill(F,A,T)                    wage bill by factor and activity
wagebill2(l,A,T)                   wage bill by aggregate factors
* for microsim
CPI_SA(T)                           CPI
empl_SA(l,A,T)                      labour demand by category and sector
hcons_SA(T)                         Total household consumption
hconssf_SA(T)                       Total household food consumption
hconsnf_SA(T)                       Total household non-food consumption
swage_SA(A,l,T)                     Sector wage by skill
unemp_SA(T)                         Unemployed population
wage_SA(l,T)                        Aggregate wage

;




*$gdxin  CCDR9GtonJuly.gdx
$gdxin  CCDR8GtonWEPAMJuly.gdx
$load AC,A,C,F,FLAB,FCAP,INS,INSD,INSDNG,H,RD,X,XC,TT

$load PQHX,QHX,WFX,WFDISTX,QFSX,QFX

Sets
FOODC(C)                Food commodities /cawhe, camai, caoce, caveg, caofr, cagra, caoil, catub, capul, caoth,
                                          clani, cmeat, cpfis, cvege, cfats, cdair, cgrai, cstar, cafee, cbake,
                                         csuga, cconf, cpast, cofoo, cbevt/
;

mFl('flab-p','f-labun') = Yes;
mFl('flab-m','f-labun') = Yes;
mFl('flab-s','f-labsk') = Yes;
mFl('flab-t','f-labsk') = Yes;


CPI_SA(T)$Sum((C,H),QHX(C,H,'base',T,'2050')) = Sum((C,H),PQHX(C,H,'base',T,'2050')*QHX(C,H,'base',T,'2050'))/Sum((C,H),QHX(C,H,'base',T,'2050'));

empl_SA(l,A,T) = sum(F$mFl(F,l),QFX(F,A,'nat','base',T,'2050'));

hcons_SA(T) = Sum((C,H),PQHX(C,H,'base',T,'2050')*QHX(C,H,'base',T,'2050'));

hconssf_SA(T) = Sum((FOODC,H),PQHX(FOODC,H,'base',T,'2050')*QHX(FOODC,H,'base',T,'2050'));

hconsnf_SA(T) = hcons_SA(T)-hconssf_SA(T);

swage_SA(A,l,T) = sum(F$mFl(F,l),WFX(F,'base',T,'2050')*WFDISTX(F,A,'nat','base',T,'2050'));

wagebill(F,A,T) = WFX(F,'base',T,'2050')*WFDISTX(F,A,'nat','base',T,'2050')*QFX(F,A,'nat','base',T,'2050');
wagebill2(l,A,T) = sum(F$mFl(F,l),wagebill(F,A,T));

wage_SA(l,T)$sum(A,empl_SA(l,A,T)) = sum(A,wagebill2(l,A,T))/sum(A,empl_SA(l,A,T));
