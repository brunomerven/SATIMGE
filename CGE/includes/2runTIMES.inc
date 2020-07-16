* this includes early retirement capacity adjustments

*--------------------------------------------------------------
*SETUP AND CALL TIMES MODEL IN GAMS -------------------------------------
*--------------------------------------------------------------

  PUT  ShowRunNumber;
  RUNTIMES2.pc = 2;
  RUNTIMES2.nd = 5;
  RUNTIMES2.ap = 0;

  put "echo ", RUN.TL;

  PUTCLOSE "";

* Write executable for running SATIM with specified path and run-name
  PUT  RUNTIMES2;
  RUNTIMES2.pc = 2;
  RUNTIMES2.nd = 5;
  RUNTIMES2.ap = 0;
  put 'copy "%workingfolder%SATM\%TIMESfolder%\DMDTECHAFRES+REGION1.bu" "%workingfolder%SATM\%TIMESfolder%\DMDTECHAFRES+REGION1.dds"'/;
  put 'copy "%workingfolder%SATM\%TIMESfolder%\DMDTECHAFCOM+REGION1.bu" "%workingfolder%SATM\%TIMESfolder%\DMDTECHAFCOM+REGION1.dds"'/;
  put 'copy "%workingfolder%SATM\%TIMESfolder%\COALSUPMODEL+REGION1.bu" "%workingfolder%SATM\%TIMESfolder%\COALSUPMODEL+REGION1.dds"'/;

  loop(MRUNCASE(RUN,TIMESCASE), put ".\satm\%TIMESfolder%\RUNTIMES.CMD ", "%workingfolder%":38,TIMESCASE.TL:20,"%TIMESfolder%");

  PUTCLOSE "";

* Run TIMES model
 execute ".\satm\%TIMESfolder%\ShowRunNumber.CMD"
 execute ".\satm\%TIMESfolder%\RUNTIMES2.CMD"
 execute "echo --- Return to CGE model"

*execute 'sleep 2';

*--------------------------------------------------------------
*PASS RESULTS FROM TIMES TO CGE
*--------------------------------------------------------------
loop(MRUNCASE(RUN,TIMESCASE), put_utilities SATIM_Scen 'gdxin' / "%GDXfolder%",TIMESCASE.TL:20);
 execute_load DATAYEAR DM_YEAR MILESTONYR RTP B E
 execute_load COM_PROJ REG_OBJ PAR_NCAPL PAR_NCAPR PRC_RESID PRC_CAPACT PAR_NCAPR PAR_CAPL VARACT F_IN F_OUT NCAP_ILED OB_ICOST PAR_COMBALEM CST_FIXC CST_ACTC CST_INVC VAR_CAP UC_CAP;
* VAR_RCAP;

RESID(REG,MILESTONYR,PRC) = PRC_RESID(REG,MILESTONYR,PRC);
* perform interpolation
*$BATINCLUDE interpolate PRC_RESID 'REG' 'PRC' ",'0','0','0','0','0'" TC 'RTP(REG,TC,PRC)'
$BATINCLUDE interpolate RESID 'REG' 'PRC' ",'0','0','0','0','0'" TC 'RTP(REG,TC,PRC)'

$BATINCLUDE interpolate PAR_CAPL 'REG' 'PRC' ",'0','0','0','0','0'" TC 'PAR_CAPL(REG,TC,PRC)'

*$BATINCLUDE interpolate PAR_RCAPL 'REG' 'PRC' ",'0','0','0','0','0'" TC 'PAR_RCAPL(REG,TC,PRC)'

$BATINCLUDE interpolate VARACT 'REG' 'PRC' ",'0','0','0','0','0'" TC 'VARACT(REG,TC,PRC)'

 NCAP_ILED(REG,TC,PRC) = NCAP_ILED(REG,'2012',PRC);

 OBICOST(REG,TC,PRC) = OB_ICOST(REG,PRC,'CUR',TC);
