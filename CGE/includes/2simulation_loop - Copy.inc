
*Loop over simulations
LOOP(XC$(NOT fail),


    execute_load "mcdem_start.gdx" MFHHT SFORE_X TFHPOP_X SIM_DEMX PKMFH Passengerkm Tonkm;

* Loop over TIMES model solve periods
  LOOP(TT$(NOT fail),

*   Calculate start to next TIMES model solve period (TT+1)
    TTC(T)  = no;
    TTC(TT) = yes;
    COUNT = 0;
   LOOP(T,
     COUNT$TTC(T) = ORD(T);
    );

 TABAR(A,RD)=TA0(A,RD);

*Identify factors with upward-sloping supply curves
 FLS(F) = NO;
 FLS(F)$(CLOSURES(F,XC) EQ 4) = YES;


* get demand data for SATIM run
if( not TT1(TT),
  execute 'gdxxrw.exe i=SATM\DMD_PRJ.xlsx o=mcdem2.gdx index=index_E2G!a6';
  execute_load "mcdem2.gdx" SIM_DEMX PKMFH Passengerkm Tonkm;


* Adjust Transport Demand
  LOOP(TC,
        SIM_DEMX(TPPR,TC)$(SUM(H,QHX('cprtr',H,'base',TC-1,TT-1))) = SIM_DEMX(TPPR,TC-1)*SUM(H,QHX('cprtr',H,'base',TC,TT-1))/SUM(H,QHX('cprtr',H,'base',TC-1,TT-1));
);
* LOOP(TC,


);
*if( not TT1(TT),


* Demand DDS File
    PUT  SIM_DEM_FILE;
    SIM_DEM_FILE.pc = 2;
    SIM_DEM_FILE.nd = 5;
    SIM_DEM_FILE.ap = 0;

    PUT 'PARAMETER ACOM_PROJ /' /;

    LOOP((DEM1,NMY1),
  EFVAL = SIM_DEMX(DEM1,NMY1);
  if(EFVAL,
    PUT "REGION1.", DEM1.TL, ".", NMY1.TL, EFVAL /;
ELSE
    PUT "REGION1.", DEM1.TL, ".", NMY1.TL, "EPS" /;
  );
);
PUTCLOSE "/;";

*$exit
*Initialize CGE model parameters and variables
$include cge\includes\2varinit.inc

* Run SATIM
$include cge\includes\2runTIMES.inc

* make acoal output leontief - controlled by SATIM - see theta calcs below
 ACET2('acoal') = YES;
 ACET2('apetr') = YES;


*Energy supply projection from TIMES
 TFLOW(A,TECHTYPE,RUN,TC,TT) = SUM(PRC$MPRCATYPE(PRC,A,TECHTYPE), TVACT(TC,PRC));
 TCAP(A,RUN,TC,TT) = SUM(PRC$MPRCA(PRC,A), TVCAP(TC,PRC));
 ECAP(XC,TC,TT) = TCAP('AELEC',RUN,TC,TT);
 PCAP(XC,TC,TT) = TCAP('APETR',RUN,TC,TT);
 HCAP(XC,TC,TT) = TCAP('AHYDR',RUN,TC,TT);;

*Extract electricity and oil products production from SATIM
 EFLOW(TECHTYPE,XC,TC,TT) = TFLOW('AELEC',TECHTYPE,RUN,TC,TT);
* PFLOW(TECHTYPE,XC,TC,TT) = TFLOW('APETR',TECHTYPE,RUN,TC,TT);
 PFLOW(TECHTYPE,XC,TC,TT) = sum(C,FLOW_OUT_FSFuels('petr',C,TC,TT));

* Extract fuel inputs from SATIM

* For elc and oil products (until the other sectors are aggregated in the same way)
 FLOW_IN_A(A,COM,TC) = SUM(PRC$MPRCA(PRC,A), TVFLOWIN(COM,TC,PRC));
 FLOW_IN_AFuels(A,C,TC,TT) = SUM(COM$MCOMC(COM,C),FLOW_IN_A(A,COM,TC))*UCONV_C_T2C(C);

* do reverse mapping for industry sectors (excludes power and petroleum)
 ICAGR(CXEP,A,TC) = SUM(FSXEP$MFSA(FSXEP,A),ICAFSGR(CXEP,FSXEP,TC,TT));
 IFAGR(F,A,TC) = SUM(FS$MFSA(FS,A),IFAFSGR(F,FS,TC,TT));

*BM correction on power sector from freight demand for moving coal
 ICAGR('cftrp-l','aelec',TC) = ICAGR('ccoal-low','aelec',TC);


*   Loop over CGE model solve periods
  LOOP(TC$(NOT fail),

*   CA calculate units of capital required given capacity from times (units not consistent with CGE)
    EAFXCAP(XC,TC,TT)$(EFX(TT,TC) AND ifa('FEGY','AELEC','nat')) = ifa('FEGY','AELEC','nat')*iva('AELEC','nat')*ECAP(XC,TC,TT);
*fh 71218
*bm+fh 201118 removed - already in 2runtimes.inc
    PAFXCAP(XC,TC,TT)$(EFX(TT,TC) AND ifa('FCAP','APETR','nat')) = ifa('FCAP','APETR','nat')*iva('APETR','nat')*PFLOW('oil',XC,TC,TT);

      IF(NOT T1(TC),

*       ENERGY: Carbon tax rate
*        tco2d = SIM_CO2PRICE(RUN,TC)/1000;
*        tco2e = SIM_CO2PRICE(RUN,TC)/1000;
*        tco2m = SIM_CO2PRICE(RUN,TC)/1000;

*       ENERGY: Retaliatory carbon tax on RSA exports
        rtco2e = RTCO2ESIM(XC,TC);

*       ENERGY: Carbon content cofficient
$include cge\includes\2carbon.inc
*        co2c(C)    = CO2CSIM(C,XC,TC);
*FH        co2e(C,RW) = co2e(C,RW) * CLEANTECH(C,XC,TC);
*FH        co2m(C,RW) = co2m(C,RW) * CLEANTECH(C,XC,TC);
*        co2e(C,RW) = CO2ESIM(C,RW,XC,TC);
*        co2m(C,RW) = CO2MSIM(C,RW,XC,TC);
*        co2e(C,RW) = 0;
*        co2m(C,RW) = 0;

*FH
        tabar(CTA,'NAT')=tabar(CTA,'NAT')+CTA_EMRR(CTA);

*       Long term TFP growth
        alphava(A,RD) = alphava(A,RD) * (1+TFPGR(A,RD,XC,TC));

*FH  removed inclusion by SG causing elec employment to explode
*        leova(A,RD) = leova(A,RD) * (1+TFPGR(A,RD,XC,TC));

*fh CHANGED TO ABOVE
*        alphava(A,RD) = alphava(A,RD) * (1+SECGR(A,RD,XC,TC)/100);
*        leova(A,RD) = leova(A,RD) * (1+SECGR(A,RD,XC,TC)/100);

*       Long term factor-specific productivity growth
        fprd(F,A,RD)$(NOT AFX(A,RD)) = fprd(F,A,RD) * (1+FPRDGR(F,XC,TC));

*       World price changes - standard CGE input
*FH: REMOVED CODE AND RESET TO ORIGINAL CODE
        pwebar(C,RW) = pwebar(C,RW) * (1+PWGR(C,RUN,TC));
        pwmbar(C,RW) = pwmbar(C,RW) * (1+PWGR(C,RUN,TC));
*fh 211218
        pwmbar('CVEHI','REST') = pwmbar('CVEHI','REST');
*        pwebar(C,RW) = pwebar(C,RW) * (1+PWEGR(C,XC,TC));
*        pwmbar(C,RW) = pwmbar(C,RW) * (1+PWMGR(C,XC,TC));

        rhova(A,RD) = rhova_coal(A,RD,XC,TC);

*       Population growth
        hpop(H) = hpop(H) * (1+POPGR(H,XC,TC));
$ontext
*fh: link population growth to average annual satim growth by group
        hpop('hhd-0' ) = hpop('hhd-0' ) * (1+(((tfhpop_x('hhd-le','2050')+tfhpop_x('hhd-ln','2050'))/(tfhpop_x('hhd-le','2012')+tfhpop_x('hhd-ln','2012')))**(1/(2050-2012))-1));
        hpop('hhd-1' ) = hpop('hhd-1' ) * (1+(((tfhpop_x('hhd-le','2050')+tfhpop_x('hhd-ln','2050'))/(tfhpop_x('hhd-le','2012')+tfhpop_x('hhd-ln','2012')))**(1/(2050-2012))-1));
        hpop('hhd-2' ) = hpop('hhd-2' ) * (1+(((tfhpop_x('hhd-le','2050')+tfhpop_x('hhd-ln','2050'))/(tfhpop_x('hhd-le','2012')+tfhpop_x('hhd-ln','2012')))**(1/(2050-2012))-1));
        hpop('hhd-3' ) = hpop('hhd-3' ) * (1+(((tfhpop_x('hhd-le','2050')+tfhpop_x('hhd-ln','2050'))/(tfhpop_x('hhd-le','2012')+tfhpop_x('hhd-ln','2012')))**(1/(2050-2012))-1));
        hpop('hhd-4' ) = hpop('hhd-4' ) * (1+(((tfhpop_x('hhd-me','2050')+tfhpop_x('hhd-mn','2050'))/(tfhpop_x('hhd-me','2012')+tfhpop_x('hhd-mn','2012')))**(1/(2050-2012))-1));
        hpop('hhd-5' ) = hpop('hhd-5' ) * (1+(((tfhpop_x('hhd-me','2050')+tfhpop_x('hhd-mn','2050'))/(tfhpop_x('hhd-me','2012')+tfhpop_x('hhd-mn','2012')))**(1/(2050-2012))-1));
        hpop('hhd-6' ) = hpop('hhd-6' ) * (1+(((tfhpop_x('hhd-me','2050')+tfhpop_x('hhd-mn','2050'))/(tfhpop_x('hhd-me','2012')+tfhpop_x('hhd-mn','2012')))**(1/(2050-2012))-1));
        hpop('hhd-7' ) = hpop('hhd-7' ) * (1+(((tfhpop_x('hhd-me','2050')+tfhpop_x('hhd-mn','2050'))/(tfhpop_x('hhd-me','2012')+tfhpop_x('hhd-mn','2012')))**(1/(2050-2012))-1));
        hpop('hhd-8' ) = hpop('hhd-8' ) * (1+(((tfhpop_x('hhd-he','2050')+tfhpop_x('hhd-hn','2050'))/(tfhpop_x('hhd-he','2012')+tfhpop_x('hhd-hn','2012')))**(1/(2050-2012))-1));
        hpop(hhd9)     = hpop(hhd9)     * (1+(((tfhpop_x('hhd-he','2050')+tfhpop_x('hhd-hn','2050'))/(tfhpop_x('hhd-he','2012')+tfhpop_x('hhd-hn','2012')))**(1/(2050-2012))-1));
$offtext

* phase out elc price differential over time - this should only apply to industry!!! - need to fix !!!
         IF(ord(TC) lt 8,
            tui(C,A,RD) = tui(C,A,RD)*.5;
         );

*       CA driven by previous year gdp growth (see bottom of TC loop)
        trnsfr(INS,ACNT) = trnsfr(INS,ACNT) * (1+TRNSFRGR(INS,ACNT,XC,TC));


*fh 291118: SANEDI-EV shocks
  deltaq(cm,rw) = deltaq0(cm,rw);
  deltaq('cvehi','rest') = deltaq('cvehi','rest')*(deltaqev('cvehi','rest',run,tc));

  deltat(cm,rw) = deltat0(cm,rw);
*  deltat('cvehi','rest') = deltat('cvehi','rest')*(deltatev('cvehi','rest',run,tc));


*bm make ratio of coal outputs exogenous and control from SATIM outputs
  theta('acoal','ccoal-low') = COAL_FLOW(RUN,TC,'ccoal-low')/sum(C,COAL_FLOW(RUN,TC,C))*(1-(theta('acoal','cmore')+theta('acoal','cmine')));
  theta('acoal','ccoal-hgh') = COAL_FLOW(RUN,TC,'ccoal-hgh')/sum(C,COAL_FLOW(RUN,TC,C))*(1-(theta('acoal','cmore')+theta('acoal','cmine')));

* adjust ica and ifa for acoal based on previous pacoal and new theta
  pacoalx(TC,RUN) = sum(CCOAL,theta('acoal',CCOAL)*pq0(CCOAL))/sum(CCOAL,theta('acoal',CCOAL));
*  ICAGR(C,'acoal',TC)$pacoalx(TC-1,RUN) = pacoalx(TC,RUN)/pacoalx(TC-1,RUN);
*  IFAGR(F,'acoal',TC)$pacoalx(TC-1,RUN) = pacoalx(TC,RUN)/pacoalx(TC-1,RUN);



* make adjustments to ica

*BM+FH 201218: SETTING STARTING POINT FOR HYDROGEN
 ica('chydr',A,'NAT')$(SUM(FSXEP$MFSA(FSXEP,A),EIntensity_FS(FSXEP,'chydr',TC-1)) LT 0.0001 and SUM(FSXEP$MFSA(FSXEP,A),EIntensity_FS(FSXEP,'chydr',TC)) GT 0.00001 AND ica('chydr',A,'NAT'))
                         = SUM(FSXEP$MFSA(FSXEP,A),EIntensity_FS(FSXEP,'chydr',TC));

* calculate ica change for private passenger. This needs to be generalised to other household end-uses
  EHIntensity(C,'aprtr',TC) = FLOW_IN_FTFuels('tppr',C,TC)/sum(TPPR,COM_PROJ('REGION1',TC,TPPR));


*BM 190320: SETTING STARTING POINT FOR ICA private transport
 ica('celec','aprtr','NAT')$(EHIntensity('celec','aprtr',TC-1) LT 0.0001 and EHIntensity('celec','aprtr',TC) GT 0.00001)
                         = EHIntensity('celec','aprtr',TC)/EHIntensity('cpetr_p','aprtr',TC)*ica('cpetr_p','aprtr','NAT');

  icagr(C,'aprtr',TC)$EHIntensity(C,'aprtr',TC-1) = EHIntensity(C,'aprtr',TC)/EHIntensity(C,'aprtr',TC-1);






  ica(C,A,'NAT')$ICAGR(C,A,TC) = ica(C,A,'NAT')*ICAGR(C,A,TC);


  if(ORD(TC) gt 28,ica('ccoal-low','apetr','NAT') = 0);

  if(ORD(TC) gt 1,ica('ccoal-low','acoal','NAT') = 0);


  QA.L('ahydr')$(HCAP(XC,TC,TT) gt 0.00001) = FLOW_OUT_FSFuels('hydr','chydr',TC,TT);

*fh 12/11/19: changing from LES to CD
$ontext
* for Households
  gammam(C,H)$gammamgr(C,H,TC,TT) = gammam(C,H)*gammamgr(C,H,TC,TT);

*bm work in progress          gammam(C,H)$(gammagr(C,H,TC) and not(gammam(C,H)) =

*);
$offtext

*fh
         EFLOW(TECHTYPE,XC,TC,TT) = max(EFLOW(TECHTYPE,XC,TC,TT),0.1);
*          EFLOW(RDNT,XC,TC,TT) = max(EFLOW(RDNT,XC,TC,TT),1);


*b, apply change to IFA

          ifa(F,A,'nat') = ifa(F,A,'nat')*IFAGR(F,A,TC);


         ICA('celec','AHYDR','nat')$(SUM(A,ICA('CHYDR',A,'nat')) GT 0.001) = EIntensity_FS('hydr','celec',TC);
         ICA('cngas','AHYDR','nat')$(SUM(A,ICA('CHYDR',A,'nat')) GT 0.001 and EIntensity_FS('hydr','cngas',TC)) = EIntensity_FS('hydr','cngas',TC);



*bm/sr/fh added this to save model from crashing from demand for ccoal-low disapearing completely.
          ica('ccoal-low',A,'NAT')$ica0('ccoal-low',A,'NAT') = max(ica('ccoal-low',A,'NAT'),0.0004);
          ica('ccoal-low','ahydr','NAT') = 0.00000001;

*       ENERGY: Set electricity sector capital growth rate equal to TIMES results
*       CA: 2capital.inc modified to use EINVCOST
*       CA: below is modified to determine energy capital necessary given capacity data from TIMES
*       CA; below we do not worry about units of capital as we calculate growth rates
*       CA: note that below accommodates evluation in ifa and iva if imposed
          AFX('AELEC',RD) = NO;
          AFX('AELEC',RD)$EFX(TT,TC) = YES;
*CA  slow electricity capital growth when utilization rate is low outside of TIMES periods
          AFX('AELEC',RD)$(NOT EFX(TT,TC) AND QFSUPX('FEGY',XC,TC-1,TT) LT .9) = YES;

          AFX('APETR',RD) = NO;
          AFX('APETR',RD)$EFX(TT,TC) = YES;
*FH 71218
          AFX('APETR',RD)$(NOT EFX(TT,TC) AND QFSUPX('FCAP',XC,TC-1,TT) LT .9) = YES;
*          AFX('APETR',RD)$(NOT EFX(TT,TC) AND QFSUPX('FSAS',XC,TC-1,TT) LT .9) = YES;

         AFX('AHYDR',RD) = NO;
*         AFX('AHYDR',RD)$(SUM(A,ICA('CHYDR',A,'nat')) GT 0.001) = YES;
         AFX('AHYDR',RD)$(NOT T1(TC)) = YES;
         AFLEO('AHYDR') = NO;
         AFLEO('AHYDR')$(SUM(A,ICA('CHYDR',A,'nat')) GT 0.001) = YES;


         AFX('ACOIL',RD) = NO;


*bm 05062019          AFXGR('AELEC','NAT',XC,TC)$EFX(TT,TC) = EAFXCAP(XC,TC,TT)/EAFXCAP(XC,TC-1,TT)- 1;
          AFXGR('aelec','NAT',XC,TC)$EFX(TT,TC) = QFEGY_GR(RUN,TC)- 1;

          AFXGR('aelec','NAT',XC,TC)$(NOT EFX(TT,TC) AND QFSUPX('FEGY',XC,TC-1,TT) LT .9) = -natdrate;


*bmfh coal sector
          AFX('acoal',RD)$EFX(TT,TC) = YES;


          CCAP(TC,TT) = sum(C,FLOW_OUT_FSFUELS('coal',C,TC,TT));
          AFXGR('ACOAL','NAT',XC,TC)$(COALMINCAP(TC-1) and pacoalx(TC-1,RUN)) = (COALMINCAP(TC)/COALMINCAP(TC-1)*pacoalx(TC,RUN)/pacoalx(TC-1,RUN))-1;

*bm cap decrease to 5%
*          if(TT1(TT), AFXGR('ACOAL','NAT',XC,TC)$(AFXGR('ACOAL','NAT',XC,TC) LT -.05) = -.05);
*          AFXGR('ACOAL','NAT',XC,TC)$(AFXGR('ACOAL','NAT',XC,TC) LT -.05) = -.05;


          QE.FX('ccoal-hgh','REST')$FLOW_IN_FSFuels('EXP','ccoal-hgh',TC-1,TT) = QE.L('ccoal-hgh','REST')*FLOW_IN_FSFuels('EXP','ccoal-hgh',TC,TT)/FLOW_IN_FSFuels('EXP','ccoal-hgh',TC-1,TT) ;

          AFLEO('ACOAL')$(NOT T1(TC)) = YES;




*bm/fh added petroleum sector


           AFXGR('APETR','NAT',XC,TC)$EFX(TT,TC) = PAFXCAP(XC,TC,TT)/PAFXCAP(XC,TC-1,TT)- 1;

*FH 71218
*           AFXGR('APETR','NAT',XC,TC)$(NOT EFX(TT,TC) AND QFSUPX('FCAP',XC,TC-1,TT) LT .9) = -natdrate;
*           AFXGR('APETR','NAT',XC,TC)$(NOT EFX(TT,TC) AND QFSUPX('FSAS',XC,TC-1,TT) LT .9) = -natdrate;
*           AFXGR('APETR','NAT',XC,'2044') = 0;
*           AFXGR('APETR','NAT',XC,'2045') = 0;
*           AFXGR('APETR','NAT',XC,'2046') = 0;
*           AFXGR('APETR','NAT',XC,'2047') = 0;
*           AFXGR('APETR','NAT',XC,'2048') = 0;
*           AFXGR('APETR','NAT',XC,'2049') = 0;
*           AFXGR('APETR','NAT',XC,'2050') = 0;

*           QE.FX('cpetr_o','REST')$FLOW_IN_FSFuels('EXP','cpetr_o',TC-1,TT) = QE.L('cpetr_o','REST')*FLOW_IN_FSFuels('EXP','cpetr_o',TC,TT)/FLOW_IN_FSFuels('EXP','cpetr_o',TC-1,TT);
*           QE.FX('cpetr_d','REST') = FLOW_IN_FSFuels('EXP','cpetr_d',TC,TT);
*           QE.FX('cpetr_p','REST') = FLOW_IN_FSFuels('EXP','cpetr_p',TC,TT);

           theta('apetr','cpetr_o') = FLOW_OUT_FSFuels('petr','cpetr_o',TC,TT)/sum(C,FLOW_OUT_FSFuels('petr',C,TC,TT));
           theta('apetr','cpetr_d') = FLOW_OUT_FSFuels('petr','cpetr_d',TC,TT)/sum(C,FLOW_OUT_FSFuels('petr',C,TC,TT));
           theta('apetr','cpetr_p') = FLOW_OUT_FSFuels('petr','cpetr_p',TC,TT)/sum(C,FLOW_OUT_FSFuels('petr',C,TC,TT));


*bm/fh/fa .L on refineries
*  QXAC.L('apetr',c)$AFXGR('APETR','NAT',XC,TC) = QXAC.L('apetr',c)*AFXGR('APETR','NAT',XC,TC);
*fh  QA.L('apetr')$AFXGR('APETR','NAT',XC,TC) = QA.L('apetr')*AFXGR('APETR','NAT',XC,TC);
  QXAC.L('apetr',c)$AFXGR('APETR','NAT',XC,TC) = QXAC.L('apetr',c)*(1+AFXGR('APETR','NAT',XC,TC));
  QA.L('apetr')$AFXGR('APETR','NAT',XC,TC) = QA.L('apetr')*(1+AFXGR('APETR','NAT',XC,TC));

*  QINT.L(c,'apetr')$AFXGR('APETR','NAT',XC,TC) = QINT.L(c,'apetr')*AFXGR('APETR','NAT',XC,TC);
  QINT.L(c,'apetr')$AFXGR('APETR','NAT',XC,TC) = QINT.L(c,'apetr')*(1+AFXGR('APETR','NAT',XC,TC));

*fh  QVA.L('apetr','nat')$AFXGR('APETR','NAT',XC,TC) = QVA.L('apetr','nat')*AFXGR('APETR','NAT',XC,TC);
  QVA.L('apetr','nat')$AFXGR('APETR','NAT',XC,TC) = QVA.L('apetr','nat')*(1+AFXGR('APETR','NAT',XC,TC));
  QF.L(FLAB,'APETR',RD)$AFXGR('APETR','NAT',XC,TC) = QF.L(FLAB,'APETR',RD)*(1+AFXGR('APETR','NAT',XC,TC));


*BM+FH 201218: SETTING STARTING POINT FOR HYDROGEN
* QF.L('FCAP','AHYDR','NAT')$(NOT HCAP(XC,TC,TT)) =  QF.L('FCAP','AHYDR','NAT')*(1+RKAP('FCAP','altrp_f','NAT'));
* QF.L('FCAP','AHYDR','NAT')$(HCAP(XC,TC,TT) GT 0.00001) = ifa('FCAP','AHYDR','NAT')*iva('AHYDR','NAT')*FLOW_OUT_FSFuels('hydr','chydr',TC,TT);
* QF.L(F,'AHYDR','NAT')$(HCAP(XC,TC,TT) GT 0.00001) = ifa(F,'AHYDR','NAT')*iva('AHYDR','NAT')*FLOW_OUT_FSFuels('hydr','chydr',TC,TT);

*bm hydrogen not in public transport in SAM so leaving it out for now
 QF.L(F,'AHYDR','NAT')$(HCAP(XC,TC,TT) GT 0.00001) = ifa(F,'AHYDR','NAT')*iva('AHYDR','NAT')*FLOW_IN_FSFuels('tranlf','chydr',TC,TT);


*bm set reasonable starting value for QVA otherwise wfdist goes -ve.
 QVA.L('AHYDR','NAT')$(HCAP(XC,TC,TT) GT 0.00001) = sum(F,QF.L(F,'AHYDR','NAT'));
 PVA.L('AHYDR','NAT')$(HCAP(XC,TC,TT) GT 0.00001) = 1;

* QINTA.L('AHYDR','NAT')$(HCAP(XC,TC,TT) GT 0.00001) = FLOW_OUT_FSFuels('hydr','CHYDR',TC,TT);
 QINTA.L('AHYDR','NAT')$(HCAP(XC,TC,TT) GT 0.00001) = FLOW_IN_FSFuels('tranlf','CHYDR',TC,TT);

 QINT.L(C,'AHYDR')$(HCAP(XC,TC,TT) GT 0.00001) = ica(C,'AHYDR','NAT')*QINTA.L('AHYDR','NAT');





*CA fix imports in accordance with TIMES for all periods
          QM.FX('CELEC','REST') =  FLOW_OUT_FSFuels('imp','celec',TC,TT);
*IF(ord(TC) gt 17,
*     CERES('cpetr_d')= YES;
*     CEFIX('cpetr_d')=YES;
*     QM.FX('cpetr_d','REST') =  FLOW_OUT_FSFuels('imp','cpetr_d',TC,TT);
*);

*bm+fh 20190207
* QM.FX('cpetr_o','rest')$PFLOW('imp',XC,TC-1,TT) = QM.L('cpetr_o','rest')*PFLOW('imp',XC,TC,TT)/PFLOW('imp',XC,TC-1,TT);

*if(ord(TC) gt 9,
* QM.FX('cpetr_t','rest')$PFLOW('imp',XC,TC-1,TT) = QM.L('cpetr_t','rest')*(1+(PFLOW('imp',XC,TC,TT)/PFLOW('imp',XC,TC-1,TT)-1)/2);
* QM.FX('cpetr','rest')$PFLOW('imp',XC,TC-1,TT) = QM.L('cpetr','rest')*PFLOW('imp',XC,TC,TT)/PFLOW('imp',XC,TC-1,TT);
*);



*CA
 ANFX(A,RD)=NO;

*fh
 AFX('AGOLD',RD)=YES;
 ANFX(A,RD)$(NOT AFX(A,RD))=YES;
 AFXGR('AGOLD','NAT',XC,TC) = -0.001;
*bm
 AFLEO('AGOLD') = YES;

* AFXGR('AGOLD','NAT',XC,TC) = 0.08;

$ontext
 AFX('AMORE',RD)=YES;
 ANFX(A,RD)=NO;
 ANFX(A,RD)$(NOT AFX(A,RD))=YES;
 AFXGR('AMORE','NAT',XC,TC) = 0.03;
* AFXGR('AMORE','NAT',XC,TC) = 0.3;

 AFX('APAPR',RD)=YES;
 ANFX(A,RD)=NO;
 ANFX(A,RD)$(NOT AFX(A,RD))=YES;
 AFXGR('APAPR','NAT',XC,TC) = -0.005;
* AFXGR('APAPR','NAT',XC,TC) = -0.05;
$offtext

*tmp          QM.FX('CPETR','REST') = PFLOW('IMP',XC,TC,TT);
*         QE.FX?

*        );
*       end of IF ord(tt) gt 1 condition

*       Capital stock accumulation and allocation
$include cge\includes\2capital.inc

*       ENERGY: Tech change in energy use via input output matrix
*       Share of new capital in total
        ishr(A,RD)$SUM(FCAP, QF.L(FCAP,A,RD)) = SUM(FCAP, DKAP(FCAP,A,RD))/SUM(FCAP, QF.L(FCAP,A,RD));
        ishr(A,RD)$(ishr(A,RD) GT 1) = 1;
*       Evolve IO coefficient
*bm        ica(CEGY,A,RD)$ica(CEGY,A,RD) = (1-ishr(A,RD))*ica(CEGY,A,RD) + ishr(A,RD)*ica(CEGY,A,RD)*(PQ.L(CEGY)/PQ0(CEGY)/(DPI.L/DPI0))**rhoegyint(CEGY,XC,TC);
*       Tech change in energy use for households
*bm        betam(CEGY,H) = betam(CEGY,H)*((PQ.L(CEGY)/CPI.L)/(PQ0(CEGY)/CPI0))**rhoegyhhd(CEGY,XC,TC);
*bm        betam(C,H)$EH0(H) = betam(C,H)/SUM(CP, betam(CP,H));

*       Land expansion
        QF.L('FLND',A,RD) = QF.L('FLND',A,RD)*(1+FACGR('FLND',XC,TC));

*       Labor supply growth
        QF.L(FLAB,A,RD)$(NOT T1(TC)) = QF.L(FLAB,A,RD)*(1+FACGR(FLAB,XC,TC));

*       Total factor supply
        QFS.L(F) = SUM((RD,A), QF.L(F,A,RD));





      );
*     end NOT T1(TC) loop

$include cge\includes\2closures.inc

*FH: Removed code
$ontext
*CA     Trend wfdist factors for labor towards 1
        IF(ORD(TC) GE 2 AND ORD(TC) LE 11,
            WFDIST.FX(FLAB,A,RD)$WFDIST0(FLAB,A,RD)=WFDIST0(FLAB,A,RD)+(ORD(TC)-1)*(1-WFDIST0(FLAB,A,RD))/10;
        );
        IF(ORD(TC) GT 11,
            WFDIST.FX(FLAB,A,RD)$WFDIST0(FLAB,A,RD)=1;
        );
$offtext

*bm!    IF(ORD(TT) gt 1 AND NOT T1(TC),
    IF(NOT T1(TC),
*       CA add tax adjustment variable for electricity
*       ENERGY: Adjust fixed electricity price

*        PQ.FX('CELEC') = EPRICE(TC,TT);
*        TQELEC.LO('CELEC') = -INF;
*        TQELEC.UP('CELEC') = +INF;


*bm set hydrogen price to diesel price based on SATIM
*        PQ.FX('CHYDR')$(SUM(A,ICA('CHYDR',A,'nat')) GT 0.001) = PQ.L('cpetr_d')*1.7;
*        TQELEC.LO('CHYDR')$(SUM(A,ICA('CHYDR',A,'nat')) GT 0.001) = -INF;
*        TQELEC.UP('CHYDR')$(SUM(A,ICA('CHYDR',A,'nat')) GT 0.001) = +INF;

*bm to recalc household budget shares
$include cge\includes\EnergyGoodsBudgetAllocation.inc


*bm to recalc household budget shares
$include cge\includes\BudgetShare_Recalc.inc


$ontext
*fh 71218
        PQ.FX('CPETR_D') = PM.L('CPETR_D','rest');
        TQELEC.LO('CPETR_D') = -INF;
        TQELEC.UP('CPETR_D') = +INF;

        PQ.FX('CPETR_O') = PM.L('CPETR_O','rest');
        TQELEC.LO('CPETR_O') = -INF;
        TQELEC.UP('CPETR_O') = +INF;

        PQ.FX('CPETR_P') = PM.L('CPETR_P','rest');
        TQELEC.LO('CPETR_P') = -INF;
        TQELEC.UP('CPETR_P') = +INF;
$offtext
);
*     end of IF ord(tt) gt 1 condition

*CA Benchmark labor market supply curve on the fly
*JT: AE paper (removed this code)
*    WF_BAR(FLS)  = WFX(FLS,'BASE',TC,TT);
*    QFS_BAR(FLS) = QFSX(FLS,'BASE',TC,TT);

*CA set complementarity conditions on energy factor returns
      QFS_FOR.L(FCAP)=0;
      QFS_FOR.UP(FCAP)=+INF;
      QFS_FOR.lo(FCAP)=-INF;
*FH 71218
      QFS_FOR.LO('FEGY')=0;
*      QFS_FOR.LO('FSAS')=0;
*      QFS_FOR.LO(EFSET)=0;
      ALPHAQF.LO= -INF;
      ALPHAQF.UP= +INF;
      QFS.FX('FCAP')=QFS.L('FCAP');
*FH 71218
      QFS.UP('FEGY')=QFS.L('FEGY');
*      QFS.UP('FSAS')=QFS.L('FSAS');
*      QFS.UP(EFSET)=QFS.L(EFSET);

*FH 71218
      QF.UP('FEGY','AELEC','NAT')= +INF;
      QF.LO('FEGY','AELEC','NAT')= -INF;
*      QF.UP('FSAS','APETR','NAT')= +INF;
*      QF.LO('FSAS','APETR','NAT')= -INF;
*      QF.UP(EFSET,EASET,'NAT')$EAFMAP(EASET,EFSET)= +INF;
*      QF.LO(EFSET,EASET,'NAT')$EAFMAP(EASET,EFSET)= -INF;

      QF.UP('FCAP',A,RD)$QF0('FCAP',A,RD)=+INF;
      QF.LO('FCAP',A,RD)$QF0('FCAP',A,RD)=-INF;

*bm test aprtr
*  iva('aprtr','nat') = 0;


      SOLVE standcge USING MCP ;

      fail$(standcge.modelstat ne 1)=1;
      abort$(abs(walras.l) gt .001 AND NOT fail) "Walras' law lost", walras.l;

*CATemp make GAMS stop at or near error for debugging
*      fail$(ord(tt) eq 1 AND ord(tc) eq 1)=1;

        CTA_EM(A)=(QINT.L('CCOAL-LOW',A)*CO2C('CCOAL-LOW')
                  +QINT.L('CCOAL-HGH',A)*CO2C('CCOAL-HGH')
                  +QINT.L('CCOIL',A)*CO2C('CCOIL')
                  +QINT.L('CNGAS',A)*CO2C('CNGAS'));

        CTA_EMR(A)= CTA_EM(A)*(SIM_CO2PRICE(RUN,TC)/1000);

        CTA_EMRR(A)$(PAR.L(A,'NAT')*QAR.L(A,'NAT'))=CTA_EMR(A)/(PAR.L(A,'NAT')*QAR.L(A,'NAT'));

$include cge\includes\2results.inc

*       CA make growth in transfers from government to HH a function of nominal absorption growth plus a small increment
      IF(NOT T1(TC),
        TRNSFRGR(H,'GOV',XC,TC+1)=TABS.L/TABSX(XC,TC-1,TT)-1 + .005;
      );

     CTA_EMRR(CTA)=CTA_EMRRX(CTA,RUN,XC,TC,TT-1);
    );
*   end TC loop

* generate demand projection, fuel price projection and investment schedules for the next TIMES run
$include cge\includes\2energyfcast.inc
$include cge\includes\2energychecks.inc



  );
*end TT loop

);
*end XC loop



