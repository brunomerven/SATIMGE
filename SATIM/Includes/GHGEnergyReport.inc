* this module is run at the end to compile energy sector emissions

REPORT(PRC,COM,TC,RUN,Emiss) = REPORT(PRC,COM,TC,RUN,'FlowIn')*EmisFactor(Com,Emiss);

* convert energy flows to TJ to match inventory and DOE energy balances
*REPORT(PRC,COM,TC,RUN,'Flowin') = REPORT(PRC,COM,TC,RUN,'FlowIn')*1000;

* Refinery sector Combustion emissions 1A
REPORT(PRC,'ACTGRP',TC,RUN,'CO2') = REPORT(PRC,'UPSCO2S',TC,RUN,'FlowOut');
REPORT(PRC,'ACTGRP',TC,RUN,'CH4') = REPORT(PRC,'UPSCH4S',TC,RUN,'FlowOut');

* Mining 1B1 Fugitive Emissions
*SATIM_OUTPUT2('XUPSCLE','ACTGRP',TC,'CO2',GDXFile) = sum(PRC$MPRCFS(PRC,'coal'),SATIM_OUTPUT2(PRC,'CO2SF',TC,'FlowOut',GDXFile));
*SATIM_OUTPUT2('XUPSCLE','ACTGRP',TC,'CH4',GDXFile) = sum(PRC$MPRCFS(PRC,'coal'),SATIM_OUTPUT2(PRC,'CH4SF',TC,'FlowOut',GDXFile));
REPORT(PRC,'ACTGRP',TC,RUN,'CO2')$MPRCFS(PRC,'coal') = REPORT(PRC,'CO2SF',TC,RUN,'FlowOut');
REPORT(PRC,'ACTGRP',TC,RUN,'CH4')$MPRCFS(PRC,'coal') = REPORT(PRC,'CH4SF',TC,RUN,'FlowOut');

* CTL 1B3 Fugitive emissions
REPORT('UTRNGIMGAS','ACTGRP',TC,RUN,'CO2') = REPORT('UCTLCLEIN-E','CO2SF',TC,RUN,'FlowOut');
REPORT('UTRNGIMGAS','ACTGRP',TC,RUN,'CH4') = REPORT('UCTLCLEIN-E','CH4SF',TC,RUN,'FlowOut');

* GTL 1B3 emissions

* Gas 1B2 Fugitive Emissions = the rest of fugitive emissions happening all over the place (gas network)
REPORT('XUPSGAS','ACTGRP',TC,RUN,'CH4') = sum(PRC,REPORT(PRC,'CH4SF',TC,RUN,'FlowOut'))
                                                     -REPORT('XUPSCLE','ACTGRP',TC,RUN,'CH4')
                                                     -REPORT('UTRNGIMGAS','ACTGRP',TC,RUN,'CH4');

* Process emissions
ProcessEmissions(FS,TC,RUN,'CO2') = sum(PRC$MPRCFS(PRC,FS),REPORT(PRC,'CO2SP',TC,RUN,'FlowOut'));
*ProcessEmissions(FS,TC,RUN,'CH4') = sum(PRC$MPRCFS(PRC,FS),REPORT(PRC,'CH4SP',TC,RUN,'FlowOut'));
ProcessEmissions(FS,TC,RUN,'PFC') = sum(PRC$MPRCFS(PRC,FS),REPORT(PRC,'INDCF46P',TC,RUN,'FlowOut'));
ProcessEmissions('COM',TC,RUN,'HFC') = 4035;
loop(FS,
*SATIM_OUTPUT2(PRC,COM,TC,Emiss,GDXFile)$MFSP(FS,PRC) = 0;
REPORT(PRC,'ACTGRP',TC,RUN,Emiss)$MFSP(FS,PRC) = ProcessEmissions(FS,TC,RUN,Emiss);
);

