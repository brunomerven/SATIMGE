*--------------------------------------------------------------
*Process TIMES results -------------------------------------
*--------------------------------------------------------------

loop(MRUNCASE(RUN,SATIMCASES),

 put_utilities SATIM_Scen 'gdxin' / "%GDXfolder%",SATIMCASES.TL:50;
 execute_load MILESTONYR ELE RTP B E V TS_MAP COM_NRGELC PRC_ANNUAL PRC_WEEKLY PRC_SEASON PRC_DAYNIT
 execute_load COM_PROJ REG_OBJ PAR_NCAPL PRC_RESID PRC_CAPACT PAR_CAPL VARACT F_IN F_OUT NCAP_ILED OB_ICOST OB_ACT PAR_COMBALEM CST_FIXC CST_ACTC CST_INVC VAR_CAP UC_CAP G_YRFR;
* VAR_RCAP;
);

TGAP(MILESTONYR) = E(MILESTONYR) - B(MILESTONYR)+1;

SUPELE(PRC)$ELE('REGION1',PRC) = YES;

* interpolate all TIMES results for CGE link and report tables

RESID(REG,MILESTONYR,PRC) = PRC_RESID(REG,MILESTONYR,PRC);
* perform interpolation
*$BATINCLUDE interpolate PRC_RESID 'REG' 'PRC' ",'0','0','0','0','0'" TC 'RTP(REG,TC,PRC)'
$BATINCLUDE SATIM\Includes\interpolate.inc RESID 'REG' 'PRC' ",'0','0','0','0','0'" TC 'RTP(REG,TC,PRC)'

$BATINCLUDE SATIM\Includes\interpolate.inc PAR_CAPL 'REG' 'PRC' ",'0','0','0','0','0'" TC 'PAR_CAPL(REG,TC,PRC)'

*$BATINCLUDE interpolate PAR_RCAPL 'REG' 'PRC' ",'0','0','0','0','0'" TC 'PAR_RCAPL(REG,TC,PRC)'

$BATINCLUDE SATIM\Includes\interpolate.inc VARACT 'REG' 'PRC' ",'0','0','0','0','0'" TC 'VARACT(REG,TC,PRC)'

 NCAP_ILED(REG,TC,PRC) = NCAP_ILED(REG,'2012',PRC);

 OBICOST(REG,TC,PRC) = OB_ICOST(REG,PRC,'CUR',TC);
$BATINCLUDE SATIM\Includes\interpolate.inc OBICOST 'REG' 'PRC' ",'0','0','0','0','0'" TC 'RTP(REG,TC,PRC)'

 OBACT(REG,TC,PRC) = OB_ACT(REG,PRC,'CUR',TC);
$BATINCLUDE SATIM\Includes\interpolate.inc OBACT 'REG' 'PRC' ",'0','0','0','0','0'" TC 'RTP(REG,TC,PRC)'

 TVFLOWIN(COM,TC,PRC) = SUM((V,S), F_IN('REGION1',V,TC,PRC,COM,S));
$BATINCLUDE SATIM\Includes\interpolate.inc TVFLOWIN 'COM' 'PRC' ",'0','0','0','0','0'" TC 'TVFLOWIN(COM,TC,PRC)'

 TVFLOWOUT(COM,TC,PRC) = SUM((V,S), F_OUT('REGION1',V,TC,PRC,COM,S));
$BATINCLUDE SATIM\Includes\interpolate.inc TVFLOWOUT 'COM' 'PRC' ",'0','0','0','0','0'" TC 'TVFLOWOUT(COM,TC,PRC)'

 TCST_INVC(REG,TC,PRC)= sum(V,CST_INVC(REG,V,TC,PRC,'INV'));
$BATINCLUDE SATIM\Includes\interpolate.inc TCST_INVC 'REG' 'PRC' ",'0','0','0','0','0'" TC 'TCST_INVC(REG,TC,PRC)'

 TCST_ACTC(REG,TC,PRC)= sum(V,CST_ACTC(REG,V,TC,PRC,'-'));
