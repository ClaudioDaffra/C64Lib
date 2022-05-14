
#ifndef LGRAF
#define LGRAF

#define graphMode320x200	0
#define graphMode160x200	1

// prototype

extern void __fastcall__ graphHiresColor(void);
extern void __fastcall__ graphMultiColor(void);
//extern void __fastcall__ gtext(void);
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









#endif