
#include <stdio.h>
#include <peekpoke.h>
#include "..\asm\c64.h"
#include "..\asm\cgraf.h"

// cl65 -t c64 ..\asm\agraf.asm ..\asm\cgraf.c drawPixel.MC.c -o x.prg 

int TESTgraphMultiColor ( void ) 
{

	graphInit(graphMode160x200);
	
	//graphBitmapClear();
	graphBitmapClearFast();

	graphColor0=cGreen;	
	graphColor1=cWhite;	
	graphColor2=cBlue;	
	graphColor3=cBlack;	
	
	graphSetMultiColor();
	
	graphColor(cColor1) ;
	graphDrawPixel( 1,1 ) ;
	
	graphColor(cColor2) ;
	graphDrawPixel( 3,3 ) ;	
	
	graphColor(cColor3) ;	
	graphDrawPixel( 5,5 ) ;

	graphColor(cColor0) ;	
	graphDrawPixel( 7,7 ) ;	

	graphColor(cColor1) ;	
	graphDrawPixel( 9,9 ) ;	

	graphColor(cColor1) ;	
	graphDrawPixel( 159,199 ) ;	

	return 0 ;
}

int main( void )
{
	TESTgraphMultiColor();

	//graphEnd();
	
	return 0 ;
}



