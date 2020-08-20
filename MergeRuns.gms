* This code is used to stitch results from multiple gdx files into 1
SETS
* Overall sets
  RUN                            simulations
  AY                        All Years /1850*2200, 0/
  T(AY)                     Time periods /2005*2070/
  TC(T)                   eSAGE active time periods
  PRC                            TIMES Processes
  COM                            TIMES Commodities
  Indicators SATIM indicators /Activity, Capacity, NewCapacity, FlowIn, FlowOut, CO2, CH4, N2O, CF4, C2F6, CO2eq, Investment,Price, GVA, Population, Consumption, Employment, pkm, tkm/
;

Parameters
  REPORT(PRC,COM,AY,RUN,Indicators) REPORT of indicators by run and process and commodity
  REPORTM(PRC,COM,AY,RUN,Indicators) Merged Report
;

FILE Scen;

$gdxin SATIMGE.gdx
$load RUN TC

$gdxin SetsAndMaps\SetsMaps.gdx
$loaddc PRC COM

put_utilities Scen 'gdxin' / 'REPORT_7Runs.gdx';
execute_load REPORT;

REPORTM(PRC,COM,TC,RUN,Indicators) = REPORT(PRC,COM,TC,RUN,Indicators);

put_utilities Scen 'gdxin' / 'REPORT_2Runs.gdx';
execute_load REPORT;

REPORTM(PRC,COM,TC,'NoPAMS',Indicators) = REPORT(PRC,COM,TC,'NoPAMS',Indicators);
REPORTM(PRC,COM,TC,'NoPAMS-TrGr-FrcdCoal',Indicators) = REPORT(PRC,COM,TC,'NoPAMS-TrGr-FrcdCoal',Indicators);

execute_unload "REPORTM.gdx" REPORTM
execute 'gdxdump REPORTM.gdx output=REPORT_00.csv symb=REPORTM format=csv header="Process,Commodity,Year,Scenario,Indicator,SATIMGE"';
