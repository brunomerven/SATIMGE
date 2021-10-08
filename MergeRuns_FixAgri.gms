* This code is used to stitch results from multiple gdx files into 1
SETS
* Overall sets
  RUN                            simulations
  AY                        All Years /1850*2200, 0/
  T(AY)                     Time periods /2005*2070/
  TC(T)                   eSAGE active time periods
  PRC                            TIMES Processes
  COM                            TIMES Commodities
  Indicators SATIM indicators /Activity, Capacity, NewCapacity, CapFac, FlowIn, FlowOut, AnnInvCost, FOM, VOM, FuelCosts, Marginals, Levies, ExternalityCosts, CO2Tax, CO2, CO2C, CH4, N2O, CF4, C2F6, CO2eq, FlowInMt, Investment,Price, GVA, Population, Consumption, Employment-p, Employment-m,Employment-s,Employment-t,PalmaRatio,20-20Ratio,TradeDeficit,Imports,Exports,pkm, tkm/
  FSATIM                  sector groupings in SATIM model
  FS(FSATIM)              TIMES economic sectors
  Sector
  SubSector
  PamsSector                     Pams Sectors for NDC / RES, COM, TRA, WASTE, AFOLU/
  MPRCSubSector(PRC,Sector,SubSector)          Map for PRC to subsectors
  MPRCFS2(PRC,FSATIM)          mapping SATIM PRCs to SATIM sectors (used to pass CGE aggregates to SATIM sectors)
  Emiss(Indicators) / CO2, CH4, N2O, CF4, C2F6, CO2eq/
;
*$onExternalOutput
Parameters
  REPORT_RUN(PRC,COM,AY,Indicators) REPORT of indicators by run and process and commodity for each run
  REPORTM(PRC,COM,AY,RUN,Indicators) Merged Report
  INCLRUN(RUN)                   whether to include or not RUN in batch run
  CoalCV(COM)
  GVA_FS(FS,AY)                  SATIM Sector GVA
  PAMS(RUN,PamsSector)
  PAMS_RUN(PamsSector)       activated pams for run in loop
  POP(AY)                        Population Projection to be read from drivers workbook
  AgriEmissions(PRC,Emiss,AY) Agriculture Emissions
;



FILE Scen;

$call   "gdxxrw i=SATIMGE.xlsm o=SATIMGE index=index!a6 checkdate"
$gdxin  SATIMGE.gdx
$load RUN INCLRUN TC PAMS

$call   "gdxxrw i=SetsAndMaps\SetsAndMaps.xlsm o=SetsAndMaps\SetsMaps index=index!a6 checkdate"
$gdxin SetsAndMaps\SetsMaps.gdx
$load PRC COM Sector SubSector MPRCSubSector FSATIM FS MPRCFS2
$load CoalCV

LOOP(RUN$INCLRUN(RUN),

PAMS_RUN(PamsSector) = PAMS(RUN,PamsSector);

put_utilities Scen 'gdxin' / "NetZeroGDXs\",RUN.TL:50;
execute_load REPORT_RUN;

GVA_FS(FS,AY) = sum(PRC$MPRCFS2(PRC,FS),REPORT_RUN(PRC,'ACTGRP',AY,'GVA'));
POP(AY) = REPORT_RUN('hhd-le','ACTGRP',AY,'Population')+
          REPORT_RUN('hhd-me','ACTGRP',AY,'Population')+
          REPORT_RUN('hhd-he','ACTGRP',AY,'Population');

* Write Drivers to Spreadsheet
execute_unload "DriversAGRI.gdx" GVA_FS POP PAMS_RUN
execute 'gdxxrw.exe i=DriversAGRI.gdx o=AFOLU\Agriculture_model_Linked.xlsx index=indexG2E!a6';

* Read Results from Spreadsheet
execute 'gdxxrw.exe i=AFOLU\Agriculture_model_Linked.xlsx o=Agri.gdx index=IndexE2G!a6';
execute_load "Agri.gdx" AgriEmissions;

*REPORTM(PRC,COM,TC,RUN,Indicators) = REPORT_RUN(PRC,COM,TC,Indicators);
*REPORTM(PRC,'ACTGRP',AY,RUN,Emiss)$AgriEmissions(PRC,Emiss,AY) = AgriEmissions(PRC,Emiss,AY);
REPORT_RUN(PRC,'ACTGRP',AY,Emiss)$AgriEmissions(PRC,Emiss,AY) = AgriEmissions(PRC,Emiss,AY);

put_utilities Scen 'gdxout' / RUN.TL:30;
execute_unload REPORT_RUN
);

*tmp fixes until model is rerun These fixes have been made in the model.
*REPORTM(PRC,'IISCOA',TC,RUN,'CO2')$MPRCSubSector(PRC,'Industry','Iron_Steel351') = 0;
*REPORTM(PRC,'IISCKC',TC,RUN,'CO2')$MPRCSubSector(PRC,'Industry','Iron_Steel351') = 0;
*REPORTM('PEXCOA','COA',TC,RUN,'FlowInMt') = 75;

*$offExternalOutput

*end loop

*execute_unload "REPORTM.gdx" REPORTM
*execute 'gdxdump REPORTM.gdx output=REPORT_00.csv symb=REPORTM format=csv header="Process,Commodity,Year,Scenario,Indicator,SATIMGE"';
