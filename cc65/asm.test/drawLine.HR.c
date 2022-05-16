
#include <stdio.h>
#include <peekpoke.h>
#include "..\asm\c64.h"
#include "..\asm\cgraf.h"

#include <time.h>


// cl65 -t c64 ..\asm\agraf.asm ..\asm\cgraf.c drawLine.HR.c -o x.prg 
 
int TESTgraphHiresColor ( void ) 
{
	int msec = 0, trigger = 10; /* 10ms */
	clock_t difference ;
	clock_t before = clock();	
	int x,y ;
	int iterations=0 ;
	
	//graphHiresColor();
	graphInit(graphMode320x200);
	
	//graphBitmapClear();
	graphBitmapClearFast();
	
	graphColor0=cGreen;		// verde
	graphColor1=cYellow;	// gallo

	graphScreenClear();

	graphColor(cColor1) ;

	//do {
		for ( x=0;x<320;x+=50)	
			for ( y=0;y<199;y+=50)	
			{
				graphColor(cColor1);
				graphLine(320-x,200-y,x,y) ;
				iterations++;
			}

	  difference = clock() - before;
	  msec = difference * 1000 / CLOCKS_PER_SEC;
	  
	//} while ( msec < trigger );

	graphEnd();

	printf("\nTime taken \n%d seconds \n%d milliseconds \n(%d iterations)\n",  msec/1000, msec%1000, iterations);

	return 0 ;
}

int main( void )
{
	TESTgraphHiresColor();

	//graphEnd();
	
	return 0 ;
}



