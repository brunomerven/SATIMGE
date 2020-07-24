* this module is run at the end to compile energy sector emissions

REPORT(PRC,COM,TC,RUN,Emiss) = REPORT(PRC,COM,TC,RUN,'FlowIn')*EmisFactor(Com,Emiss);

* convert energy flows to TJ to match inventory and DOE energy balances
*REPORT(PRC,COM,TC,RUN,'Flowin') = REPORT(PRC,COM,TC,RUN,'FlowIn')*1000;

* Refinery sector Combustion emissions 1A
REPORT(PRC,'ACTGRP',TC,RUN,'CO2') = REPORT(PRC,'UPSCO2S',TC,RUN,'FlowOut');
REPORT(PRC,'ACTGRP',TC,RUN,'CH4') = REPORT(PRC,'UPSCH4S',TC,RUN,'FlowOut');
*Sasol Boilers for CTL plant
REPORT('UHETCLE-E','UPSCLE',TC,RUN,'CO2') = REPORT('UHETCLE-E','UPSCO2S',TC,RUN,'FlowOut');
REPORT('UHETCLE-E','UPSCLE',TC,RUN,'CH4') = REPORT('UHETCLE-E','UPSCH4S',TC,RUN,'FlowOut');
REPORT('UHETCLE-E','ACTGRP',TC,RUN,'CO2') = 0;
REPORT('UHETCLE-E','ACTGRP',TC,RUN,'CH4') = 0;

*Sasol Boilers used for Electricity Generation
REPORT('ETCLEPFSS-E','UPSCLE',TC,RUN,'CO2') = REPORT('ETCLEPFSS-E','UPSCLE',TC,RUN,'FlowIn')*96.25;
REPORT('ETCLEPFSS-E','UPSCLE',TC,RUN,'CH4') = REPORT('ETCLEPFSS-E','UPSCLE',TC,RUN,'FlowIn')*0.001;
REPORT('ETCLEPFSS-E','UPSCLE',TC,RUN,'N2O') = REPORT('ETCLEPFSS-E','UPSCLE',TC,RUN,'FlowIn')*0.0014;



* Mining 1B1 Fugitive Emissions
REPORT(PRC,'ACTGRP',TC,RUN,'CO2')$MPRCFS(PRC,'coal') = REPORT(PRC,'CO2SF',TC,RUN,'FlowOut');
REPORT(PRC,'ACTGRP',TC,RUN,'CH4')$MPRCFS(PRC,'coal') = REPORT(PRC,'CH4SF',TC,RUN,'FlowOut');

* CTL 1B3 Fugitive emissions
REPORT('UCTLCLEIN-E','UPSCLE',TC,RUN,'CO2') = REPORT('UCTLCLEIN-E','CO2SF',TC,RUN,'FlowOut');
REPORT('UCTLCLEIN-E','UPSCLE',TC,RUN,'CH4') = REPORT('UCTLCLEIN-E','CH4SF',TC,RUN,'FlowOut');

* GTL 1B3 emissions
REPORT('XUPSGIC','ACTGRP',TC,RUN,'CO2') = REPORT('UGTLGICCO-E','UPSCO2S',TC,RUN,'FlowOut');
REPORT('XUPSGIC','ACTGRP',TC,RUN,'CH4') = REPORT('UGTLGICCO-E','UPSCH4S',TC,RUN,'FlowOut');


* Gas 1B2 Fugitive Emissions = the rest of fugitive emissions happening all over the place (gas network)
REPORT('XUPSGAS','ACTGRP',TC,RUN,'CH4') = sum(PRC,REPORT(PRC,'CH4SF',TC,RUN,'FlowOut'))
                                                     -REPORT('XUPSCLE','ACTGRP',TC,RUN,'CH4')
                                                     -REPORT('UTRNGIMGAS','ACTGRP',TC,RUN,'CH4');

