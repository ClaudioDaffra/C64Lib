
#include "cgraf.h"

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