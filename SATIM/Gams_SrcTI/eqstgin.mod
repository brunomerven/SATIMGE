*=============================================================================*
* EQSTGIN limits the activity of vintage processes or higher TS-level bounds         *
*   %1 - equation declaration type
*   %2 - bound type for %1
*   %3 - qualifier that bound exists
*=============================================================================*
*GaG Questions/Comments:
*  - Bound TS restricted to the PRC_TS level or above
*-----------------------------------------------------------------------------
*V0.5b 980902 - avoid equations if LO=0/UP=INF
*$ONLISTING
  %EQ%%1_STGIN(RTPC(%R_T%,P,C),S %SWT%)$((%3 AND (RPC_STG(R,P,C) * RPS_PRCTS(R,P,S) *
                             (PRC_VINT(R,P) + (NOT PRC_TS(R,P,S))))
                            )$STGIN_BND(R,T,P,C,S,'%2')) ..

* sum over all possible flow variables at process TS-level
       SUM(RPCS_VAR(R,P,C,TS)$(TS_MAP(R,S,TS) * ((NOT PRC_MAP(R,'NST',P)) + PRC_NSTTS(R,P,TS))),
           SUM(RTP_VINTYR(R,V,T,P), %VAR%_SIN(R,V,T,P,C,TS %SOW%)))

  =%1=

       STGIN_BND(R,T,P,C,S,'%2')
  ;
*$OFFLISTING
