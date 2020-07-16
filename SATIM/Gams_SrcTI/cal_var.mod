$offlisting
*==============================================================================
* CAL_VAR generic variable expression routine for other than VAR_FLO or VAR_IRE
*   %1 - variable type 
*   %2 - all standard indexes w/o braces
*   %3 - '' or primary time index for stochastic path
*   %4..%9 - optional multipliers (with leading operators)
*==============================================================================
*$onlisting
$IF NOT %STAGES% == YES $SETLOCAL VAR 'VAR' SETLOCAL SOW ''
$IF '%SOW%%3' == '%3%SOW%'      %VAR%_%1(%2%SOW%) %4 %5 %6 %7 %8 %9
$IF NOT '%SOW%%3' == '%3%SOW%'  SUM(SW_TSW(SOW,%3,W),%VAR%_%1(%2,W)) %4 %5 %6 %7 %8 %9
*$offlisting
