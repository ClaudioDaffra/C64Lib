
#include "C64.h"
#include "cgraf.h"
#include <peekpoke.h>

// .......................................................... gPixel graphDrawPixel

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
					//graphIntRomDisable();
					plotPoint();
					//graphIntRomEnable();
				}
			break ;

			case graphMode160x200:
				pointX=pointX*2;
				if ( pointX < 320 ) 
				{
					//graphIntRomDisable();
					plotPointMC();
					//graphIntRomEnable();
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

// .......................................................... graph end

void graphEnd(void)
{
 	graphTextMode(); 
	//graphOff(); // graph off and Inter Rom default

	graphDefaultColor();
}

// .......................................................... GraphLine

// global var

unsigned char 	lineY1	, lineY2	;	// pointY 
int 			lineX1  , lineX2 	;	// pointX

// GraphLine Local Private

int GraphLineDelta	,	GraphLineDX,	GraphLineDY ;
int GraphLineAI		,	GraphLineBI,	GraphLineXI,	GraphLineYI;

void GraphLine (void) 
{
	//graphIntRomDisable();
	
	if (lineX1 < lineX2)
	{
		GraphLineXI = 1;
		GraphLineDX = lineX2 - lineX1;
	}
	else
	{
		GraphLineXI = -1;
		GraphLineDX = lineX1 - lineX2;
	}

	if (lineY1 < lineY2)
	{
		GraphLineYI = 1;
		GraphLineDY = lineY2 - lineY1;
	}
	else
	{
		GraphLineYI = -1;
		GraphLineDY = lineY1 - lineY2;
	}
 
	graphDrawPixel ( lineX1,lineY1 );
 
	if (GraphLineDX > GraphLineDY)
	{
		GraphLineAI = (GraphLineDY - GraphLineDX) * 2;
		GraphLineBI = GraphLineDY * 2;
		GraphLineDelta = GraphLineBI - GraphLineDX;

		while (lineX1 != lineX2)
		{
			if (GraphLineDelta > 0)
			{
				lineY1 += GraphLineYI;
				GraphLineDelta  += GraphLineAI;
			}
			else
				GraphLineDelta += GraphLineBI;

			lineX1 += GraphLineXI;
			graphDrawPixel ( lineX1,lineY1);
		}
	}
	else
	{
		GraphLineAI = (GraphLineDX - GraphLineDY) * 2;
		GraphLineBI = GraphLineDX * 2;
		GraphLineDelta = GraphLineBI - GraphLineDY;

		while (lineY1 != lineY2)
		{
			if (GraphLineDelta > 0)
			{
				lineX1 += GraphLineXI;
				GraphLineDelta  += GraphLineAI;
			}
			else
				GraphLineDelta += GraphLineBI;

			lineY1 += GraphLineYI;
			graphDrawPixel ( lineX1,lineY1);
		}
	}
	//graphIntRomEnable();
}

