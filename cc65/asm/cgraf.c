
#include "C64.h"
#include "cgraf.h"
#include <peekpoke.h>

// .......................................................... gPixel graphPixel

void gPixel(void)
{
	if ( pointY < 200 )
	{
		switch ( graphMode ) 
		{
			case graphMode320x200:
				if ( pointX < 320 ) plotPoint();
			break ;

			case graphMode160x200:
				pointX=pointX*2;
				if ( pointX < 320 ) plotPointMC();
			break ;

		}
	}
}

// .......................................................... graph draw pixel (INT/ROM)

void gDrawPixel(void)
{
	if ( pointY < 200 )
	{
		switch ( graphMode ) 
		{
			case graphMode320x200:
				if ( pointX < 320 ) 
				{
					graphIntRomDisable();
					plotPoint();
					graphIntRomEnable();
				}
			break ;

			case graphMode160x200:
				pointX=pointX*2;
				if ( pointX < 320 ) 
				{
					graphIntRomDisable();
					plotPointMC();
					graphIntRomEnable();
				}
			break ;

		}
	}
}

// .......................................................... graphDefaultColor

void graphDefaultColor(void)
{
	__asm__("lda #14");
	__asm__("jsr _graphSetColor4");
	POKE( backGroundColor, cBlue ) ;	
}




