
#include "graph.h"

/*

	graphPixel( flag  , x , y ) ;
	
*/

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

// .......................................................... GraphLine

// global var

unsigned char 	lineY1	, lineY2	;	// pointY 
int 			lineX1  , lineX2 	;	// pointX

// GraphLine Local Private

int GraphLineDelta	,	GraphLineDX,	GraphLineDY ;
int GraphLineAI		,	GraphLineBI,	GraphLineXI,	GraphLineYI;

void GraphLine (void) 
{
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
 
	graphPixel ( lineX1,lineY1 );
 
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
			graphPixel ( lineX1,lineY1);
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
			graphPixel ( lineX1,lineY1);
		}
	}
}

int GraphCirclexxc  , GraphCircleyyc 	;
int GraphCirclexxcm , GraphCircleyycm ;
int GraphCircleyxc  , GraphCirclexyc 	;
int GraphCircleyxcm , GraphCirclexycm	;
int GraphCirclex	   ; 
unsigned char GraphCircley	;
int GraphCirclexc   ;
unsigned char GraphCircleyc	;
int GraphCircleD;

// +0+1
// 2000
// lohi
// 0020

void GraphCircleModeMC(void) 
{
	if (graphMode==graphMode160x200) 
	{ 
		__asm__("pha" );
		__asm__("txa" );
		__asm__("pha" );
		
		__asm__("ldx #1" );
		
		//GraphCirclexxc/=2; 	
		__asm__("lsr %v,x",GraphCirclexxc  );
		__asm__("ror %v"  ,GraphCirclexxc  );	
		//GraphCirclexxcm/=2;
		__asm__("lsr %v,x",GraphCirclexxcm  );
		__asm__("ror %v"  ,GraphCirclexxcm  );
		//GraphCircleyxc/=2;
		__asm__("lsr %v,x",GraphCircleyxc  );
		__asm__("ror %v"  ,GraphCircleyxc  );
		//GraphCircleyxcm/=2;
		__asm__("lsr %v,x",GraphCircleyxcm  );
		__asm__("ror %v"  ,GraphCircleyxcm  );

		__asm__("pla" );
		__asm__("tax" );
		__asm__("pla" );	
 		
	}
}
 
void GraphCircle(int r)  
{  
	int GraphCirclex=0,GraphCircley=r,GraphCircleD=3-(2*r);

	GraphCirclexxc		=	 GraphCirclex+GraphCirclexc;
	GraphCircleyyc		=	 GraphCircley+GraphCircleyc;
	GraphCirclexxcm		=	-GraphCirclex+GraphCirclexc;
	GraphCircleyycm		=	-GraphCircley+GraphCircleyc;
	GraphCircleyxc		=	 GraphCircley+GraphCirclexc;
	GraphCirclexyc		=	 GraphCirclex+GraphCircleyc; 
	GraphCircleyxcm		=  	-GraphCircley+GraphCirclexc;
	GraphCirclexycm 	= 	-GraphCirclex+GraphCircleyc;

	GraphCircleModeMC();
	
	graphPixel( GraphCirclexxc	 , GraphCircleyyc 	);  
	graphPixel( GraphCirclexxc	 , GraphCircleyycm 	);  
	graphPixel( GraphCirclexxcm  , GraphCircleyycm 	);  
	graphPixel( GraphCirclexxcm  , GraphCircleyyc 	);  
	graphPixel( GraphCircleyxc   , GraphCirclexyc 	);  
	graphPixel( GraphCircleyxc   , GraphCirclexycm 	);  
	graphPixel( GraphCircleyxcm	 , GraphCirclexycm 	);  
	graphPixel( GraphCircleyxcm  , GraphCirclexyc 	);   
 
	while(GraphCirclex<=GraphCircley)  
	{  
		if(GraphCircleD<=0)  
		{  
			GraphCircleD=GraphCircleD+(4*GraphCirclex)+6;  
		}  
		else  
		{  
			GraphCircleD=GraphCircleD+(4*GraphCirclex)-(4*GraphCircley)+10;  
			GraphCircley=GraphCircley-1;  
		}  

		GraphCirclex=GraphCirclex+1; 

		GraphCirclexxc	=	 GraphCirclex+GraphCirclexc;
		GraphCircleyyc	=	 GraphCircley+GraphCircleyc;
		GraphCirclexxcm	=	-GraphCirclex+GraphCirclexc;
		GraphCircleyycm	=	-GraphCircley+GraphCircleyc;
		GraphCircleyxc	=	 GraphCircley+GraphCirclexc;
		GraphCirclexyc	=	 GraphCirclex+GraphCircleyc; 
		GraphCircleyxcm =	-GraphCircley+GraphCirclexc;
		GraphCirclexycm = 	-GraphCirclex+GraphCircleyc;

		GraphCircleModeMC();
	
		graphPixel( GraphCirclexxc	 , GraphCircleyyc 	);
		graphPixel( GraphCirclexxc	 , GraphCircleyycm 	); 

		graphPixel( GraphCirclexxcm  , GraphCircleyycm 	);  
		graphPixel( GraphCirclexxcm  , GraphCircleyyc 	); 
 
		graphPixel( GraphCircleyxc   , GraphCirclexyc 	);  
		graphPixel( GraphCircleyxc   , GraphCirclexycm 	);
	
		graphPixel( GraphCircleyxcm	 , GraphCirclexycm 	);  
		graphPixel( GraphCircleyxcm  , GraphCirclexyc 	);
	
	}  
}  


/**/