$BATINCLUDE SATIM\Includes\interpolate.inc TCST_ACTC 'REG' 'PRC' ",'0','0','0','0','0'" TC 'TCST_ACTC(REG,TC,PRC)'

 TCST_FIXC(REG,TC,PRC)= sum(V,CST_FIXC(REG,V,TC,PRC));
$BATINCLUDE SATIM\Includes\interpolate.inc TCST_FIXC 'REG' 'PRC' ",'0','0','0','0','0'" TC 'TCST_FIXC(REG,TC,PRC)'

 T_COMBALEM(REG,TC,COM) = PAR_COMBALEM(REG,TC,COM,'ANNUAL');
*Special calc for hydrogen for power
 T_COMBALEM('REGION1',TC,'PWRHGN')$SUM((V,S),F_OUT('REGION1',V,TC,'XPWRHGN','PWRHGN',S)) = SUM(S,PAR_COMBALEM('REGION1',TC,'PWRHGN',S)*SUM(V,F_OUT('REGION1',V,TC,'XPWRHGN','PWRHGN',S)))/SUM((V,S),F_OUT('REGION1',V,TC,'XPWRHGN','PWRHGN',S));
$BATINCLUDE SATIM\Includes\interpolate.inc T_COMBALEM 'REG' 'COM' ",'0','0','0','0','0'" TC 'T_COMBALEM(REG,TC,COM)'

$BATINCLUDE SATIM\Includes\interpolate.inc COM_PROJ 'REG' 'COM' ",'0','0','0','0','0'" TC 'COM_PROJ(REG,TC,COM)'


* Attempt at putting parameter for results equal to variable:
 PAR_VCAPL(REG,TC,PRC) = VAR_CAP.L(REG,TC,PRC);
$BATINCLUDE SATIM\Includes\interpolate.inc PAR_VCAPL 'REG' 'PRC' ",'0','0','0','0','0'" TC 'PAR_VCAPL(REG,TC,PRC)'




*excluding TVCOMBAL because of CO2 marginals TVCOMBAL(T,COM)  = PAR_COMBALEM('REGION1',T,COM,'ANNUAL');


* Calculate New Capacity from milestone year results
* for TVNCAP we assume uniform spread of the investment (although TIMES uses the discount rate to spread it - we could do this later)
 TVNCAP(TC,PRC)    = PAR_NCAPL('REGION1',TC,PRC);
 TVNCAP(MILESTONYR,PRC) = TVNCAP(MILESTONYR,PRC)/TGAP(MILESTONYR);
 LOOP(MILESTONYR,
   LOOP(TC,
     if(YEARVALT(TC) GE B(MILESTONYR) and YEARVALT(TC) LE E(MILESTONYR),
       TVNCAP(TC,PRC) = TVNCAP(MILESTONYR,PRC);
     );
   );
  );


* TVCAP(TC,PRC)     = RESID('REGION1',TC,PRC)+PAR_CAPL('REGION1',TC,PRC);
 TVCAP(TC,PRC)     = PAR_VCAPL('REGION1',TC,PRC);


 TVACT(TC,PRC)     = VARACT('REGION1',TC,PRC);
* TVCAP(TC,PRC)     = PAR_CAPL('REGION1',TC,PRC);

* Calculate final consumption for SATIM industry sectors and freight
 FLOW_IN_FS(FSATIM,COM,TC) = SUM(PRC$MPRCFS(PRC,FSATIM), TVFLOWIN(COM,TC,PRC));
 FLOW_OUT_FS(FSATIM,COM,TC) = SUM(PRC$MPRCFS(PRC,FSATIM), TVFLOWOUT(COM,TC,PRC));