$BATINCLUDE interpolate OBICOST 'REG' 'PRC' ",'0','0','0','0','0'" TC 'RTP(REG,TC,PRC)'

 TVFLOWIN(COM,TC,PRC) = SUM((V,S), F_IN('REGION1',V,TC,PRC,COM,S));
$BATINCLUDE interpolate TVFLOWIN 'COM' 'PRC' ",'0','0','0','0','0'" TC 'TVFLOWIN(COM,TC,PRC)'

 TVFLOWOUT(COM,TC,PRC) = SUM((V,S), F_OUT('REGION1',V,TC,PRC,COM,S));
$BATINCLUDE interpolate TVFLOWOUT 'COM' 'PRC' ",'0','0','0','0','0'" TC 'TVFLOWOUT(COM,TC,PRC)'

 TCST_INVC(REG,TC,PRC)= sum(V,CST_INVC(REG,V,TC,PRC,'INV'));
$BATINCLUDE interpolate TCST_INVC 'REG' 'PRC' ",'0','0','0','0','0'" TC 'TCST_INVC(REG,TC,PRC)'

 TCST_ACTC(REG,TC,PRC)= sum(V,CST_ACTC(REG,V,TC,PRC));
$BATINCLUDE interpolate TCST_ACTC 'REG' 'PRC' ",'0','0','0','0','0'" TC 'TCST_ACTC(REG,TC,PRC)'

 TCST_FIXC(REG,TC,PRC)= sum(V,CST_FIXC(REG,V,TC,PRC));
$BATINCLUDE interpolate TCST_FIXC 'REG' 'PRC' ",'0','0','0','0','0'" TC 'TCST_FIXC(REG,TC,PRC)'

 T_COMBALEM(REG,TC,COM) = PAR_COMBALEM(REG,TC,COM,'ANNUAL');
$BATINCLUDE interpolate T_COMBALEM 'REG' 'COM' ",'0','0','0','0','0'" TC 'T_COMBALEM(REG,TC,COM)'

$BATINCLUDE interpolate COM_PROJ 'REG' 'COM' ",'0','0','0','0','0'" TC 'COM_PROJ(REG,TC,COM)'


* Attempt at putting parameter for results equal to variable:
  PAR_VCAPL(REG,TC,PRC) = VAR_CAP.L(REG,TC,PRC);
*  PAR_RCAPL(REG,TC,PRC) = Sum(V,VAR_RCAP.L(REG,V,TC,PRC));
*VAR_RCAP.L(REG,'2011',TC,PRC);




*excluding TVCOMBAL because of CO2 marginals TVCOMBAL(T,COM)  = PAR_COMBALEM('REGION1',T,COM,'ANNUAL');



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


* TVCAP(TC,PRC)     = PRC_RESID('REGION1',TC,PRC)+PAR_CAPL('REGION1',TC,PRC);
 TVCAP(TC,PRC)     = RESID('REGION1',TC,PRC)+PAR_CAPL('REGION1',TC,PRC);

 TVACT(TC,PRC)     = VARACT('REGION1',TC,PRC);
* TVCAP(TC,PRC)     = PAR_CAPL('REGION1',TC,PRC);

*Electricity and petroleum supply from TIMES ------------------

$ontext
 Initial years: Use historical generation data
 Subsequent years: Use TIMES results
$offtext

* Calculate final consumption for SATIM industry sectors and freight
 FLOW_IN_FS(FS,COM,TC) = SUM(PRC$MPRCFS(PRC,FS), TVFLOWIN(COM,TC,PRC));
 FLOW_OUT_FS(FS,COM,TC) = SUM(PRC$MPRCFS(PRC,FS), TVFLOWOUT(COM,TC,PRC));

* calculate final consumption
 FLOW_IN_FSFuels(FS,C,TC,TT) = SUM(COM$MCOMC(COM,C),FLOW_IN_FS(FS,COM,TC));
 FLOW_OUT_FSFuels(FS,C,TC,TT) = SUM(COM$MCOMC(COM,C),FLOW_OUT_FS(FS,COM,TC));

 FLOW_OUT_FSFactors(FS,F,TC,TT) = SUM(COM$MCOMF(COM,F),FLOW_OUT_FS(FS,COM,TC));


