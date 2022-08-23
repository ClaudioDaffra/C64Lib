
#include <stdio.h>
#include <peekpoke.h>
#include <stdlib.h>
#include <time.h>
#include "..\asm\c64.h"
#include "..\asm\cgraf.h"



// cl65 -t c64 ..\asm\agraf.asm ..\asm\cgraf.c drawLine.HR.c -o x.prg 
// cl65 -t c64 ..\asm\agraf.asm ..\asm\cgraf.c drawLine.HR.c -o x.prg -Osri -Cl

int TESTgraphHiresColor ( void ) 
{
	int msec , trigger ; /* 10ms */
	clock_t difference ;
	clock_t before ;	
	int x,y ;
	unsigned int iterations ;
 	
	
	before = clock();
	trigger = 10;
	msec = 0 ;
	
	//graphHiresColor();
	graphInit(graphMode320x200);
	
	//graphBitmapClear();
	graphBitmapClearFast();
	
	graphColor0=cGreen;		// verde
	graphColor1=cYellow;	// gallo

	graphScreenClear();

	graphColor(cColor1) ;
 
	iterations=0;
 
		for ( x=0;x<320;x+=50)	
			for ( y=0;y<199;y+=50)	
			{
				graphLine(320-x,200-y,x,y) ;
				iterations+=1;
			}

	  difference = clock() - before;
	  msec = difference / CLOCKS_PER_SEC ;
 
	graphEnd();

	printf("\nTime taken \n%d seconds \n%u milliseconds \n(%u iterations)\n"
	                   ,  TIME_SEC(msec)    , TIME_mSEC(msec)        , iterations);

	return 0 ;
}

int main( void )
{
	TESTgraphHiresColor();

	//graphEnd();
	
	return 0 ;
}

// 3.158 / 3.61
// 3.158 / 0.68
