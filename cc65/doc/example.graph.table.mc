
#include <stdio.h>

#include "C64.h"
#include "graphic.h"

// cl65 -t c64 graphTestMC.c graphic.s -o x.prg

int main ( void )
{
	graphInit(graphMode160x200);

	graphBitMapOn();

	graphBitMapClear();
	
	graphColor0	= cRed;
	graphColor1 = cYellow;
	graphColor2 = cCyan ;
	graphColor3 = cWhite ;
	
	graphSetMultiColor();
	
	; 
	
	
	pointX = 1*2 ;
	pointY = 1 ;	
	graphDrawMode = cColor0 ;
	plotPointMC();

	pointX = 3*2 ;
	pointY = 3 ;	
	graphDrawMode = cColor1 ;
	plotPointMC();
	
	pointX = 5*2 ;
	pointY = 5 ;	
	graphDrawMode = cColor2 ;
	plotPointMC();
	
	pointX = 7*2 ;
	pointY = 7 ;	
	graphDrawMode = cColor3 ;
	plotPointMC();

	pointX = 9*2 ;
	pointY = 9 ;	
	graphDrawMode = cColor2 ;
	plotPointMC();
	
	
/*	
	// ........................ x=1,y=1
	pointX = 1*2 ;
	pointY = 1 ;	
	graphDrawMode = on ;
	plotPoint();
	pointX = 1*2+1 ;
	pointY = 1 ;	
	graphDrawMode = on ;
	plotPoint();

	// ........................ x=3,y=3
	pointX = 3*2 ;
	pointY = 3 ;	
	graphDrawMode = off ;
	plotPoint();
	pointX = 3*2+1 ;
	pointY = 3 ;	
	graphDrawMode = on ;
	plotPoint();

	// ........................ x=5,y=5
	pointX = 5*2 ;
	pointY = 5 ;	
	graphDrawMode = off ;
	plotPoint();
	pointX = 5*2+1 ;
	pointY = 5 ;	
	graphDrawMode = off ;
	plotPoint();

	// ........................ x=5,y=5
	pointX = 7*2 ;
	pointY = 7 ;	
	graphDrawMode = on ;
	plotPoint();
	pointX = 7*2+1 ;
	pointY = 7 ;	
	graphDrawMode = off ;
	plotPoint();
*/	
	//graphBitMapOff();
	
	//graphEnd();
	
	return 0 ;
}
