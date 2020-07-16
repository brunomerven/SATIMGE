*=============================================================================*
* PREPONLY.MOD oversees that all inputs are inperpolated when INTEXT_ONLY     *
*   %1 - mod or v# for the source code to be used                             *
*=============================================================================*
$IFI NOT %PREP_ANS%==YES $SET PREP_ANS NO
$IFI NOT %1==%PREP_ANS%  $EXIT
$IFI %PREP_ANS%==YES $GOTO POSTINT
*=============================================================================
* COST PARAMETERS: Interpolated by COEF_OBJ, only special options processed here
*-----------------------------------------------------------------------------
$BATINCLUDE prepparm NCAP_COST 'R' 'P,CUR' ",'0','0','0'" T 'RTP(R,T,P)' EPS 3
$BATINCLUDE prepparm NCAP_DCOST 'R' 'P,CUR' ",'0','0','0'" T 'RTP(R,T,P)' EPS 3
$BATINCLUDE prepparm NCAP_DLAGC 'R' 'P,CUR' ",'0','0','0'" T 'RTP(R,T,P)' EPS 3
$BATINCLUDE prepparm NCAP_FOM 'R' 'P,CUR' ",'0','0','0'" T 'RTP(R,T,P)' EPS 3
$BATINCLUDE prepparm NCAP_FSUB 'R' 'P,CUR' ",'0','0','0'" T 'RTP(R,T,P)' EPS 3
$BATINCLUDE prepparm NCAP_FTAX 'R' 'P,CUR' ",'0','0','0'" T 'RTP(R,T,P)' EPS 3
$BATINCLUDE prepparm NCAP_ISUB 'R' 'P,CUR' ",'0','0','0'" T 'RTP(R,T,P)' EPS 3
$BATINCLUDE prepparm NCAP_ITAX 'R' 'P,CUR' ",'0','0','0'" T 'RTP(R,T,P)' EPS 3
$BATINCLUDE prepparm NCAP_VALU 'R' 'P,C,CUR' ",'0','0'" T 'RTP(R,T,P)' EPS 3
*-----------------------------------------------------------------------------
* Commodity related attributes (6)
*-----------------------------------------------------------------------------
$BATINCLUDE prepparm COM_CSTNET 'R' 'C,TS,CUR' ",'0','0'" MILESTONYR 1 EPS 3
$BATINCLUDE prepparm COM_CSTPRD 'R' 'C,TS,CUR' ",'0','0'" MILESTONYR 1 EPS 3
$BATINCLUDE prepparm COM_SUBNET 'R' 'C,TS,CUR' ",'0','0'" MILESTONYR 1 EPS 3
$BATINCLUDE prepparm COM_SUBPRD 'R' 'C,TS,CUR' ",'0','0'" MILESTONYR 1 EPS 3
$BATINCLUDE prepparm COM_TAXNET 'R' 'C,TS,CUR' ",'0','0'" MILESTONYR 1 EPS 3
$BATINCLUDE prepparm COM_TAXPRD 'R' 'C,TS,CUR' ",'0','0'" MILESTONYR 1 EPS 3
*-----------------------------------------------------------------------------
* Flow related attributes & inter-regional exchange flows (6)
*-----------------------------------------------------------------------------
$BATINCLUDE prepparm ACT_COST 'R' 'P,CUR' ",'0','0','0'" T 'RTP(R,T,P)' EPS 3
$BATINCLUDE prepparm FLO_COST 'R' 'P,C,TS,CUR' ",'0'" T 'RTP(R,T,P)' EPS 3
$BATINCLUDE prepparm FLO_DELIV 'R' 'P,C,TS,CUR' ",'0'" T 'RTP(R,T,P)' EPS 3
$BATINCLUDE prepparm FLO_SUB 'R' 'P,C,TS,CUR' ",'0'" T 'RTP(R,T,P)' EPS 3
$BATINCLUDE prepparm FLO_TAX 'R' 'P,C,TS,CUR' ",'0'" T 'RTP(R,T,P)' EPS 3
$BATINCLUDE fillparm IRE_PRICE 'R' 'P,C,TS,ALL_REG,IE,CUR' "" T 'RTP(R,T,P)' 'GE 0'
$IF DEFINED DAM_COST $BATINCLUDE prepparm DAM_COST 'R' 'C,CUR' ",'0','0','0'" MILESTONYR 1 EPS 3
*-----------------------------------------------------------------------------
* Components of merged UC attribs
*-----------------------------------------------------------------------------
$BATINCLUDE fillparm UC_COMCON 'UC_N,SIDE,ALL_R' 'C,TS' ",'0','0'" MILESTONYR 1 'GE 0'
$BATINCLUDE fillparm UC_COMNET 'UC_N,SIDE,ALL_R' 'C,TS' ",'0','0'" MILESTONYR 1 'GE 0'
$BATINCLUDE fillparm UC_COMPRD 'UC_N,SIDE,ALL_R' 'C,TS' ",'0','0'" MILESTONYR 1 'GE 0'
*-----------------------------------------------------------------------------
* Extensions
*-----------------------------------------------------------------------------
$IF DEFINED NCAP_AFC $BATINCLUDE fillparm NCAP_AFC 'R' 'P,CG,TSLVL' ",'0','0','0'" T 'RTP(R,T,P)' 'GE 0'
$IF DEFINED NCAP_CEH $BATINCLUDE fillparm NCAP_CEH 'R' 'P' ",'0','0','0','0','0'" MODLYEAR 'RVP(R,MODLYEAR,P)' 'GE 0'
*-----------------------------------------------------------------------------
* General attribs:
$   BATINCLUDE filparam MULTI 'J,' '' ",'','','','',''" LL MILESTONYR 'NO$' ''
$   BATINCLUDE filparam.gms G_DRATE 'R,' 'CUR'  ",'','','','',''" 'ALLYEAR' 'T' '' ''
*-----------------------------------------------------------------------------
$LABEL POSTINT
  MODLYEAR(LL) = MILESTONYR(LL);
  MODLYEAR(PASTYEAR)  = YES;
