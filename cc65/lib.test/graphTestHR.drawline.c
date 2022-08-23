
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include "../lib/C64.h"
#include "../lib/graph.h"


// cl65 -t c64 graphTestHR.drawline.c ..\lib\graphA.s ..\lib\graph.c -o x.prg

int main ( void )
{
	int msec = 0, trigger = 10; /* 10ms */
	clock_t difference ;
	clock_t before = clock();	
	int x,y ;
	int iterations=0 ;
	
	graphInit(graphMode320x200);
	
	graphBitMapOn();
	
	graphBitMapClear();
	
	cBackGround = cYellow;	; // graphColor0
	cForeGround = cRed;		; // graphColor1
	
	graphSetHiresColor();

	do {
		for ( x=0;x<320;x+=50)	
			for ( y=0;y<199;y+=50)	
			{
				graphColor(cColor1);
				graphLine(320-x,200-y,x,y) ;
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

/*
			-O
HR	4.383 	4.383
HR2	3.733 	3.733 
HR2	3.150 	3.166 global var
HR3 3.100	3.100 graphColor

MC	1.550	1.550
MC	1.500	1.500

*/


