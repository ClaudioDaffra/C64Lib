
#include <stdio.h>
#include <peekpoke.h>
#include "..\asm\c64.h"
#include "..\asm\cgraf.h"



// cl65 -t c64 ..\asm\agraf.asm ..\asm\cgraf.c drawPixel.HR.c -o x.prg 

int TESTgraphHiresColor ( void ) 
{
	//graphHiresColor();
	graphInit(graphMode320x200);
	
	//graphBitmapClear();
	graphBitmapClearFast();
	
	graphColor0=cGreen;		// verde
	graphColor1=cYellow;	// gallo

	graphScreenClear();

	graphColor(cColor1) ;
	
	graphDrawPixel( 1,1 ) ;
	graphDrawPixel( 3,3 ) ;	
	graphDrawPixel( 5,5 ) ;
	graphDrawPixel( 7,7 ) ;	

	graphDrawPixel( 319,199 ) ;	

	graphColor(cColor0) ;
	graphDrawPixel( 3,3 ) ;

	return 0 ;
}


int main( void )
{
	TESTgraphHiresColor();

	//graphEnd();
	
	return 0 ;
}



