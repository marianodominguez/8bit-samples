GR. 7+16
DIM A(256) byte
screen=PEEK($59)*256+PEEK($58)
OPEN #1,8,0,"D:ABEJUARE.BMP"
' read header
BGET #1,ADR(A),154-32+40
WHILE ERR()=1
    BGET #1,ADR(A),160
    FOR I=0 TO 159
        dbyte=A(I)
        POKE(screen+I, dbyte);
    NEXT I
WEND
