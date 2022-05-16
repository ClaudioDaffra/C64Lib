
#include <stdio.h>
#include <peekpoke.h>
#include "..\asm\c64.h"
#include "..\asm\cgraf.h"

#include <time.h>


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
	//do {
		for ( x=0;x<320;x+=50)	
			for ( y=0;y<199;y+=50)	
			{
				graphLine(320-x,200-y,x,y) ;
				iterations+=1;
			}

	  difference = clock() - before;
	  msec = difference * 1000 / CLOCKS_PER_SEC;
	  
	//} while ( msec < trigger );

	graphEnd();

	printf("\nTime taken \n%d seconds \n%u milliseconds \n(%u iterations)\n"
	,  msec/1000, msec%1000, iterations);

	return 0 ;
}

int main( void )
{
	TESTgraphHiresColor();

	//graphEnd();
	
	return 0 ;
}



