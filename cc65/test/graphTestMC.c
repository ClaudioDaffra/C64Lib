
#include <stdio.h>

#include "../lib/C64.h"
#include "../lib/graph.h"

// cl65 -t c64 graphTestMC.c ..\lib\graphA.s ..\lib\graph.c -o x.prg



int main ( void )
{
	graphInit(graphMode160x200);

	graphBitMapOn();

	graphBitMapClear();
	
	graphColor0	= cRed;
	graphColor1 = cYellow;
	graphColor2 = cBlue ;
	graphColor3 = cGreen ;
	
	graphSetMultiColor();
	
	;
	graphColor ( cColor3 );
	graphPixel ( 0,0 ); 

	graphColor ( cColor1 );	
	graphPixel ( 1,1 ); 
	
	graphColor ( cColor1 );	
	graphPixel ( 3,3 );

	graphColor ( cColor2 );	
	graphPixel ( 5,5 );
	
	graphColor ( cColor0 );	
	graphPixel ( 7,7 );

	graphColor ( cColor3 );	
	graphPixel ( 9,9 );
	
	//graphBitMapOff();
	
	//graphEnd();
	
	return 0 ;
}

