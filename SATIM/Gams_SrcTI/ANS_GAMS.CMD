@echo off
rem
rem   ANS_GAMS.CMD %1 %2 %3
rem
rem   %1 = full pathname to directory where ANSWER GAMS source code resides
rem   %2 = CaseName
rem   %3 = STOCH for stochastic run, '' for non-stochastic run
rem
echo *
echo *********************************************************************
echo *                                                                   *
echo *                     ANSWER-TIMES Version 6.7                      *
echo *                     ========================                      *
echo *                                                                   *
echo *********************************************************************
echo *
if exist TEMP.ANT del TEMP.ANT
if exist TEMP.OUT del TEMP.OUT
if exist %2.LST del %2.LST
if exist %2.ANT del %2.ANT
if exist %2.OUT del %2.OUT
if exist %2.ERR del %2.ERR

if not exist %1\_TIMES.G00 Call GAMS %2.GEN IDIR=%1 GDX=gamssave\%2 PS=99999
if exist %1\_TIMES.G00 Call GAMS %2.GEN IDIR=%1 GDX=gamssave\%2 PS=99999 r=%1\_TIMES.G00

if not '%3' == 'STOCH' GDX2VEDA gamssave\%2 %1\times2veda.vdd %2
if     '%3' == 'STOCH' GDX2VEDA gamssave\%2 %1\times2veda_stc.vdd %2
if exist TEMP.ANT rename TEMP.ANT %2.ANT
if exist TEMP.OUT rename TEMP.OUT %2.OUT
echo GAMS run ended >> END_GAMS.STA
