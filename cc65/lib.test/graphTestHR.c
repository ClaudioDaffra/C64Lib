
#include <stdio.h>

#include "../lib/C64.h"
#include "../lib/graph.h"

// cl65 -t c64  graphTestHR.c ..\lib\graphA.s ..\lib\graph.c  -o x.prg

int main ( void )
{
	graphInit(graphMode320x200);
	
	graphBitMapOn();
	
	graphBitMapClear();
	
	cBackGround = cYellow;	; // graphColor0
	cForeGround = cRed;		; // graphColor1
	
	graphSetHiresColor();

    graphColor(on);
	graphPixel( 1 , 1 ) ;
	graphPixel( 3 , 3 ) ;
	graphPixel( 5 , 5 ) ;
	graphPixel( 7 , 7 ) ;
    graphColor(off);	
	graphPixel( 3 , 3 ) ;
	
	return 0 ;
}

