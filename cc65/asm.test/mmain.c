
#include <stdio.h>
#include <peekpoke.h>
#include "..\asm\c64.h"
#include "..\asm\cgraf.h"



// cl65 -t c64 agraf.asm cgraf.c main.c -o x.prg 

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
	TESTgraphHiresColor();
	
	//TESTgraphMultiColor();
	
	graphTextMode();// graph off
	//graphOff(); // graph off and Inter Rom default

	graphDefaultColor();
	
	return 0 ;
}