* calculate final consumption
 FLOW_IN_FSFuels(FSATIM,C,TC) = SUM(COM$MCOMC(COM,C),FLOW_IN_FS(FSATIM,COM,TC));
 FLOW_OUT_FSFuels(FSATIM,C,TC) = SUM(COM$MCOMC(COM,C),FLOW_OUT_FS(FSATIM,COM,TC));

 FLOW_OUT_FSFactors(FS,F,TC) = SUM(COM$MCOMF(COM,F),FLOW_OUT_FS(FS,COM,TC));


*bm methane rich gas is currently a product of sasol which is accounted for in SATIM, but not in eSAGE so making this zero
 FLOW_OUT_FSFuels('petr','cngas',TC) = 0;

*Correction made for Pulp and paper own gen, this may have to be done to more sectors as own gen becomes more prevalent
 FLOW_IN_FSFuels('pp','celec',TC) = FLOW_IN_FSFuels('pp','celec',TC) - FLOW_OUT_FSFuels('pp','celec',TC);

*Correction made for power sector gas. New energy balance implies all gas consumed in chemical sector. Old EB had some gas going to power.
* Sasol autoproducers are no longer included in power.
 FLOW_IN_FSFuels('elec','cngas',TC) = max(FLOW_IN_FSFuels('elec','cngas',TC),3);


*UCONV_C_T2C(C);

*bm calc oil flow
 OIL_FLOW(RUN,TC) = SUM(PRC$MPRCFS(PRC,'petr'), TVACT(TC,PRC));

*bm calc coal flow
 COAL_FLOW(RUN,TC,'ccoal-low') = sum(FSATIM,FLOW_IN_FSFuels(FSATIM,'ccoal-low',TC));
 COAL_FLOW(RUN,TC,'ccoal-hgh') = sum(FSATIM,FLOW_IN_FSFuels(FSATIM,'ccoal-hgh',TC));


 EIntensity_FS(FS,C,TC)$GVA_FS(FS,TC) = FLOW_IN_FSFuels(FS,C,TC)/GVA_FS(FS,TC);

*bm calculating coal mining capacity based on consumption+exports)
 COALMINCAP(TC) = sum(FSATIM,FLOW_IN_FSFuels(FSATIM,'ccoal-hgh',TC))+sum(FSATIM,FLOW_IN_FSFuels(FSATIM,'ccoal-low',TC));

* For households on transport
* multiply by share of pkm by household to allocate consumption to different hh
* FLOW_IN_FTFHFuels(FH,C,TC) = FLOW_IN_FTFuels('TPPR',C,TC)*PKMFH('TPPR',FH,TC);
* add transport fuels to other fuels
* FLOW_IN_FHAllFuels(FH,C,TC) = FLOW_IN_FHFuels(FH,C,TC)+FLOW_IN_FTFHFuels(FH,C,TC);

* EIntensity_FH(FH,C,TC)$TFHPOP_X(FH,TC) = FLOW_IN_FHAllFuels(FH,C,TC);
*/TFHPOP_X(FH,TC);

*IF(TT1(TT),

* FLOW_IN_FHFuelsGR(FH,C,TC)$EIntensity_FH(FH,C,TC-1) = EIntensity_FH(FH,C,TC)/EIntensity_FH(FH,C,TC-1);
*);
* FLOW_IN_FHFuelsGR('hhd-he','cpetr_o','2013') = 0;
* FLOW_IN_FHFuelsGR('hhd-he','cpetr_o','2014') = 0;
* FLOW_IN_FHFuelsGR('hhd-he','cpetr_o','2015') = 0;


*Investment costs from TIMES ----------------------------------

$ontext
 Investment costs are based on year of build decision (TVNCAP) and the number
 of years needed to build the plant (lead time NCAP_LEAD).
 Annual cost = build capacity (TVNCAP) x unit cost (OBJ_ICOST) / years to build (NCAP_ILED)
 Calculation: Keep track of vintages (TP)
$offtext

NCAP_ILED('REGION1','2012',PRC)$(NCAP_ILED('REGION1','2012',PRC) EQ eps)= -1;