*bm methane rich gas is currently a product of sasol which is accounted for in SATIM, but not in eSAGE so making this zero
 FLOW_OUT_FSFuels('petr','cngas',TC,TT) = 0;

*Correction made for Pulp and paper own gen, this may have to be done to more sectors as own gen becomes more prevalent
 FLOW_IN_FSFuels('pp','celec',TC,TT) = FLOW_IN_FSFuels('pp','celec',TC,TT) - FLOW_OUT_FSFuels('pp','celec',TC,TT);



*UCONV_C_T2C(C);

*bm calc oil flow
 OIL_FLOW(RUN,TC) = SUM(PRC$MPRCFS(PRC,'petr'), TVACT(TC,PRC));

*bm calc coal flow
 COAL_FLOW(RUN,TC,'ccoal-low') = sum(FS,FLOW_IN_FSFuels(FS,'ccoal-low',TC,TT));
 COAL_FLOW(RUN,TC,'ccoal-hgh') = sum(FS,FLOW_IN_FSFuels(FS,'ccoal-hgh',TC,TT));


*bm not sure why yet but model goes unstable the second time round - need to look into it
*IF(TT1(TT),
 EIntensity_FS(FS,C,T)$SFORE_X(FS,T) = FLOW_IN_FSFuels(FS,C,T,TT)/SFORE_X(FS,T);
*);


* For households excluding private transport fuel expenditure
 FLOW_IN_FH(FH,COM,TC) = SUM(PRC$MPRCFH(PRC,FH), TVFLOWIN(COM,TC,PRC));
 FLOW_IN_FHFuels(FH,C,TC) = SUM(COM$MCOMC(COM,C),FLOW_IN_FH(FH,COM,TC));
*UCONV_C_T2C(C);

*bm calculating coal mining capacity based on consumption+exports)
 COALMINCAP(TC) = sum(FS,FLOW_IN_FSFuels(FS,'ccoal-hgh',TC,TT))+sum(FS,FLOW_IN_FSFuels(FS,'ccoal-low',TC,TT))+sum(FH,FLOW_IN_FHFuels(FH,'ccoal-hgh',TC));

* For households on transport
 FLOW_IN_FT(FT,COM,TC) = SUM(PRC$MPRCFT(PRC,FT), TVFLOWIN(COM,TC,PRC));
 FLOW_IN_FTFuels(FT,C,TC) = SUM(COM$MCOMC(COM,C),FLOW_IN_FT(FT,COM,TC));
*UCONV_C_T2C(C);

* multiply by share of pkm by household to allocate consumption to different hh
 FLOW_IN_FTFHFuels(FH,C,TC) = FLOW_IN_FTFuels('TPPR',C,TC)*PKMFH('TPPR',FH,TC);
* add transport fuels to other fuels
 FLOW_IN_FHAllFuels(FH,C,TC) = FLOW_IN_FHFuels(FH,C,TC)+FLOW_IN_FTFHFuels(FH,C,TC);

*!!! need to sort out public transport!!!
 EIntensity_FH(FH,C,TC)$TFHPOP_X(FH,TC) = FLOW_IN_FHAllFuels(FH,C,TC);
*/TFHPOP_X(FH,TC);

*IF(TT1(TT),

 FLOW_IN_FHFuelsGR(FH,C,TC)$EIntensity_FH(FH,C,TC-1) = EIntensity_FH(FH,C,TC)/EIntensity_FH(FH,C,TC-1);
*);
 FLOW_IN_FHFuelsGR('hhd-he','cpetr_o','2013') = 0;
 FLOW_IN_FHFuelsGR('hhd-he','cpetr_o','2014') = 0;
 FLOW_IN_FHFuelsGR('hhd-he','cpetr_o','2015') = 0;


 gammamgr(C,H,TC,TT) = SUM(FH$MFHHT(FH,H,TC),FLOW_IN_FHFuelsGR(FH,C,TC));

