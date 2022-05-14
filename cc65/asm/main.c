
#include <stdio.h>
#include <peekpoke.h>
#include "c64.h"
#include "cgraf.h"



// cl65 -t c64 lgraf.s main.c -o x.prg

int TESTgraphHiresColor ( void ) 
{
	//graphHiresColor();
	graphInit(graphMode320x200);
	
	//graphBitmapClear();
	graphBitmapClearFast();
	
	graphColor0=cGreen;		// verde
	graphColor1=cYellow;	// gallo
	
	graphScreenClear();

	graphIntRomDisable();

	graphColor(cColor1) ;
	graphPixel( 1,1 ) ;
	graphPixel( 3,3 ) ;	
	graphPixel( 5,5 ) ;
	graphPixel( 7,7 ) ;	

	graphPixel( 319,199 ) ;	

	graphColor(cColor0) ;
	graphPixel( 3,3 ) ;

	graphIntRomEnable();		
	
	// gText();
	
	
	return 0 ;
}
int TESTgraphMultiColor ( void ) 
{
	//unsigned int i,counter=0;
	//graphMultiColor();
	graphInit(graphMode160x200);
	
	//graphBitmapClear();
	graphBitmapClearFast();

	graphColor0=cGreen;	
	graphColor1=cWhite;	
	graphColor2=cBlue;	
	graphColor3=cBlack;	
	
	graphSetMultiColor();
	
	graphIntRomDisable();

	graphColor(cColor1) ;
	graphPixel( 1,1 ) ;
	
	graphColor(cColor2) ;
	graphPixel( 3,3 ) ;	
	
	graphColor(cColor3) ;	
	graphPixel( 5,5 ) ;

	graphColor(cColor0) ;	
	graphPixel( 7,7 ) ;	

	graphColor(cColor1) ;	
	graphPixel( 9,9 ) ;	

	graphColor(cColor1) ;	
	graphPixel( 159,199 ) ;	
	
	graphIntRomEnable();		

	return 0 ;
}
int main( void )
{
	//TESTgraphHiresColor();
	
	TESTgraphMultiColor();
	
	//gtext();

	//graphOff();
	
	//printf("[%d]\r\n",graphMode);
	
	return 0 ;
}



