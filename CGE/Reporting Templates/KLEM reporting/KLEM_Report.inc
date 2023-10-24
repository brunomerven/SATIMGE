
$ontext
Description:     Klem parameter calculation from SAGE
Athour:          Julia Tatham
Date:            20/01/2023
$offtext

SETS
K_sectors
KLEM(K_sectors,AC)


K_Energy_c(C)      KLEM Energy Sectors
K_NonEnergy_c(C)   KLEM Non-Energy Sectors
K_Energy_a(A)      KLEM Energy Sectors
K_NonEnergy_a(A)   KLEM Non-Energy Sectors

K_sect / ImportE, ExportsE, NonEnergyE, EnergyE, hhdE  /
K_Indicators /Value, Quantity, Price /
;




* Defining Energu and Non Energy Sectors
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
K_NonEnergy_a('angas')=No;

* Energy Sectors
K_Energy_c(C) = Yes;
K_Energy_c(K_NonEnergy_c)=No;

K_Energy_a(A)=Yes ;
K_Energy_a(K_NonEnergy_a(A))=No;

* Generating an Aggregated SAM for KLEM
$SETGLOBAL map KLEM_Map.xlsx"
$call "gdxxrw i=KLEM_Map.xlsx o=KLEM_map.gdx index=index!a6 checkdate"
$gdxin KLEM_map.gdx
$load K_sectors KLEM

alias(*,u);
file ordered /ordered.txt/;
loop(SortedUels(u,K_sectors), put ordered K_sectors.tl:0 '  ');
putclose ordered;


alias(K_Sectors,K),(AC,AACC)

Parameters
K_SAM(K_Sectors,K)
K_SAM2(*,*)
*K_BUinfo(K_sect,K_indicators,T,RUN)
;


K_SAM(K_sectors,K) =                       sum((ac,aacc)$((KLEM(K_sectors,AC))*KLEM(K,AACC)),sam(AC,AACC))*1000  ;





$ontext
*K_BUinfo('Import','Price',T,Run)                 =   sum(K_Energy_c,sum((RW,X),PMX(K_Energy_c,'rest','base',T,'2050')))        ;

*K_BUinfo('Exports','Value',T,Run)               =   sum(K_Energy_c,sum((RW,X),QEX(K_Energy_c,'rest','base',T,'2050')*PEX(K_Energy_c,'rest','base',T,'2050'))) ;
*K_BUinfo('Exports','Quantity',T,Run)            =   sum(K_Energy_c,sum((RW,X),QEX(K_Energy_c,'rest','base',T,'2050')))     ;
*K_BUinfo('Exports','Price',T,Run)               =   sum(K_Energy_c,sum((RW,X),PEX(K_Energy_c,'rest','base',T,'2050')))        ;


K_BUinfo('NonEnergy','Quantity',T,RUN) =                 sum((K_Energy_c,K_NonEnergy_a),QINTX(K_Energy_c,K_NonEnergy_a,'base',T,'2050'))     ;
K_BUinfo('Energy','Quantity',T,RUN) =                    sum((K_Energy_c,K_Energy_a),QINTX(K_Energy_c,K_Energy_a,'base',T,'2050'))     ;
K_BUinfo('Import','Quantity',T,Run) =                    sum(K_Energy_c,QMX(K_Energy_c,'rest','base',T,'2050'))     ;
K_BUinfo('Exports','Quantity',T,Run) =                   sum(K_Energy_c,QEX(K_Energy_c,'rest','base',T,'2050'))    ;
K_BUinfo('hhd','Quantity',T,Run) =                       sum((K_Energy_c,H),QHX(K_Energy_c,H,'base',T,'2050'))    ;




*K_BUinfo('NonEnergy','Price',T,RUN) =                  sum((K_NonEnergy_c,K_NonEnergy_a),PQIX(C,A,'nat','base',T,'2050'))     ;

*K_BUinfo('Energy','PRice',T,RUN) =                    sum((K_Energy_c,K_Energy_a),QINTX(K_Energy_c,K_Energy_a,'base',T,'2050'))     ;





* K_BUinfo('Energy','Value',T,Run)               =   sum((K_Energy_c,K_Energy_a),QINTX(K_Energy_c,K_Energy_a,'base',T,'2050')*PQIX(K_Energy_c,K_Energy_a,'base',T,'2050')) ;
* K_BUinfo('Value','Quantity',T,Run)            =   sum(K_Energy_c,sum((RW,X),QMX(K_Energy_c,'rest','base',T,'2050')))     ;
* K_BUinfo('Value','Price',T,Run)                =   sum(K_Energy_c,sum((RW,X),PMX(K_Energy_c,'rest','base',T,'2050')))        ;