*bm Making a correction: the base year value in SATIM is very small, and jumps up a little bit for a strange reason.
*bm given the much larger base year value in eSAGE this causes a huge swing causing huge amounts of imports



*b
 ENCAP(SUPELE,XC,TC,TT) = TVNCAP(TC,SUPELE);

*Investment costs from TIMES ----------------------------------

$ontext
 Investment costs are based on year of build decision (TVNCAP) and the number
 of years needed to build the plant (lead time NCAP_LEAD).
 Annual cost = build capacity (TVNCAP) x unit cost (OBJ_ICOST) / years to build (NCAP_ILED)
 Calculation: Keep track of vintages (TP)
$offtext



*LOOP((REG,TTCH,T)$TVNCAP(REG,T,TTCH),
* LOOP(TP$((ORD(TP) GE ORD(T)) AND (ORD(TP) LT (ORD(T)+NCAP_ILED(REG,'2006',TTCH)))),
*  BPINV(XC,REG,T,TP,TTCH) = TVNCAP(REG,T,TTCH)/NCAP_ILED(REG,'2006',TTCH) * OBJ_ICOST(REG,T,TTCH,'CUR');
* );
*);
*b
NCAP_ILED('REGION1','2012',PRC)$(NCAP_ILED('REGION1','2012',PRC) EQ eps)= -1;


LOOP((PRC,TC)$(TVNCAP(TC,PRC) AND NCAP_ILED('REGION1','2012',PRC) GT 0),
 LOOP(TCP$((ORD(TCP) GE ORD(TC)) AND (ORD(TCP) LT (ORD(TC)+NCAP_ILED('REGION1','2012',PRC)))),
  BPINV(XC,TC,TCP,PRC)$NCAP_ILED('REGION1','2012',PRC) = TVNCAP(TC,PRC)/NCAP_ILED('REGION1','2012',PRC) * OBICOST('REGION1',TC,PRC);
 );
);
* investment cost with negative NCAL_ILED
LOOP((PRC,TC)$(TVNCAP(TC,PRC) AND NCAP_ILED('REGION1','2012',PRC) LT 0),
 LOOP(TCP$((ORD(TCP) LT ORD(TC)) AND (ORD(TCP) GE (ORD(TC)+NCAP_ILED('REGION1','2012',PRC)))),
  BPINV(XC,TC,TCP,PRC)$NCAP_ILED('REGION1','2012',PRC) = TVNCAP(TC,PRC)/(-1*NCAP_ILED('REGION1','2012',PRC)) * OBICOST('REGION1',TC,PRC);
 );
);


* expenditure schedule in billions (2007 from 2010)
 INVCOST(RUN,TC,TT,PRC) = SUM(TCP, BPINV(XC,TCP,TC,PRC))/1000;

*Sum across vintages to get total annual cost (billions of rands)
* EINVCOST(XC,T,TT) = SUM((SUPELE AND SUPOIL), INVCOST(XC,T,TT,ELE));
 EINVCOST(XC,TC,TT) = SUM(SUPELE, INVCOST(RUN,TC,TT,SUPELE));

* EFLOW('NAT',XC,TC,TT) = SUM(SUPELE, TVACT(TC,SUPELE))/3.6;
* !!EFLOW now calculated from flow through transmission. When we include distributed generation we also need to include them in the calc
 ELC_FLOW2(RUN,TC) = (TVACT(TC,'XAGRELC') + TVACT(TC,'XCOMELC') +TVACT(TC,'XINDELC') + TVACT(TC,'XRESELC') + TVACT(TC,'XTRAELC') + TVACT(TC,'XUPSELC'));
 ELC_FLOW(RUN,TC) = sum(FS,FLOW_IN_FSFuels(FS,'celec',TC,TT))+sum(FH,FLOW_IN_FHAllFuels(FH,'celec',TC))-FLOW_IN_FSFuels('EXP','celec',TC,TT);



 EIntensity_FS('elec',C,TC) = FLOW_IN_FSFuels('elec',C,TC,TT)/ELC_FLOW(RUN,TC);
 EIntensity_FS('hydr',C,TC)$FLOW_OUT_FSFuels('hydr','chydr',TC,TT) = FLOW_IN_FSFuels('hydr',C,TC,TT)/FLOW_OUT_FSFuels('hydr','chydr',TC,TT);


