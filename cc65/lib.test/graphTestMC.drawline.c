
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include "../lib/C64.h"
#include "../lib/graph.h"


// cl65 -t c64 graphTestMC.drawline.c ..\lib\graphA.s ..\lib\graph.c -o x.prg



int main ( void )
{
	int msec = 0, trigger = 10; /* 10ms */
	clock_t difference ;
	clock_t before = clock();	
	int x,y ;
	int iterations=0 ;
	int color=0;
	
	graphInit(graphMode160x200);

	graphBitMapOn();

	graphBitMapClear();
	
	graphColor0	= cRed;
	graphColor1 = cYellow;
	graphColor2 = cBlue ;
	graphColor3 = cGreen ;
	
	graphSetMultiColor();


	do {
		for ( x=0;x<160;x+=50)	
			for ( y=0;y<199;y+=50)	
			{
				if ( color++>3) color=1;
				
				graphColor(color);
				graphLine(160-x,200-y,x,y) ;
				
				iterations++;
			}

	  difference = clock() - before;
	  msec = difference * 1000 / CLOCKS_PER_SEC;
	  
	} while ( msec < trigger );
			
	graphBitMapOff();
	
	graphEnd();
	
	//__asm__ ( "jsr $e544");
	
	printf("\nTime taken \n%d seconds \n%d milliseconds \n(%d iterations)\n",  msec/1000, msec%1000, iterations);

	return 0 ;
	
	return 0 ;
}

