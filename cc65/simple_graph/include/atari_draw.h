#if !defined(__ATARI__)
#  error This module may only be used when compiling for the Atari!
#endif

extern void __fastcall__ plot (unsigned char x, unsigned int y);
extern void __fastcall__ drawto (unsigned char x, unsigned int y);
extern void __fastcall__ color (unsigned char c);