* This file reads in sectoral/end use profiles to reconstruct grid profiles at the required timeslice resolution

SETS
HRS                      hours of the year /1*8760/
FSATIM                   sector groupings in SATIM model
Seasons                  Seasonal aggregation /SN1*SN12/


  REG                            TIMES regions    /REGION1/
  ALLYEAR                        All Years /1850*2200, 0/
  T(ALLYEAR)                     Time periods /2005*2070/
  DATAYEAR(ALLYEAR)              Years for which data is provided /2011*2040,2045,2050,2060,2070/
  MILESTONYR(ALLYEAR)            TIMES Milestone years
  V(ALLYEAR)                     Vintage years

  NMY1(ALLYEAR)                  All milestone years except for the first year (demand)
  S                              TIMES timeslices
  TS_MAP(REG,S,S)                Timeslice hierarchy tree: node+below
  TS_SEASON(S)                   seasonal timeslices
  TS_DAYNITE(S)                  day-night(block) timeslices
  TS_WEEKLY(S)                   day-type timeslices
  TS_HOURLY                      Hours in a day /1*24/
  TS_MAP2(TS_WEEKLY,TS_DAYNITE,TS_HOURLY)  maps day-types and blocks to 24 hour sequence
  PRC                            TIMES Processes
;
ALIAS (ALLYEAR,AY), (ALLYEAR,AYP), (DATAYEAR,DM_YEAR);
Alias (PRC,P);

Parameters
HourlyLoad(FSATIM,HRS)             Hourly Load Profile
;

*$call   "gdxxrw i=.\SATIMGE.xlsm o=SATIMGE index=index!a6 checkdate"
*$gdxin  SATIMGE.gdx
*$load RUN SATIMCASES X XC INCLRUN SIM_SATIM SIM_ESAGE SIM_WASTE SIM_AFOLU MRUNCASE MRUNX TC TT PAMS SIM_CO2CUMUL

$call   "gdxxrw i=SetsAndMaps\SetsAndMaps.xlsm o=SetsAndMaps\SetsMaps index=index!a6 checkdate"
$gdxin  SetsAndMaps\SetsMaps.gdx
*$loaddc PRC COM S TS_DAYNITE TS_WEEKLY TS_SEASON DEM1 UC_N FSATIM FS FH COALSUP PRCH TCG
$loaddc PRC FSATIM
*$load MFHH MHPRCH MCTCG MFSA MPRCFS MPRCFS2 mCOMC mCOMF Sector SubSector SubSubSector MPRCSector MPRCSubSector MPRCSubSubSector COMEXT
*$load PassengerOccupancy  FreightLoad CoalCV

$call   "gdxxrw i=SATIM\HighResProfiles\HighResProfiles.xlsm o=SATIM\HighResProfiles\HighResProfiles index=index!a6 checkdate"
$gdxin  SATIM\HighResProfiles\HighResProfiles.gdx

$load HourlyLoad