LOOP((PRC,TC)$(TVNCAP(TC,PRC) AND NCAP_ILED('REGION1','2012',PRC) GT 0),
 LOOP(TCP$((ORD(TCP) GE ORD(TC)) AND (ORD(TCP) LT (ORD(TC)+NCAP_ILED('REGION1','2012',PRC)))),
  BPINV(RUN,TC,TCP,PRC)$NCAP_ILED('REGION1','2012',PRC) = TVNCAP(TC,PRC)/NCAP_ILED('REGION1','2012',PRC) * OBICOST('REGION1',TC,PRC);
 );
);
* investment cost with negative NCAL_ILED
LOOP((PRC,TC)$(TVNCAP(TC,PRC) AND NCAP_ILED('REGION1','2012',PRC) LT 0),
 LOOP(TCP$((ORD(TCP) LT ORD(TC)) AND (ORD(TCP) GE (ORD(TC)+NCAP_ILED('REGION1','2012',PRC)))),
  BPINV(RUN,TC,TCP,PRC)$NCAP_ILED('REGION1','2012',PRC) = TVNCAP(TC,PRC)/(-1*NCAP_ILED('REGION1','2012',PRC)) * OBICOST('REGION1',TC,PRC);
 );
);

* expenditure schedule in billions (2007 from 2010)
 INVCOST(RUN,TC,PRC) = SUM(TCP, BPINV(RUN,TCP,TC,PRC))/1000;

*Sum across vintages to get total annual cost (billions of rands) and convert from 2015 to 2012 Rands for CGE
* EINVCOST(XC,T,TT) = SUM((SUPELE AND SUPOIL), INVCOST(XC,T,TT,ELE));
 EINVCOST(RUN,TC) = SUM(PRCPower, INVCOST(RUN,TC,PRCPower)) * 0.852;

* EFLOW('NAT',XC,TC,TT) = SUM(SUPELE, TVACT(TC,SUPELE))/3.6;
* !!EFLOW now calculated from flow through transmission. When we include distributed generation we also need to include them in the calc
 ELC_FLOW2(RUN,TC) = (TVACT(TC,'XAGRELC') + TVACT(TC,'XCOMELC') +TVACT(TC,'XINDELC') + TVACT(TC,'XRESELC') + TVACT(TC,'XTRAELC') + TVACT(TC,'XUPSELC') + TVACT(TC,'PEXELC'));
 ELC_FLOW(RUN,TC) = sum(FSATIMNOELEC,FLOW_IN_FSFuels(FSATIMNOELEC,'celec',TC));

* recalculate intensity for energy sectors, where GVA not suitable
 EIntensity_FS('elec',C,TC) = FLOW_IN_FSFuels('elec',C,TC)/ELC_FLOW(RUN,TC);
 EIntensity_FS('hydr',C,TC)$FLOW_OUT_FSFuels('hydr','chydr',TC) = FLOW_IN_FSFuels('hydr',C,TC)/FLOW_OUT_FSFuels('hydr','chydr',TC);
 EIntensity_FS('petr',C,TC) = FLOW_IN_FSFuels('petr',C,TC)/OIL_FLOW(RUN,TC);

*BM+FH 201218: SETTING STARTING POINT FOR HYDROGEN
 ICAFSGR(C,FS,T)$(EIntensity_FS(FS,C,T-1) GT 0.00001) = EIntensity_FS(FS,C,T)/EIntensity_FS(FS,C,T-1);


 ICAFSGR(C,'nf',T) = min(1,ICAFSGR(C,'nf',T));

* ICAFSGR('cpetr_d','tranlp',T,TT) = 0.8;

*Also need to divide by sum of final demand rather than sum of generation to better accommodate storage and losses

* carbon tax resulting from cap (marginal)
*bm TCARBONTAX(XC,TC,TT) = T_COMBALEM('REGION1',TC,'CO2EQS')*(-0.791);


