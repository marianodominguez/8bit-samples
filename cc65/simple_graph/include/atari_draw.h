#if !defined(__ATARI__)
#  error This module may only be used when compiling for the Atari!
#endif

extern void __fastcall__ _plot (unsigned int x, unsigned char y);
extern void __fastcall__ _drawto (unsigned int x, unsigned char y);
extern void __fastcall__ _color (unsigned char c);
extern void __fastcall__ _setscreen (unsigned char fd);
extern void __fastcall__ _clear ();
extern void __fastcall__ _fast_draw (unsigned int x1, unsigned char y1,unsigned int x2, unsigned char y2);