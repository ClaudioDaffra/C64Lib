
#ifndef graph
#define graph

// *************
//
//	graph Lib
//
// *************

// graph

#define vic	53248

#define graphMode320x200	0
#define graphMode160x200	1

// graphA.s

extern void __fastcall__  graphStartHR			(void) ;
extern void __fastcall__  graphEndHR			(void) ;
extern void __fastcall__  graphStartMC			(void) ;
extern void __fastcall__  graphEndMC			(void) ;

extern void __fastcall__  graphInit	    		(unsigned char graphMode) ;
extern void __fastcall__  graphBitMapClear		(void) ;

extern void __fastcall__  graphBitMapOn			(void) ;
extern void __fastcall__  graphBitMapOff		(void) ;

extern void __fastcall__  graphScreenClear1024	(void) ;
extern void __fastcall__  graphScreenClear		(void) ;

extern void __fastcall__  plotPoint				(void) ;
extern void __fastcall__  plotPointMC			(void) ;

extern void __fastcall__  graphEnd				(void) ;
extern void __fastcall__  graphSetMultiColor	(void) ;

extern void __fastcall__  graphSetBank4			(void) ;
extern void __fastcall__  graphSetBank0   		(void) ;

// graphA.inc

extern unsigned char graphMode 		; 

extern unsigned char graphColor0 	; 
extern unsigned char graphColor1 	;
extern unsigned char graphColor2 	; 
extern unsigned char graphColor3 	;

// plot 

extern unsigned int  pointX 	;
extern unsigned char pointY 	; 
extern unsigned char graphDrawMode 	; 
 
// prototype

void gPixel		(void) ;
#define graphPixel(x,y) do{pointX=(x);pointY=(y);gPixel();}while(0);

#define graphColor(C) graphDrawMode=(C);

#define graphSetHiresColor graphScreenClear

#define graphLine( LX1,LY1,LX2,LY2 ) do{ lineX1=(LX1); lineY1=(LY1); lineX2=(LX2); lineY2=(LY2); GraphLine(); } while(0);


// graph.c : graphLine

extern unsigned char 	lineY1	, lineY2 ;
extern int 				lineX1  , lineX2 ;

// GraphLine Local Private

extern int GraphLineDelta	,	GraphLineDX,	GraphLineDY ;
extern int GraphLineAI		,	GraphLineBI,	GraphLineXI,	GraphLineYI;

extern void GraphLine (void) ;

extern int GraphCirclexxc  , GraphCircleyyc 	;
extern int GraphCirclexxcm , GraphCircleyycm 	;
extern int GraphCircleyxc  , GraphCirclexyc 	;
extern int GraphCircleyxcm , GraphCirclexycm	;
extern int GraphCirclex	   ; 
extern unsigned char GraphCircley	;
extern int GraphCirclexc   ;
extern unsigned char GraphCircleyc	;
extern int GraphCircleD;

extern void GraphCircle(int r) ;


#define graphCircle(CX,CY,CR) do{GraphCirclexc=(CX);GraphCircleyc=(CY);GraphCircle(CR);}while(0);


//



#endif
