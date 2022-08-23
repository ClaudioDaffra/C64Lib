
#include <stdio.h>
#include <peekpoke.h>
#include <stdio.h>
#include <peekpoke.h>
#include <stdlib.h>
#include <time.h>
#include "..\asm\c64.h"
#include "..\asm\cgraf.h"



// cl65 -t c64 ..\asm\agraf.asm ..\asm\cgraf.c drawLine.MC.c -o x.prg 
// cl65 -t c64 ..\asm\agraf.asm ..\asm\cgraf.c drawLine.MC.c -o x.prg -Osri -Cl



int TESTgraphMultiColor ( void ) 
{
	int msec , trigger ; /* 10ms */
	clock_t difference ;
	clock_t before ;	
	int x,y ;
	unsigned int iterations ;
 	int count;
  
    
    
	before = clock();
	trigger = 10;
	msec = 0 ;
	count=0; 
 
	graphInit(graphMode160x200);

	graphBitmapClearFast();
	
	graphColor0=cGreen;	
	graphColor1=cWhite;	
	graphColor2=cBlue;	
	graphColor3=cRed;	
	
	graphSetMultiColor();

	graphColor(cColor1) ;
 
	iterations=0;
    count=0;
 
    graphLine(0,199,319,199) ;

		for ( x=0;x<160;x+=5)	
			for ( y=0;y<200;y+=5)	
			{
				if (++count>3) count=1;
				graphColor(count) ;
				
				graphLine(159-x,199-y,x,y) ;
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
	TESTgraphMultiColor();

	//graphEnd();
	
	return 0 ;
}

 
