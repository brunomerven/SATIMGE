@echo off
rem
rem   ANS_RUN.CMD %1 %2 %3 %4 %5 %6
rem
rem   %1 = full pathname to directory where ANSWER GAMS source code resides
rem   %2 = START/RESTART/_RESTART
rem   %3 = CaseName
rem   %4 = full pathname to directory where GAMS save files reside
rem   %5 = GAMS save file - full name (less .g0*)
rem   %6 = GAMS restart file - full name (less .g0*) when %2 = RESTART
rem   %7 = STOCH for stochastic run, '' for non-stochastic run
rem
rem   Note that GAMS save file name is %5, GAMS restart file name is %6
rem
rem   Do this within 5 seconds or END_GAMS gets detected from previous run!
if exist END_GAMS.STA del END_GAMS.STA
if exist END_GAMS del END_GAMS
rem
if '%2' == 'START' goto start
if '%2' == 'RESTART' goto restart
if '%2' == '_RESTART' goto restart
echo *
echo *********************************************************************
echo *                                                                   *
echo *   ANS_RUN.CMD must be called with %2 = START/RESTART/_RESTART !!  *
echo *                                                                   *
echo *********************************************************************
echo *
goto alldone
rem
:start
rem
rem   GAMS run for CaseName %3 solving from scratch,
rem
rem call %1\ANULLIT.CMD %1 %4 - not needed
rem call %1\ANS_GAMS.CMD %1 %3 %7 %4\_Restart %5 - replace by line below
call %1\ANS_GAMS.CMD %1 %3 %7
goto done
:restart
rem
rem   GAMS run for CaseName %3 solving from GAMS restart file %6,
rem                            GAMS save file name %5
rem
if '%2' == '_RESTART' goto specrestart
call %1\ARESTART.CMD %1 %6 %4\_Restart
call %1\ANS_GAMS.CMD %1 %3 %7 %4\_Restart %5
goto done
:specrestart
rem   where restart file is _restart, must not do KILL.GMS which occurs in ARESTART.CMD 
call %1\ANS_GAMS.CMD %1 %3 %7 %6 %5
goto done
:done
rem ensure that timer only picks up existence of END_GAMS when done
move END_GAMS.STA END_GAMS > nul
echo *
echo *********************************************************************
echo *                                                                   *
echo *                    ANSWER-TIMES GAMS run ended                    *
echo *                                                                   *
echo *********************************************************************
echo *
:alldone

