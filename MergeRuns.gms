* This code is used to stitch results from multiple gdx files into 1
SETS
* Overall sets
  RUN                            simulations
  AY                        All Years /1850*2200, 0/
  T(AY)                     Time periods /2005*2070/
  TC(T)                   eSAGE active time periods
  PRC                            TIMES Processes
  COM                            TIMES Commodities
  Indicators SATIM indicators /Activity, Capacity, NewCapacity, CapFac, FlowIn, FlowOut, AnnInvCost, FOM, VOM, FuelCosts, CO2, CH4, N2O, CF4, C2F6, CO2eq, FlowInMt, Investment,Price, GVA, Population, Consumption, Employment-p, Employment-m,Employment-s,Employment-t,PalmaRatio,20-20Ratio,TradeDeficit,Imports,Exports,pkm, tkm/
;

Parameters
  REPORT_RUN(PRC,COM,AY,Indicators) REPORT of indicators by run and process and commodity for each run
  REPORTM(PRC,COM,AY,RUN,Indicators) Merged Report
  INCLRUN(RUN)                   whether to include or not RUN in batch run
  CoalCV(COM)
;

FILE Scen;

$call   "gdxxrw i=SATIMGE.xlsm o=SATIMGE index=index!a6 checkdate"
$gdxin  SATIMGE.gdx
$load RUN INCLRUN TC

$call   "gdxxrw i=SetsAndMaps\SetsAndMaps.xlsm o=SetsAndMaps\SetsMaps index=index!a6 checkdate"
$gdxin SetsAndMaps\SetsMaps.gdx
$loaddc PRC COM
$load CoalCV

LOOP(RUN$INCLRUN(RUN),

put_utilities Scen 'gdxin' / RUN.TL:20;
execute_load REPORT_RUN;

*tmp
* mtons of coal
REPORT_RUN(PRC,COM,TC,'FlowInMt')$CoalCV(COM) = REPORT_RUN(PRC,COM,TC,'FlowIn')/CoalCV(COM);


REPORTM(PRC,COM,TC,RUN,Indicators) = REPORT_RUN(PRC,COM,TC,Indicators);



);
*end loop

execute_unload "REPORTM.gdx" REPORTM
execute 'gdxdump REPORTM.gdx output=REPORT_00.csv symb=REPORTM format=csv header="Process,Commodity,Year,Scenario,Indicator,SATIMGE"';
