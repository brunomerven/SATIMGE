*=============================================================================*
* CAL_NCOM the code associated with invest/decommission commodities in the EQ_COMxxx    *
*   %1 - I/O indicator
*   %2 - cost expression for EQOBJVAR
*=============================================================================*
*GaG Questions/Comments:
*-----------------------------------------------------------------------------
*$ONLISTING
*V0.5a 980828 - cant use CPTYR as capacity not available yet
*V05c 980923 - use the capacity flow control set
         SUM(RPC_CAPFLO(R,V,P,C)$COEF_%1COM(R,V,T,P,C), COEF_%1COM(R,V,T,P,C) *
             %2
             G_YRFR(R,S) * (%VARV%_NCAP%3(R,V,P %SWS%)$MILESTONYR(V)
$ IF '%1' == 'O'            + NCAP_PASTI(R,V,P)$PASTYEAR(V)
             )
         )
*$OFFLISTING