*-----------------------------------------------------------------------------
* UC Default values
*-----------------------------------------------------------------------------
* set EOHYEARS contains all years until MIYR_VL, while
    EOHYEARS(ALLYEAR)$((YEARVAL(ALLYEAR) >= MINYR) *
                       (YEARVAL(ALLYEAR) <= MIYR_VL)) = YES;
* create list of all years in each period
    PERIODYR(MODLYEAR,EOHYEARS)$((YEARVAL(EOHYEARS) >= B(MODLYEAR)) *
                                 (YEARVAL(EOHYEARS) <= E(MODLYEAR))) = YES;
*-----------------------------------------------------------------------------
* Check 'every T' specifications through using DFLBL:
* If used for T_SUM, fill in every T or within specified year range
  UC_DT(R,UC_N)$UC_T_SUM(R,UC_N,'%DFLBL%') = YES; UC_T_SUM(UC_DT,'%DFLBL%') = NO;
  LOOP(UC_DT, Z=SMAX(UC_T_SUM(UC_DT,LL),ORD(LL));
    IF(Z > 0, F=SMIN(UC_T_SUM(UC_DT,LL),ORD(LL)); ELSE F=Z);
    IF(Z NE F,UC_T_SUM(UC_DT,T(LL))$((ORD(LL) GT F)$(ORD(LL) LT Z)) = YES;
    ELSE UC_T_SUM(UC_DT,T) = YES));
  OPTION CLEAR=UC_DT;