* ICAFSGR(C,FS,T,TT)$EIntensity_FS(FS,C,T-1) = EIntensity_FS(FS,C,T)/EIntensity_FS(FS,C,T-1);
*BM+FH 201218: SETTING STARTING POINT FOR HYDROGEN
 ICAFSGR(C,FS,T,TT)$(EIntensity_FS(FS,C,T-1) GT 0.00001) = EIntensity_FS(FS,C,T)/EIntensity_FS(FS,C,T-1);


 ICAFSGR(C,'nf',T,TT) = min(1,ICAFSGR(C,'nf',T,TT));

* ICAFSGR('cpetr_d','tranlp',T,TT) = 0.8;



* need to fix SUPELE to accommodate batteries.
*Also need to divide by sum of final demand rather than sum of generation to better accommodate storage and losses

* carbon tax resulting from cap (marginal)
*bm TCARBONTAX(XC,TC,TT) = T_COMBALEM('REGION1',TC,'CO2EQS')*(-0.791);


*Regulated Commodity price from TIMES ----------------------


* Electricity Price = (power plant costs + fuel costs)/total elc transmitted
*Power Plant Costs (excluding fuel)

 TCST_ELE_I(RUN,TC) = SUM(SUPELE,TCST_INVC('REGION1',TC,SUPELE));
 TCST_ELE_A(RUN,TC) = SUM(SUPELE,TCST_ACTC('REGION1',TC,SUPELE));
 TCST_ELE_F(RUN,TC) = SUM(SUPELE,TCST_FIXC('REGION1',TC,SUPELE));
 TCST_ELE_X(RUN,TC) = SUM(XELC,TCST_INVC('REGION1',TC,XELC)) + SUM(XELC,TCST_FIXC('REGION1',TC,XELC));

 TCST_ELE_INV(RUN,TC) = TCST_ELE_I(RUN,TC) + SUM(XELC,TCST_INVC('REGION1',TC,XELC));
 QFEGY_GR(RUN,TC)$TCST_ELE_INV(RUN,TC-1) = TCST_ELE_INV(RUN,TC)/TCST_ELE_INV(RUN,TC-1);

 FIntensity_FS('elec','fegy',TC) = TCST_ELE_INV(RUN,TC)/ELC_FLOW(RUN,TC);
 FIntensity_FS('elec',FLAB,TC) = FLOW_OUT_FSFactors('elec',FLAB,TC,TT)/ELC_FLOW(RUN,TC);

 IFAFSGR(F,FS,TC,TT)$FIntensity_FS(FS,F,TC-1) = FIntensity_FS(FS,F,TC)/FIntensity_FS(FS,F,TC-1);

*sum the components of elec costs calcs:
 TCST_ELE(RUN,TC) = TCST_ELE_I(RUN,TC) + TCST_ELE_A(RUN,TC)+TCST_ELE_F(RUN,TC) + TCST_ELE_X(RUN,TC);

* Coal costs
*detailed coal supply model calcs:
 TCST_COALSUP(RUN,TC) = SUM(COALSUP,TCST_INVC('REGION1',TC,COALSUP)+TCST_ACTC('REGION1',TC,COALSUP)+TCST_FIXC('REGION1',TC,COALSUP));

 TCST_PWRCLT(RUN,TC) = TCST_COALSUP(RUN,TC);

 TCST_PWROTH(RUN,TC) = (SIM_GGAS(RUN,TC)+1) * XRATE(RUN,'2012') / 1.055 * TVACT(TC,'XPWRGIC');


*still need to add CO2 tax here

