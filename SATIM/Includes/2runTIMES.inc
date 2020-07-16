*--------------------------------------------------------------
*SETUP AND CALL TIMES MODEL IN GAMS -------------------------------------
*--------------------------------------------------------------

  PUT  ShowRunNumber;
  RUNTIMES2.pc = 2;
  RUNTIMES2.nd = 5;
  RUNTIMES2.ap = 0;

  put "echo ", RUN.TL;

  PUTCLOSE "";

* Write executable for running SATIM with specified path and run-name
  PUT  RUNTIMES2;
  RUNTIMES2.pc = 2;
  RUNTIMES2.nd = 5;
  RUNTIMES2.ap = 0;

* will remove below when imported into ANSWER
  put 'copy "%workingfolder%SATiM\%TIMESfolder%\DMDTECHAFRES+REGION1.bu" "%workingfolder%SATM\%TIMESfolder%\DMDTECHAFRES+REGION1.dds"'/;
  put 'copy "%workingfolder%SATiM\%TIMESfolder%\DMDTECHAFCOM+REGION1.bu" "%workingfolder%SATM\%TIMESfolder%\DMDTECHAFCOM+REGION1.dds"'/;

  loop(MRUNCASE(RUN,TIMESCASE), put ".\satim\%TIMESfolder%\RUNTIMES.CMD ", "%workingfolder%":38,TIMESCASE.TL:20,"%TIMESfolder%");

  PUTCLOSE "";

* Run TIMES model
 execute ".\satm\%TIMESfolder%\ShowRunNumber.CMD"
 execute ".\satm\%TIMESfolder%\RUNTIMES2.CMD"
 execute "echo --- Return to CGE model"

