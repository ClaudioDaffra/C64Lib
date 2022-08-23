
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include "../lib/C64.h"
#include "../lib/graph.h"


// cl65 -t c64 graphTest.setBank4.c ..\lib\graphA.s ..\lib\graph.c -o x.prg -Osir -Cl



_graphSetBank4:		;	c000 - ffff

	; --------------- BANK
			
	lda	$dd00		
	and #%11111100
	ora	#%00000000	;	11 bank0 - 10 bank1 - 01 bank2 -  [ 00 bank3 ] 
	sta $dd00
	
	; --------------- set bitmap $e000

	lda #$00
	sta graphBitMap
	
	lda #$e0
	sta graphBitMap+1
 	

	; --------------- set screen $c000

	lda	$d018		
	and #%00001111
	ora	#%00000000	;	start at 0 
	sta $d018
	
	lda #$00
	sta graphScreen 
	
	lda #$c0
	sta graphScreen+1


 
	; --------------- rom to ram default $01 (%00110111)
	
	lda #%00110110
	sta $01
	
	rts
	
_graphSetBank0:		;	0000 - 3fff

	lda	#151		; default bank 0
	sta $dd00

	; --------------- set bitmap +$2000
	
	lda #$00
	sta graphBitMap
	 
	lda #$20
	sta graphBitMap+1

	; --------------- set screen +$0400

	lda #21		
	sta $d018
	
	lda #$00
	sta graphScreen
	 
	lda #$c0
	sta graphScreen+1

	; --------------- default bank
	
	lda	#55		; default mem 0
	sta $01
	
	rts
	
	
	
	.export _graphSetBank4
	.export _graphSetBank0
	
int main ( void )
{
	int msec = 0, trigger = 10; /* 10ms */
	clock_t difference ;
	clock_t before = clock();	

	int iterations=0,color=1 ;

	//
	
	graphSetBank4();
	
	//
 
	graphInit(graphMode160x200);
	
	graphBitMapOn();

	graphBitMapClear();

	graphColor0	= cRed;
	graphColor1 = cYellow;
	graphColor2 = cBlue ;
	graphColor3 = cGreen ;
	
	graphSetMultiColor();
/*		
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
*/			
	graphBitMapOff();
	
	graphEnd();

	//
 
	graphSetBank0();
	
	//
	
	__asm__ ( "jsr $e544");
	
	printf("\nTime taken \n%d seconds \n%d milliseconds \n(%d iterations)\n",  msec/1000, msec%1000, iterations);

	return 0 ;
	
	return 0 ;
}

/*
 

 #3 hr 3.330
 
 #4 mc 3.416
 
*/