*Regulated Commodity price from TIMES ----------------------


* Electricity Price = (power plant costs + fuel costs)/total elc transmitted
*Power Plant Costs (excluding fuel)


 REPORT(PRCPower,'ACTGRP',TC,RUN,'AnnInvCost') = TCST_INVC('REGION1',TC,PRCPower);
 REPORT(PRCPower,'ACTGRP',TC,RUN,'FOM') = TCST_FIXC('REGION1',TC,PRCPower);
 REPORT(PRCPower,'ACTGRP',TC,RUN,'VOM') = TCST_ACTC('REGION1',TC,PRCPower);
 REPORT(PRCPower,'ACTGRP',TC,RUN,'FuelCosts') = SUM(COM, TVFLOWIN(COM,TC,PRCPower)*T_COMBALEM('REGION1',TC,COM));



 TCST_ELE_I(RUN,TC) = SUM(PRCPower,TCST_INVC('REGION1',TC,PRCPower));
 TCST_ELE_A(RUN,TC) = SUM(PRCPower,TCST_ACTC('REGION1',TC,PRCPower));
 TCST_ELE_F(RUN,TC) = SUM(PRCPower,TCST_FIXC('REGION1',TC,PRCPower));

 TCST_ELE_INV(RUN,TC) = TCST_ELE_I(RUN,TC);
 QFEGY_GR(RUN,TC)$TCST_ELE_INV(RUN,TC-1) = TCST_ELE_INV(RUN,TC)/TCST_ELE_INV(RUN,TC-1);

 FIntensity_FS('elec','fegy',TC) = TCST_ELE_INV(RUN,TC)/ELC_FLOW(RUN,TC);
 FIntensity_FS('elec',FLAB,TC) = FLOW_OUT_FSFactors('elec',FLAB,TC)/ELC_FLOW(RUN,TC);

 IFAFSGR(F,FS,TC)$FIntensity_FS(FS,F,TC-1) = FIntensity_FS(FS,F,TC)/FIntensity_FS(FS,F,TC-1);

*sum the components of elec costs calcs:
 TCST_ELE(RUN,TC) = TCST_ELE_I(RUN,TC) + TCST_ELE_A(RUN,TC)+TCST_ELE_F(RUN,TC);

* Coal costs
*detailed coal supply model calcs:
 TCST_COALSUP(RUN,TC) = SUM(COALSUP,TCST_INVC('REGION1',TC,COALSUP)+TCST_ACTC('REGION1',TC,COALSUP)+TCST_FIXC('REGION1',TC,COALSUP));

 TCST_PWRCLT(RUN,TC) = TCST_COALSUP(RUN,TC);


* Gas and hydrogen costs
 TCST_PWROTH(RUN,TC) = TVACT(TC,'XPWRGIC')*T_COMBALEM('REGION1',TC,'PWRGIC') + TVACT(TC,'XPWRGAS') *T_COMBALEM('REGION1',TC,'PWRGAS') + TVACT(TC,'XPWRHGN')*T_COMBALEM('REGION1',TC,'PWRHGN');


*still need to add CO2 tax here

* Elc Price
 ETPRICE(TC) = (TCST_PWRCLT(RUN,TC)+TCST_PWROTH(RUN,TC)+TCST_ELE(RUN,TC))/ELC_FLOW(RUN,TC);

 AggFixPrice('ELC',TC,RUN) = Sum(PRCBulkPower,(TCST_INVC('REGION1',TC,PRCBulkPower)+TCST_FIXC('REGION1',TC,PRCBulkPower)))/TVCAP(TC,'ETRANS');
 AggVarCost('ELC',TC,RUN) = Sum(PRCBulkPower, (TCST_ACTC('REGION1',TC,PRCBulkPower)+REPORT(PRCBulkPower,'ACTGRP',TC,RUN,'FuelCosts')));
 AggVarPrice('ELC',TC,RUN)$REPORT('ETRANS','ELC',TC,RUN,'FlowOut') = AggVarCost('ELC',TC,RUN)/REPORT('ETRANS','ELC',TC,RUN,'FlowOut');



