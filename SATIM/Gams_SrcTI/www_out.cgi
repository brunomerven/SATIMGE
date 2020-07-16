*=============================================================================*
*                                                                             *
* WWW_OUT.CGI output and plot directives for GAMS-CGI WWW                     *
*                                                                             *
*=============================================================================*

SET TL(ALLYEAR) /1990,1994,2004/;

$setglobal xtitle "Discounted Cost Value"
$libinclude x OUTPUT OBJz.L


parameter ncap_gaspl     Capacity of GAS_PL;
parameter ncap_gasol     Capacity of GASOIL_PL;

ncap_gaspl(milestonyr) = var_ncap.l("reg",milestonyr,"GAS_PL");
ncap_gasol(milestonyr) = var_ncap.l("reg",milestonyr,"GASOIL_PL");


$setglobal xtitle "Added Capacity of Gas Plant"
$libinclude x OUTPUT NCAP_GASPL TL

$setglobal xtitle "Added Capacity of Gas/Oil Plant"
$libinclude x OUTPUT NCAP_GASOL TL


$setglobal xtitle "Added Capacity of Gas Plant"
$libinclude x PLOT NCAP_GASPL MILESTONYR TL

$setglobal x "Added Capacity of Gas/Oil Plant"
$libinclude x PLOT NCAP_GASOL MILESTONYR TL

