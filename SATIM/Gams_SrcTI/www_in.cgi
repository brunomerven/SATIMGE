*=============================================================================*
*                                                                             *
* WWW_IN.CGI input directives for GAMS-CGI WWW                                *
*                                                                             *
*=============================================================================*

* Technical Lifetime
$libinclude X INPUT TL_GAS_PL 40. "Tech. Lifetime of Gas Plant"      0 10 20 30 40
$libinclude X INPUT TL_GASOIL 40. "Tech. Lifetime of Gas/Oil Plant"  0 10 20 30 40
  NCAP_TLIFE('REG',MODLYEAR,'GAS_PL') = %TL_GAS_PL%;
  NCAP_TLIFE('REG',MODLYEAR,'GASOIL_PL') = %TL_GASOIL%;

* Cost of power plant
$libinclude cgi INPUT COSTE01_1 1300. "Inv. Cost of Gas Plant in 1994"  1200 1300 1400 1500
$libinclude cgi INPUT COSTE01_2 1200. "Inv. Cost of Gas Plant in 2004"  1200 1300 1400 1500

  NCAP_COST('REG','1994','GAS_PL','USD') = %COSTE01_1%;
  NCAP_COST('REG','2004','GAS_PL','USD') = %COSTE01_2%;