* K_SAGE('Imports', 'NonEnergy',Run)               = sum((K_NonEnergy_c,C),sum(RW,QM0(C,RW)*PM0(C,RW))) ;
*K_SAGE('Rent','Energy',RUN)                      =Sum((K_Energy_a,K_Land),WF0(K_Land)*WFDIST0(K_Land,K_Energy_a,'nat')*QF0(K_Land,K_Energy_a,'nat'));

execute_unload "Report_Klem.gdx" K_SAM;
execute 'gdxdump Report_Klem.gdx output=Report_Klem.csv symb=K_SAM format=csv';


* Generating Price information
*K_BUinfo('Imports','Value',TC,Run)               =   sum((K_Energy_c,C),QMX(K_Energy_c,'rest','base',T,'2050')*PMX(K_Energy_c,'rest','base',T,'2050))



K_SAGE('HHconsumption','NonEnergy',Run)            = sum((K_NonEnergy_c,H),PQ0(K_NonEnergy_c)*QH0(K_NonEnergy_c,H));
K_SAGE('HHConsumption','Energy',Run)               = sum((K_Energy_c,H),PQ0(K_Energy_c)*QH0(K_Energy_c,H));
K_SAGE('PublicConsumption','NonEnergy',Run)        =EG0                                        ;


* Exports and Imports
K_SAGE('Imports', 'NonEnergy',Run)               = sum((K_NonEnergy_c,C),sum(RW,QM0(C,RW)*PM0(C,RW))) ;
K_SAGE('Imports', 'Energy',Run)                  = sum((K_Energy_c,C),sum(RW,QM0(C,RW)*PM0(C,RW))) ;
K_SAGE('Exports', 'NonEnergy',Run)               = sum((K_NonEnergy_c,C),sum(RW,QE0(C,RW)*PE0(C,RW))) ;
K_SAGE('Exports', 'Energy',Run)                  = sum((K_Energy_c,C),sum(RW,QE0(C,RW)*PE0(C,RW))) ;

* Calculating Factor Income
K_SAGE('LabourIncome','NonEnergy',RUN)           = Sum((K_NonEnergy_a,K_labour),WF0(K_labour)*WFDIST0(K_labour,K_NonEnergy_a,'nat')*QF0(K_labour,K_NonEnergy_a,'nat'));
K_SAGE('LabourIncome','Energy',RUN)              = Sum((K_Energy_a,K_labour),WF0(K_labour)*WFDIST0(K_labour,K_Energy_a,'nat')*QF0(K_labour,K_Energy_a,'nat'));
K_SAGE('CapitalIncome','NonEnergy',RUN)          =Sum((K_NonEnergy_a,K_Capital),WF0(K_Capital)*WFDIST0(K_Capital,K_NonEnergy_a,'nat')*QF0(K_Capital,K_NonEnergy_a,'nat'));
K_SAGE('CapitalIncome','Energy',RUN)             =Sum((K_Energy_a,K_Capital),WF0(K_Capital)*WFDIST0(K_Capital,K_Energy_a,'nat')*QF0(K_Capital,K_Energy_a,'nat'));
K_SAGE('Rent','NonEnergy',RUN)                   =Sum((K_NonEnergy_a,K_Land),WF0(K_Land)*WFDIST0(K_Land,K_NonEnergy_a,'nat')*QF0(K_Land,K_NonEnergy_a,'nat'));
K_SAGE('Rent','Energy',RUN)                      =Sum((K_Energy_a,K_Land),WF0(K_Land)*WFDIST0(K_Land,K_Energy_a,'nat')*QF0(K_Land,K_Energy_a,'nat'));

* Taxes


* Energy Export and Import Prices
K_BUinfo('EnergyImports',T, RUN)                 = sum((K_Energy_c,C),QMX(K_Energy_c,'rest','BASE',T,'2050')*PM0(K_Energy_c,'rest'))   ;
K_BUinfo('QEnergyImports',T, RUN)                 = sum((K_Energy_c,C),QMX(K_Energy_c,'rest','BASE',T,'2050'))   ;
K_BUinfo('PEnergyImports',T, RUN)                 = sum((K_Energy_c,C),PMX(K_Energy_c,'rest','base',T,'2050'))   ;
K_BUinfo('EnergyExports',T, RUN)                 = sum((K_Energy_c,C),QEX(K_Energy_c,'rest','BASE',T,'2050')*PE0(K_Energy_c,'rest'))   ;
K_BUinfo('QEnergyExports',T, RUN)                 = sum((K_Energy_c,C),QEX(K_Energy_c,'rest','BASE',T,'2050'))   ;
K_BUinfo('PEnergyExports',T, RUN)                 = sum((K_Energy_c,C),PEX(K_Energy_c,'rest','base',T,'2050'))   ;

$offtext
