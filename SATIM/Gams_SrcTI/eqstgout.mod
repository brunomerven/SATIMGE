*=============================================================================*
* EQSTGOUT limits the activity of vintage processes or higher TS-level bounds         *
*   %1 - equation declaration type
*   %2 - bound type for %1
*   %3 - qualifier that bound exists
*=============================================================================*
*GaG Questions/Comments:
*  - ACT_BND ts restricted to the PRC_TS level or above
*-----------------------------------------------------------------------------
*V0.5b 980902 - avoid equations if LO=0/UP=INF
*$ONLISTING
  %EQ%%1_STGOUT(RTPC(%R_T%,P,C),S %SWT%)$((%3 AND (RPC_STG(R,P,C) * RPS_PRCTS(R,P,S) *
                             (PRC_VINT(R,P) + (NOT RPCS_VAR(R,P,C,S))))
                            )$STGOUT_BND(R,T,P,C,S,'%2')) ..

* sum over all possible at process TS-level, *GG* but only valid NSTouts
*       SUM(PRC_TS(R,P,TS)$TS_MAP(R,S,TS),
       SUM(RPCS_VAR(R,P,C,TS)$(RS_TREE(R,S,TS) * (NOT PRC_NSTTS(R,P,TS))),
* sum all the existing activities
           SUM(RTP_VINTYR(R,V,T,P), 
             %VAR%_SOUT(R,V,T,P,C,TS %SOW%)*RS_FR(R,S,TS)*(1+RTCS_FR(R,T,C,S,TS)))
            

       )

  =%1=

       STGOUT_BND(R,T,P,C,S,'%2')
  ;
*$OFFLISTING
