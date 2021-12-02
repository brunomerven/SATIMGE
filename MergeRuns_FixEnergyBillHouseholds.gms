* This code is used to stitch results from multiple gdx files into 1
SETS
* Overall sets
  RUN                            simulations
  AY                        All Years /1850*2200, 0/
  T(AY)                     Time periods /2005*2070/
  TC(T)                   eSAGE active time periods
  TC2(T)                  /2025*2050/
  TC2_1(T) /2025/
  TC3(T)
  PRC                            TIMES Processes
  COM                            TIMES Commodities
  COMRES(COM) Residential sector commodities /RESBIW, RESCOA, RESGAS, RESOKE, RESOLP, RESELC/
  Indicators SATIM indicators /Activity, Capacity, NewCapacity, CapFac, FlowIn, FlowOut, AnnInvCost, FOM, VOM, FuelCosts, Marginals, Levies, ExternalityCosts, CO2Tax, CO2, CO2C, CH4, N2O, CF4, C2F6, CO2eq, FlowInMt, Investment,Price, GVA, Population, Consumption, Employment-p, Employment-m,Employment-s,Employment-t,PalmaRatio,20-20Ratio,TradeDeficit,Imports,Exports,pkm, tkm/
  Sector
  SubSector
  PRCRCAP(PRC)
  MPRCSubSector(PRC,Sector,SubSector)          Map for PRC to subsectors
;
*$onExternalOutput
Parameters
  REPORT_RUN(PRC,COM,AY,Indicators) REPORT of indicators by run and process and commodity for each run
  REPORTM(PRC,COM,AY,RUN,Indicators) Merged Report
  INCLRUN(RUN)                   whether to include or not RUN in batch run
  CoalCV(COM)
  RESCOMPRICE(COMRES, AY)
;

FILE Scen;

$call   "gdxxrw i=SATIMGE_NZ.xlsm o=SATIMGE_NZ index=index!a6 checkdate"
$gdxin  SATIMGE_NZ.gdx
$load RUN INCLRUN TC

$call   "gdxxrw i=SetsAndMaps\SetsAndMaps.xlsm o=SetsAndMaps\SetsMaps index=index!a6 checkdate"
$gdxin SetsAndMaps\SetsMaps.gdx
$load PRC COM Sector SubSector MPRCSubSector
$load CoalCV

$gdxin  NetZeroGDXs\0RG_NOPAMS_REF.gdx
$load REPORT_RUN;



LOOP(RUN$INCLRUN(RUN),

put_utilities Scen 'gdxin' / "NetZeroGDXs\",RUN.TL:50;
execute_load REPORT_RUN;

REPORTM(PRC,COM,TC,RUN,Indicators) = REPORT_RUN(PRC,COM,TC,Indicators);

TC3(TC2) = yes;
TC3('2025') = no;
LOOP(TC2$(NOT TC2_1(TC2)),

    LOOP(PRCRCAP,
       IF(REPORT_RUN(PRCRCAP,'ACTGRP',TC2,'Capacity') > REPORT_RUN(PRCRCAP,'ACTGRP',TC2-1,'Capacity'),
          REPORTM(PRCRCAP,'ACTGRP',TC3,RUN,'Capacity') = 0;
       );
    );
    TC3(TC2) = no;
);


);



execute_unload "REPORTM2.gdx" REPORTM
execute 'gdxdump REPORTM2.gdx output=REPORT_00.csv symb=REPORTM format=csv header="Process,Commodity,Year,Scenario,Indicator,SATIMGE"';