UC_T_SUCC(REG,UC_N,T)$UC_T_SUCC(REG,UC_N,'%DFLBL%') = YES;
UC_T_EACH(REG,UC_N,T)$UC_T_EACH(REG,UC_N,'%DFLBL%') = YES;
LOOP(T(ALLYEAR),
  UC_T_EACH(REG,UC_N,LL+(ORD(ALLYEAR)-ORD(LL)))$(EOHYEARS(LL)$PERIODYR(T,LL)$UC_T_EACH(REG,UC_N,LL)) = YES;
  UC_T_SUCC(REG,UC_N,LL+(ORD(ALLYEAR)-ORD(LL)))$(EOHYEARS(LL)$PERIODYR(T,LL)$UC_T_SUCC(REG,UC_N,LL)) = YES;
  UC_T_SUM(REG,UC_N,LL+(ORD(ALLYEAR)-ORD(LL)))$(EOHYEARS(LL)$PERIODYR(T,LL)$UC_T_SUM(REG,UC_N,LL)) = YES;
);
* --- Set UC_R_EACH / UC_R_SUM defaults
  OPTION CLEAR=UNCD1; UNCD1(UC_N)$(NOT SUM(UC_R_EACH(ALL_R,UC_N),1)) = YES;
  UC_R_EACH(R,UC_N(UNCD1))$SUM(LIM$UC_RHSR(R,UC_N,LIM),1) = YES;
  UC_R_EACH(R,UC_N(UNCD1))$SUM(LIM$UC_RHSRS(R,UC_N,'ANNUAL',LIM),1) = YES;
  UC_R_EACH(R,UC_N(UNCD1))$SUM((T,LIM)$UC_RHSRT(R,UC_N,T,LIM),1) = YES;
  UC_R_EACH(R,UC_N(UNCD1))$SUM((T,S,LIM)$UC_RHSRTS(R,UC_N,T,S,LIM),1) = YES;
  OPTION CLEAR=UNCD1; UNCD1(UC_N)$(NOT SUM(UC_R_SUM(ALL_R,UC_N),1)) = YES;
  UC_R_SUM(R,UC_N(UNCD1))$SUM(LIM$UC_RHS(UC_N,LIM),1) = YES;
  UC_R_SUM(R,UC_N(UNCD1))$SUM((T,LIM)$UC_RHST(UC_N,T,LIM),1) = YES;
  UC_R_SUM(R,UC_N(UNCD1))$SUM((T,S,LIM)$UC_RHSTS(UC_N,T,S,LIM),1) = YES;
* [AL] Assume T_EACH and T_SUCC cannot be used at the same time; Let T_SUCC override T_EACH.
* First, copy T_SUCC to T_EACH to reduce testing in what follows:
  UC_T_EACH(REG,UC_N,T)$UC_T_SUCC(REG,UC_N,T) = YES;
* --- Set UC_T_EACH / UC_T_SUM defaults
  UC_DT(UC_R_EACH(R,UC_N)) = YES; UC_DT(UC_R_SUM(R,UC_N)) = YES;
  UC_DT(UC_DT)$SUM(UC_T_EACH(UC_DT,T),1) = NO; UC_DT(UC_DT)$SUM(UC_T_SUM(UC_DT,T),1) = NO;
  UC_T_SUM(UC_R_SUM(UC_DT(R,UC_N)),T)$SUM(LIM$UC_RHS(UC_N,LIM),1) = YES;
  UC_T_SUM(UC_R_EACH(UC_DT),T)$SUM(LIM$UC_RHSR(UC_DT,LIM),1) = YES;
  UC_T_EACH(UC_DT,T)$(NOT UC_T_SUM(UC_DT,T)) = YES;
  OPTION CLEAR=UC_DT;
UC_T_EACH(UC_T_SUCC(REG,UC_N,T)) = NO;
*-----------------------------------------------------------------------------
* Clean up some unwanted stuff
$IF DEFINED PRC_RESID LOOP(MIYR_1(LL), Z = YEARVAL(LL)-MIYR_BOH; 
$IF DEFINED PRC_RESID   NCAP_PASTI(R,LL-Z,P)$PRC_RESID(R,'0',P) = 0;
$IF DEFINED PRC_RESID   NCAP_TLIFE(R,LL-Z,P)$PRC_RESID(R,'0',P) = 0;);
$IF DEFINED PRC_RESID   PRC_RESID(R,'0',P) = 0;
*-----------------------------------------------------------------------------
* commodities in each region
    RC(R,C)$SUM(RPC(R,P,C),1) = YES;
    LOOP(COM_TYPE,RC(R,C)$COM_TMAP(R,COM_TYPE,C) = YES);
*-----------------------------------------------------------------------------
