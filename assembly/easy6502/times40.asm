define YX4LO $F0
define YX4HI $F1
define Y1 $F2
define PIXLO $F3
define PIXHI $F4

start:
    lda #3
    sta Y1
    lda #0
    sta PIXLO
    lda #02
    sta PIXHI

    lda #0
    sta YX4HI   ;y1*1
    lda Y1
    sta YX4LO

    asl YX4LO
    rol YX4HI   ;2*y1
    asl YX4LO
    rol YX4HI   ;4*y1
    asl YX4LO
    rol YX4HI   ;8*y2
    clc
    lda YX4LO
    adc PIXLO
    sta PIXLO
    lda YX4HI
    adc PIXHI
    sta PIXHI

    asl YX4LO
    rol YX4HI   ;16*y2
    asl YX4LO
    rol YX4HI   ;32*y2
    clc
    lda YX4LO
    adc PIXLO
    sta PIXLO
    lda YX4HI
    adc PIXHI
    sta PIXHI

    LDY #0
loop:
    LDA #3
    STA (PIXLO),Y
    INY
    BNE loop
    RTS
