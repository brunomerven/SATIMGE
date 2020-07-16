*=============================================================================*
* PPM_EXT.xtd oversees extended preprocessor activities                       *
*   %1 - mod or v# for the source code to be used                             *
*=============================================================================*
* Questions/Comments:
*
*-----------------------------------------------------------------------------
$IF NOT DEFINED PRC_DSCNCAP $EXIT
*-----------------------------------------------------------------------------
* Discrete capacity extensions
*-----------------------------------------------------------------------------
  NCAP_DISC(RTP(R,T,P),'0')$PRC_DSCNCAP(R,P) = EPS$(NOT NCAP_SEMI(R,T,P));
