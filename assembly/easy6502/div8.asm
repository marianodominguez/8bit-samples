define YX4LO $F0
define YX4HI $F1
define X1 $F2
define PIXLO $F3
define PIXHI $F4
define SAVMSC $20
define SAVMSCHI $00

    lda #120
    sta X1
    lda #00
    sta PIXLO
    lda #02
    sta PIXHI

start:
    lda X1
    lsr a
    lsr a
    lsr a
    clc
    adc PIXLO
    sta PIXLO
    bcc nocarry
    inc PIXHI
nocarry:
    clc
    lda SAVMSC
    adc PIXLO
    sta PIXLO
    lda SAVMSCHI
    adc PIXHI
    sta PIXHI

    lda #03
    sta PIXLO
    rts