*b add growth rates from TIMES from 2014 onward
 ETPRICEGR(TC)$(not T1(TC)) = ETPRICE(TC)/ETPRICE(TC-1)-1;


* Energy Model Indicators

 REPORT('SATIMMarginals',COM,TC,RUN,'Marginals') = T_COMBALEM('REGION1',TC,COM);

 REPORT(PRC,'ACTGRP',TC,RUN,'Activity') = TVACT(TC,PRC);
 REPORT(PRC,'ACTGRP',TC,RUN,'Capacity') = TVCAP(TC,PRC);
 REPORT(PRC,'ACTGRP',TC,RUN,'NewCapacity') = TVNCAP(TC,PRC);

 REPORT(PRC,'ACTGRP',TC,RUN,'CapFac')$(TVCAP(TC,PRC)*PRC_CAPACT('REGION1',PRC)) = TVACT(TC,PRC)/(TVCAP(TC,PRC)*PRC_CAPACT('REGION1',PRC));

 REPORT(PRC,COM,TC,RUN,'FlowIn') = TVFLOWIN(COM,TC,PRC);
 REPORT(PRC,COM,TC,RUN,'FlowOut') = TVFLOWOUT(COM,TC,PRC);

 REPORT(PRC,'ACTGRP',TC,RUN,'Investment') = INVCOST(RUN,TC,PRC);

 REPORT(PRC,'ACTGRP',TC,RUN,'Employment-p')$UC_CAP('UCPWR_FLAB-P','LHS','REGION1','2012',PRC) = UC_CAP('UCPWR_FLAB-P','LHS','REGION1',TC,PRC)*(-1)*TVCAP(TC,PRC);
 REPORT(PRC,'ACTGRP',TC,RUN,'Employment-m')$UC_CAP('UCPWR_FLAB-M','LHS','REGION1','2012',PRC) = UC_CAP('UCPWR_FLAB-M','LHS','REGION1',TC,PRC)*(-1)*TVCAP(TC,PRC);
 REPORT(PRC,'ACTGRP',TC,RUN,'Employment-s')$UC_CAP('UCPWR_FLAB-S','LHS','REGION1','2012',PRC) = UC_CAP('UCPWR_FLAB-S','LHS','REGION1',TC,PRC)*(-1)*TVCAP(TC,PRC);
 REPORT(PRC,'ACTGRP',TC,RUN,'Employment-t')$UC_CAP('UCPWR_FLAB-T','LHS','REGION1','2012',PRC) = UC_CAP('UCPWR_FLAB-T','LHS','REGION1',TC,PRC)*(-1)*TVCAP(TC,PRC);

 REPORT('ETRANSDUM','ELC',TC,RUN,'Price') = ETPRICE(TC);


* Other indicators - this could be done more elegantly
 REPORT('hhd-le','ACTGRP',TC,RUN,'Population') = TFHPOP('hhd-le',TC)*POP(TC);
 REPORT('hhd-me','ACTGRP',TC,RUN,'Population') = TFHPOP('hhd-me',TC)*POP(TC);
 REPORT('hhd-he','ACTGRP',TC,RUN,'Population') = TFHPOP('hhd-he',TC)*POP(TC);

* pkm and tkm
 REPORT(PRC,'ACTGRP',TC,RUN,'pkm')$PassengerOccupancy(PRC) = TVACT(TC,PRC)*PassengerOccupancy(PRC);
 REPORT(PRC,'ACTGRP',TC,RUN,'tkm')$FreightLoad(PRC) = TVACT(TC,PRC)*FreightLoad(PRC);

* mtons of coal
 REPORT(PRC,COM,TC,RUN,'FlowInMt')$CoalCV(COM) = TVFLOWIN(COM,TC,PRC)/CoalCV(COM);
