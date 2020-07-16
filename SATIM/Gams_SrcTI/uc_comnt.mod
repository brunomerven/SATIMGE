*=============================================================================*
* UC_COMCN the code associated with the COMNET variable in the EQ_USERCON
*     - %1 region summation index
*     - %2 period summation index
*     - %3 time-slice summation index
*     - %4 'T' or 'T+1' index
*     - %5 'LHS' or 'RHS'
*     - %6 Type of constraint (0=EACH, 1=SUCC or 2=SEVERAL)
*=============================================================================*
*UR Questions/Comments:
*  -
*-----------------------------------------------------------------------------

*"SUM(UC_R_SUM(R,UC_N)," or bracket "("
 %1
*     "SUM(UC_T_SUM(UC_N,T)," or bracket "("
      %2
*          "SUM(UC_TS_SUM(UC_N,S)," or bracket "("
           %3
              SUM(UC_GMAP_C(R,UC_N,'NET',C,UC_GRPTYPE),
$IF %6==2 (1+(FPD(T)+(COEF_PVT(R,T)-FPD(T))$UC_ATTR(R,UC_N,'LHS',UC_GRPTYPE,'PERDISC')-1)$UC_DT(R,UC_N)) *
                  SUM(RHS_COMBAL(R,%4,C,TS)$RS_TREE(R,S,TS),
                      UC_COM(UC_N,'NET',%5,R,%7,C,TS,UC_GRPTYPE) * %VAR%_COMNET(R,%4,C,TS %SOW%)*
                      (1+(1/COM_IE(R,%4,C,TS)-1)$(UC_ATTR(R,UC_N,%5,UC_GRPTYPE,'EFF') XOR DIAG(UC_GRPTYPE,'COMPRD'))) *

* [AL] PROD operator is useful here
                      PROD(ANNUAL,1)*PROD(RS_BELOW(R,TS,S),RS_FR(R,S,TS)*(1+RTCS_FR(R,%4,C,S,TS))) *
$IF %6==1             PROD(UC_ATTR(R,UC_N,%5,UC_GRPTYPE,'GROWTH'),
$IF %6==1                  POWER(ABS(UC_COM(UC_N,'NET',%5,R,%7,C,TS,UC_GRPTYPE)),%8*UC_SIGN(%5)-1)) *
$IF %6==S             (1/G_YRFR(R,S)) *
                      PROD(UC_ATTR(R,UC_N,%5,UC_GRPTYPE,'PERIOD'),FPD(%4)) *

                      PROD(REG(R)$SUM(UC_ATTR(R,UC_N,%5,UC_GRPTYPE,UC_COST),1),
                        SUM((UC_ATTR(R,UC_N,%5,UC_GRPTYPE,UC_COST),RDCUR(R,CUR)),
                            OBJ_COMNT(R,%4,C,TS,UC_COST,CUR)))
                  )
              )
*          closing bracket of %3 :
           )

*       closing bracket of %2 :
        )

*   closing bracket of %1 :
    )

