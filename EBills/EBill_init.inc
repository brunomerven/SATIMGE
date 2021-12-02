* Initalization of sets and parameters used for eBill (seen by CGE)
* Bruno Merven October 2021

SETS
   C_Energy(C)      Energy Commodities including private transport
;
C_Energy(ENERGY) = yes;
C_Energy('cprtr') = yes;

Parameters
* intermediate calc parameters
   EnergyBill(H,C,AY)  eSAGE Energy Bill by income deciles
   EnergyPrice(C,AY) Energy Prices for all TIMES commodities

   K_EnergyBillFuels(FSATIM,C,AY) KLEM Energy Bill by sector for aggregate commodities
   K_EnergyPriceFuels(FSATIM,C,AY) KLEM Sector Prices for aggregate commodities

   K_Output(FSATIM,C,AY) KLEM output of energy sector
   K_Input(FSATIM,C,AY) KLEM input of energy sector

* final indicators
   K_AggInd(K_Sectors,K_Indicators,AY,RUN)       KLEM aggregate indicator values
;


* define KLEM Sectors

* Households
K_Households(FH) = Yes;
K_Households('tppr') = Yes;

* NonEnergy Sectors
K_NonEnergy(FSATIM) = Yes;
K_NonEnergy('EXP') = No;
K_NonEnergy('IMP') = No;
K_NonEnergy(K_Households) = No;
K_NonEnergy('hydr') = No;
K_NonEnergy('elec') = No;
K_NonEnergy('petr') = No;
K_NonEnergy('GAS') = No;
K_NonEnergy('coal') = No;

* Energy Sectors
K_Energy(FSATIM) = Yes;
K_Energy(K_NonEnergy) = No;
K_Energy('EXP') = No;
K_Energy('IMP') = No;
* Gas part of imports
K_Energy('GAS') = No;

* Coal in or out?
K_Energy('coal') = No;

K_NonEnergy(K_Households) = No;

*Energy Except Electricity
K_EnergyNoElc(K_Energy) = Yes;
K_EnergyNoElc('elec') = No;
