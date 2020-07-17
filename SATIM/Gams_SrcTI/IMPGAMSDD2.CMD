@echo off
rem
rem   IMPGAMSDD2.CMD %1 %2 %3 %4 %5 %6
rem
rem   %1 = full filename of GAMS DD file being imported into ANSWER
rem   %2 = filestem assigned to .IMP file created (e.g. Utopia)
rem   %3 = YES/NO (according to whether import into BASE/non-BASE scenario)
rem   %4 = YES/NO (according to whether we want TS Data put out Sparsely/Densely)
rem   %5 = no. of significant digits for numeric data
rem   %6 = full pathname to directory where ANSWER GAMS source code resides
rem   %7 = full pathname to directory where TIMES GAMS DD file being imported resides
rem
rem   arguments %1, %2, %7 are passed quoted, so may contain blanks
rem
rem   delete files in ANSWER Work folder (default Ans_WrkTI)
rem
if exist END_IMPDD2.STA del END_IMPDD2.STA
if exist END_IMPDD2.TXT del END_IMPDD2.TXT
rem
if exist RUNIMPDD2.ANS del RUNIMPDD2.ANS
if exist RUNIMPDD2.LST del RUNIMPDD2.LST
if exist %2.IMP del %2.IMP
if exist %2.ERR del %2.ERR
rem
rem Carry out GAMS run to create %2.IMP file.
ECHO $BATINCLUDE MAINPROC.ANS %1 %2 %3 %4 %5 > RUNIMPDD2.ANS
CALL GAMS RUNIMPDD2.ANS IDIR1=%6 IDIR2=%7 PS=99999
rem
if exist %2.IMP echo Finished Import TIMES GAMS DD run 2. >> END_IMPDD2.STA
if not exist %2.IMP echo Import TIMES GAMS DD run 2 failed. >> END_IMPDD2.STA
rem
rem ensure that timer only picks up existence of END_IMPDD2.TXT when all's done
move END_IMPDD2.STA END_IMPDD2.TXT > null
echo *
echo *
echo ****************************************
echo *                                      *
echo *   Import TIMES GAMS DD run 2 ended   *
echo *                                      *
echo ****************************************
echo *
echo *
