*=============================================================================*
* DUMPPUT.MOD outputs the actual Sets/Parameters                              *
*  Dumps output SET, SCALARS, PARAMETER, TABLE
*
*  1   - type indicator = S-Set/P-Parameter/X-Variable (SCALARS)/index-Table with column header in 2nd position
*  2-n - for rest of line = component names
*
*      - Note that (declaration) is not output
*      - $BATINCLUDE dumpput.mod ITEM1 ITEM2 ... must fit on one line
*
*=============================================================================*
*GaG Questions/Comments:
*    - adjust so that Set controlling column can be passed and 'T' used
*    - add (declaration) to output
*    - respond to %NO_EMTY% by surpressing if no values
*    - adjust so stream output formats OK too (e.g., file.pc = 5)
*10/11
*    - small bug on $label param3 with spacing around 2nd index???
*    - add OR '%NO_EMTY%' = 'NO' to the CARD test so that empty stuff is printed
*98/08
*    - ALL_REG is not printed
*-----------------------------------------------------------------------------

file.tf = 0;
$offlisting
$set preditem ''

* hold the first parameter for later checking
$set whtype %1
*GG* later take 2nd as name of set controlling the TABLE column header to improve xeq
$shift

$label more

* only one call executes, so  done when no more parameters
$if %1a == a               $goto done

$if declared %1            $goto declared
* out error message if passed entity not declared
put / '*** UNKNOWN':20,'NAME':6,'%1':10 /;
$set preditem 'unknown'
$shift goto more

$label declared
$if settype %1             $goto doset
$if partype %1             $goto dopar
* declared but neither SET nor SCALAR/PARAMETER (so what else possible?)
put / '*** UNKNOWN':20,'TYPE':6,'%1':10,"'",%1.ts:40,"'"  /;
$set preditem 'unknown'
$shift goto more

$label doset
$set preditem 'set'
$if defined %1             $goto defset
* out error message if not initialized
put / '*** NOT INITIALIZED':20,'SET':6,'%1':10,"'",%1.ts:40,"'" /;
$shift goto more

$label defset
IF(CARD(%1) > 0,
  put / ' ':9,'SET':6,'%1':10,"'",%1.ts:40,"' /";
  loop(%1,
     file.tf = 3;
     put / ' ':9,' ':6,%1.te(%1);
     file.tf = 0;
     put @60 "'",%1.te(%1):40,"'" );
  put ' /' /;
);
$shift goto more

$label dopar
$if defined %1             $goto defpar
put / '*** NOT INITIALIZED':20,'TABLE':6,'%1':10,"'",%1.ts:40,"'" /;
$shift goto more

$label defpar
file.nr=3;
$if dimension 0  %1        $goto scalar
$if not declared u1 alias(u1,u2,u3,u4,u5,u6,u7,u8,u9,*);
$if dimension 1  %1 $set r 'u1'                      set c ''   set row row1
$if dimension 2  %1 $set r 'u1'                      set c ''   set row row2
$if dimension 3  %1 $set r 'u1'                      set c 'u2' set row row3
$if dimension 4  %1 $set r 'u1,u2'                   set c 'u3' set row row4
$if dimension 5  %1 $set r 'u1,u2,u3'                set c 'u4' set row row5
$if dimension 6  %1 $set r 'u1,u2,u3,u4'             set c 'u5' set row row6
$if dimension 7  %1 $set r 'u1,u2,u3,u4,u5'          set c 'u6' set row row7
$if dimension 8  %1 $set r 'u1,u2,u3,u4,u5,u6'       set c 'u7' set row row8
$if dimension 9  %1 $set r 'u1,u2,u3,u4,u5,u6,u7'    set c 'u8' set row row9
$set rc  %c%,%r%
file.tf=3;

$if dimension 1  %1        $goto param1
$if dimension 2  %1        $goto param2

set %row%(%r%),col(%c%);
$onuni

* handle the time-dependant tables by putting out everything
$if NOT '%whtype%' == 'P' col(%whtype%) = yes;

loop((REG,%c%,%r%)$%1(REG,%c%,%r%),
   col(%c%) = yes;
   %row%(%r%) = yes);

* handle parameters with > 1 index
$  if '%whtype%' == 'P' $goto param3

scalar colcnt;
IF(CARD(%row%) > 0,
$  set preditem 'table'
   put / ' ':9,'TABLE':6,'%1':10," '",%1.ts:40,"'" / @44;
   colcnt = 0;
   loop(col$(colcnt < 19),
     put col.tl:11;
     colcnt = colcnt + 1
   );
   loop((REG,%row%)$(DUMP0 + SUM(col,%1(REG,col,%row%))),
      put  / @4 REG.TL:0,'.',%row%.te(%row%) @44;
      colcnt = 0;
      loop(col,
         if(colcnt = 19,
            colcnt = 0
            put / @10 col.tl:4 @40 '+++' @44);
         colcnt = colcnt + 1;
         if(%1(REG,col,%row%),
            put %1(REG,col,%row%):<10 ' '
         else
            put ' ':11                )));
   put /;
);
$goto donetab

* handle parameters with >2 index
$label param3

IF(CARD(%row%) > 0,
   put / ' ':9,'PARAMETER'@20,'%1':10," '",%1.ts:40,"'";
   loop((REG,col,%row%)$(DUMP0 + (%1(REG,col,%row%) NE 0)),
      put / @15, REG.TL:0,'.'col.tl'.'%row%.te(%row%) @66 %1(REG,col,%row%):<10; );
   put /;
);

$label donetab
$offuni
option clear=%row%,clear=col;
$shift goto more

$label scalar
* simple scalar
$if not '%preditem%' == 'scalar' put / ' ':9, 'SCALARS' /
$set preditem 'scalar'
put ' ':15,'%1':10,"/ " %1:10 " /" /;
$shift goto more

$label param2
$set preditem 'parameter'
$hidden works for any dimension

$set rc %r%
set %row%(%rc%);

$ onuni
LOOP(REG,
  %row%(%rc%)$%1(REG,%rc%) = yes;
);
IF(CARD(%row%) > 0,
  put / ' ':9,'PARAMETER' , @20,'%1':10,"'",%1.ts:40,"' /";
  loop((REG,%row%)$(DUMP0 + (%1(REG,%row%) NE 0)),
     put / @15, REG.TL:0'.'%row%.te(%row%) @44 %1(REG,%row%):<10; );
  put @69 '/' /;
  option clear=%row%;
  put /;
);
$ offuni
$shift goto more

$label param1
$set preditem 'parameter'
$hidden works for any dimension

$set rc %r%
set %row%(%rc%);

$ onuni
%row%(%rc%)$%1(%rc%) = yes;
IF(CARD(%row%) > 0,
  put / ' ':9,'PARAMETER' , @20,'%1':10,"'",%1.ts:40,"' /";
  loop(%row%$(DUMP0 + (%1(%row%) NE 0)),
     put / @15, %row%.te(%row%) @44 %1(%row%):<10; );
  put @69 '/' /;
  option clear=%row%;
  put /;
);
$ offuni
$shift goto more

$label done