* Elc Price
 ETPRICE(TC) = (TCST_PWRCLT(RUN,TC)+TCST_PWROTH(RUN,TC)+TCST_ELE(RUN,TC))/ELC_FLOW(RUN,TC);

*b add growth rates from TIMES from 2014 onward
 ETPRICEGR(TC)$(not (TIEPG(TC)+T1(TC)+TT1(TC))) = ETPRICE(TC)/ETPRICE(TC-1)-1;
* ETPRICEGR(TC) = 0.001;

 EPRICE(T1,TT)=PQ0('CELEC');

*b apply growth rate to calculate EPRICE
 loop(TC,
   if(not T1(TC),
     EPRICE(TC,TT) = EPRICE(TC-1,TT) * (1+ETPRICEGR(TC));
   );
 );



*Bil rands / TWh
*Rands/kWh
*celec        0.255008
*191


*--------------------------------------------------------------
*PASS RESULTS CGE TO TIMES
*--------------------------------------------------------------

*Committed build for TIMES -------------------------

*LOOP(T$(ORD(T) LT SMAX(TP$TT(TP), ORD(TP))),
LOOP(T$(ORD(T) LT COUNT),
 COMBUILD(PRC,T) = TVNCAP(T,PRC);
);


$ontext
 PUT  COMFILE;
 COMFILE.pc = 2;
 COMFILE.nd = 5;
 COMFILE.ap = 0;

 PUT 'PARAMETER ANCAP_BND /' /;
 LOOP((PRC,T)$(ORD(T) LT COUNT),
  EFVAL = COMBUILD(PRC,T);
  IF(EFVAL,
    PUT "REGION1.", T.TL, ".", PRC.TL, ".FX    ", EFVAL /;
  ELSE
    PUT "REGION1.", T.TL, ".", PRC.TL, ".FX    ", "EPS" /;
  );
 );
 PUTCLOSE "/;";
$offtext

SIM_FUELPX(FUELP,MY)   = SIM_FUELP(FUELP,RUN,MY);
SIM_TECHCX(TECHC,MY)   = SIM_TECHC(TECHC,RUN,MY);
SIM_NUCLEARCFX         = SIM_NUCLEARCF(RUN);
SIM_NUCLEARLTX         = SIM_NUCLEARLT(RUN);
SIM_SOLTPKNTX          = SIM_SOLTPKNT(RUN);
SIM_HYDIMPX            = SIM_HYDIMP(RUN);


* write results to viz-GDX file
   put_utilities SATIM_Scen 'gdxout' / "%GDXoutfolder%",RUN.TL:20;
*inputs
*   execute_unload Passengerkm Tonkm GDP_FSX POPSX SIM_DEMX F_IN F_OUT VARACT PRC_CAPACT PRC_RESID PAR_CAPL PAR_NCAPL PAR_COMBALEM PAR_NCAPR REG_OBJ CST_INVC CST_ACTC CST_FIXC;
  execute_unload MRUNCASE Passengerkm Tonkm GDP_FSX POPSX SIM_DEMX SIM_FUELPX SIM_TECHCX SIM_NUCLEARCFX SIM_NUCLEARLTX SIM_SOLTPKNTX SIM_HYDIMPX F_IN F_OUT VARACT PRC_CAPACT PRC_RESID PAR_CAPL PAR_VCAPL PAR_NCAPL PAR_COMBALEM PAR_NCAPR REG_OBJ CST_INVC CST_ACTC CST_FIXC ERPRICE ETPRICE INVCOST TCST_INVC TCST_ACTC TCST_FIXC TCST_ELE_I TCST_ELE_A TCST_ELE_F TCST_ELE_X TCST_COALSUP ELC_FLOW;
*VAR_RCAP PAR_RCAPL



*SIM_FUELPX SIM_TECHCX SIM_NUCLEARCFX SIM_NUCLEARLTX SIM_SOLTPKNTX SIM_HYDIMPX

* Reset BPINV
 BPINV(XC,TC,TCP,PRC) = 0;
