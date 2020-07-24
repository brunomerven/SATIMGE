* this module is run at the end to compile energy sector emissions
* July 2020
* By Bruno Merven which draws from spreadsheet Models put together by Luanne Stevens
*

* Write Drivers to Spreadsheet


* Read Results from Spreadsheet
execute 'gdxxrw.exe i=AFOLU\Land_model_Linked.xlsx o=Land.gdx index=IndexE2G!a6';
execute_load "Land.gdx" LandEmissions;


REPORT(PRC,'ACTGRP',TC,RUN,Emiss)$LandEmissions(PRC,Emiss,TC) = LandEmissions(PRC,Emiss,TC);


* Write Drivers to Spreadsheet

* Read Results from Spreadsheet
execute 'gdxxrw.exe i=AFOLU\Agriculture_model_Linked.xlsx o=Agri.gdx index=IndexE2G!a6';
execute_load "Agri.gdx" AgriEmissions;


REPORT(PRC,'ACTGRP',TC,RUN,Emiss)$AgriEmissions(PRC,Emiss,TC) = AgriEmissions(PRC,Emiss,TC);
