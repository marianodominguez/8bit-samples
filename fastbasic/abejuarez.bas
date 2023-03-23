GR. 7+16
DIM A(256) byte
screen=PEEK($59)*256+PEEK($58)
OPEN #1,8,0,"D:ABEJUARE.BMP"
' read header
BGET #1,ADR(A),154-32+40
WHILE ERR()=1
    BGET #1,ADR(A),256
    FOR I=0 TO 254 STEP 2
        dbyte=A(I)
        nbyte=A(I+1)
        dbyte=(dbyte&$f0)<<2|(dbyte&$0f)<<4
        nbyte=(nbyte>>2)|(nbyte&0x0f)
        EXEC plot_b dbyte | nbyte
    NEXT I
WEND
PROC plot_b byte
POKE(screen+I, byte);
ENDPROC
