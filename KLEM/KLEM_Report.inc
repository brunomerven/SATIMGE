* Parameters Calculation for KLEM linked model
* Bruno Merven November 2020

* Energy Bills for non-electricity commodities
K_EnergyBill(FSATIM,COM,TC) = T_COMBALEM('REGION1',TC,COM) * FLOW_IN_FS(FSATIM,COM,TC);
K_EnergyBill('IMP',COM,TC) = T_COMBALEM('REGION1',TC,COM) * FLOW_OUT_FS('IMP',COM,TC);

* Using average electricity price across all sectors - this could be improved once we have sector specific prices (WIP)
K_EnergyBill(FSATIMNOELEC,'ELC',TC) = ETPRICE(TC) * FLOW_IN_FSFuels(FSATIMNOELEC,'celec',TC);
K_EnergyBill('EXP',COM,TC) = 0;

K_EnergyBillFuels(FSATIM,C,TC) = SUM(COM$MCOMC(COM,C),K_EnergyBill(FSATIM,COM,TC));

* Prices for aggregate fuels
K_EnergyPriceFuels(FSATIM,C,TC)$FLOW_IN_FSFuels(FSATIM,C,TC) = K_EnergyBillFuels(FSATIM,C,TC)/FLOW_IN_FSFuels(FSATIM,C,TC);
K_EnergyPriceFuels('IMP',C,TC)$FLOW_OUT_FSFuels('IMP',C,TC) = K_EnergyBillFuels('IMP',C,TC)/FLOW_OUT_FSFuels('IMP',C,TC);


*Output from Energy Sectors.
* First non-electricity Sectors, taken as output directly
K_Output(K_EnergyNoElc,C,TC) = Flow_OUT_FSFuels(K_EnergyNoElc,C,TC);
K_Input(K_Energy,C,TC) = Flow_IN_FSFuels(K_Energy,C,TC);

* Then output from Electricity which is output from Distribution, so net of losses
K_Output('elec','celec',TC) = sum(COM,sum(PRC$MPRCSubSector(PRC,'Power','EDist'),TVFLOWOUT(COM,TC,PRC)));
K_Input('elec','celec',TC) = 0;

* Calculate KLEM indicators from intermediate calculation parameters
*KLEM sectors: E-Firms, NonE-Firms, Households, Trade, where Trade Input = Exports and Trade Output = Imports
*KLEM indicators: E_Price, E_Input, E_Output
*K_AggInd(K_Sectors,K_Indicators,AY,RUN)

* Aggregate Energy Bills
 K_AggInd('E-Firms','E_Bill',TC,RUN) = Sum((K_Energy,C), K_EnergyBillFuels(K_Energy,C,TC));
 K_AggInd('NonE-Firms','E_Bill',TC,RUN) = Sum((K_NonEnergy,C), K_EnergyBillFuels(K_NonEnergy,C,TC));
 K_AggInd('Households','E_Bill',TC,RUN) = Sum((K_Households,C), K_EnergyBillFuels(K_Households,C,TC));
 K_AggInd('Trade','E_Bill',TC,RUN) = Sum(C, K_EnergyBillFuels('IMP',C,TC));

* Aggregate Consumptions/Input/Export for Trade
 K_AggInd('E-Firms','E_Input',TC,RUN) = Sum((C,K_Energy),K_Input(K_Energy,C,TC));
 K_AggInd('NonE-Firms','E_Input',TC,RUN) = Sum((K_NonEnergy,C), FLOW_IN_FSFuels(K_NonEnergy,C,TC));
 K_AggInd('Households','E_Input',TC,RUN) = Sum((K_Households,C), FLOW_IN_FSFuels(K_Households,C,TC));
 K_AggInd('Trade','E_Input',TC,RUN) = Sum(C, FLOW_IN_FSFuels('EXP',C,TC));

* Aggregate Output / Import for Trade
 K_AggInd('Trade','E_Output',TC,RUN) = Sum(C, FLOW_OUT_FSFuels('IMP',C,TC));
 K_AggInd('E-Firms','E_Output',TC,RUN) = Sum((C,K_Energy), K_Output(K_Energy,C,TC));


* Aggregate Prices
 K_AggInd('E-Firms','E_Price',TC,RUN) = K_AggInd('E-Firms','E_Bill',TC,RUN)/K_AggInd('E-Firms','E_Input',TC,RUN);
 K_AggInd('NonE-Firms','E_Price',TC,RUN) = K_AggInd('NonE-Firms','E_Bill',TC,RUN)/K_AggInd('NonE-Firms','E_Input',TC,RUN);
 K_AggInd('Households','E_Price',TC,RUN) = K_AggInd('Households','E_Bill',TC,RUN)/K_AggInd('Households','E_Input',TC,RUN);
 K_AggInd('Trade','E_Price',TC,RUN) = K_AggInd('Trade','E_Bill',TC,RUN)/K_AggInd('Trade','E_Output',TC,RUN);

*bryce: weighted price for import energy, and export
*sum of bill divide by sum of flows (line 6) by 


* get rid of values pre-2017
K_AggInd(K_Sectors,K_Indicators,'2012',RUN) = 0;
K_AggInd(K_Sectors,K_Indicators,'2013',RUN) = 0;
K_AggInd(K_Sectors,K_Indicators,'2014',RUN) = 0;
K_AggInd(K_Sectors,K_Indicators,'2015',RUN) = 0;
K_AggInd(K_Sectors,K_Indicators,'2016',RUN) = 0;
