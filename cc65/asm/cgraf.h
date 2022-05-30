
#ifndef LGRAF
#define LGRAF

#define graphMode320x200	0
#define graphMode160x200	1

// prototype

extern void __fastcall__ graphHiresColor(void);
extern void __fastcall__ graphMultiColor(void);
extern void __fastcall__ graphTextMode(void);
extern void __fastcall__ graphBitmapClear(void);
extern void __fastcall__ graphBitmapClearFast(void);
extern void __fastcall__ graphIntRomDisable(void);
extern void __fastcall__ graphIntRomEnable(void);
extern void __fastcall__ graphScreenClear(void); 
extern void __fastcall__ graphSetMultiColor(void);
extern void __fastcall__ graphOff(void);
extern void __fastcall__ graphInit(unsigned char graphMode) ;

// color

extern unsigned char graphColor0 ;
extern unsigned char graphColor1 ;
extern unsigned char graphColor2 ;
extern unsigned char graphColor3 ;

// draw mode

extern unsigned char graphDrawMode ;
extern unsigned char graphMode ;
#define graphColor(C) graphDrawMode=(C);

// plot 

extern unsigned int  pointX 	;
extern unsigned char pointY 	; 
extern void __fastcall__  plotPoint				(void) ;
extern void __fastcall__  plotPointMC			(void) ;

void gPixel		(void) ;
#define graphPixel(x,y) do{pointX=(x);pointY=(y);gPixel();}while(0);

void gDrawPixel	(void);
#define graphDrawPixel(x,y) do{pointX=(x);pointY=(y);gDrawPixel();}while(0);

void graphDefaultColor(void);

void graphEnd(void) ;

#define graphLine( LX1,LY1,LX2,LY2 ) do{ lineX1=(LX1); lineY1=(LY1); lineX2=(LX2); lineY2=(LY2); GraphLine(); } while(0);


// graph.c : graphLine

extern unsigned char 	lineY1	, lineY2 ;
extern int 				lineX1  , lineX2 ;

// GraphLine Local Private

extern int GraphLineDelta	,	GraphLineDX,	GraphLineDY ;
extern int GraphLineAI		,	GraphLineBI,	GraphLineXI,	GraphLineYI;

extern void GraphLine (void) ;

#undef clock
#define clock()			((PEEK(160)*65536)+(PEEK(161)*256+PEEK(162)))
#define TIME_SEC(T) 	(T/2000)
#define TIME_mSEC(T) 	((T%1000))

#endif



