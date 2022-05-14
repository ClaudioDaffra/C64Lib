
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include "../lib/C64.h"
#include "../lib/graph.h"


// cl65 -t c64 graphTestMC.drawcircle.c ..\lib\graphA.s ..\lib\graph.c -o x.prg -Osir -Cl

int main ( void )
{
	int msec = 0, trigger = 10; /* 10ms */
	clock_t difference ;
	clock_t before = clock();	

	int iterations=0,color=1 ;
	
	graphInit(graphMode160x200);
	
	graphBitMapOn();
	
	graphBitMapClear();
	
	graphColor0	= cRed;
	graphColor1 = cYellow;
	graphColor2 = cBlue ;
	graphColor3 = cGreen ;
	
	graphSetMultiColor();

    iterations=1;
	do {

			while(iterations<20)	
			{
				graphColor(color);
 
				graphCircle(160,100,5*iterations ) ;

				iterations++;
				
				if(++color>3) color=1;
			}
 
	  difference = clock() - before;
	  msec = difference * 1000 / CLOCKS_PER_SEC;
	  
	} while ( msec < trigger );
			
	graphBitMapOff();
	
	graphEnd();
	
	__asm__ ( "jsr $e544");
	
	printf("\nTime taken \n%d seconds \n%d milliseconds \n(%d iterations)\n",  msec/1000, msec%1000, iterations);

	return 0 ;
}

/*
 

 #3 hr 3.330
 
 #4 mc 3.416
 
*/


