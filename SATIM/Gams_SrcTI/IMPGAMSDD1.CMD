@echo off
rem
rem   IMPGAMSDD1.CMD %1 %2
rem
rem   %1 = full filename of TIMES GAMS DD file being imported into ANSWER
rem   %2 = full pathname to directory where ANSWER TIMES GAMS source code resides
rem   %3 = full pathname to directory where TIMES GAMS DD file being imported resides
rem
rem   argument %1 is passed quoted, so may contain blanks
rem   argument %3 is passed quoted, so may contain blanks
rem
rem   delete files in ANSWER Work folder (default Ans_WrkTI)
rem
if exist END_IMPDD1.STA del END_IMPDD1.STA
if exist END_IMPDD1.TXT del END_IMPDD1.TXT
rem
if exist RPRELIM.ANS del RPRELIM.ANS
if exist RPRELIM.LST del RPRELIM.LST
if exist DATAYEAR.TXT del DATAYEAR.TXT
if exist MILESTONYR.TXT del MILESTONYR.TXT
if exist MAXITEMLEN.TXT del MAXITEMLEN.TXT
rem
rem Carry out Import TIMES GAMS DD run 1 to create preliminary information.
ECHO $BATINCLUDE PRELIMPROC.ANS %1 > RUNIMPDD1.ANS
CALL GAMS RUNIMPDD1.ANS IDIR1=%2 IDIR2=%3 PS=99999
rem
if exist MAXITEMLEN.TXT echo Finished Import TIMES GAMS DD run 1. >> END_IMPDD1.STA
if not exist MAXITEMLEN.TXT echo Import TIMES GAMS DD run 1 failed. >> END_IMPDD1.STA
rem
rem ensure that timer only picks up existence of END_IMPDD1.TXT when all's done
move END_IMPDD1.STA END_IMPDD1.TXT > null
echo *
echo *
echo ****************************************
echo *                                      *
echo *   Import TIMES GAMS DD run 1 ended   *
echo *                                      *
echo ****************************************
echo *
echo *


