;
; Mariano Domínguez
; 2022-12-4
;
; atari draw lib
;
        .export      _plot,_drawto,_color
        .import      popa,gotoxy
        .importzp    tmp1

        .include "atari.inc"

.proc _color
    sta tmp1
    rts
.endproc

; play sound, arguments: voice, pitch, distortion, volume
.proc  _plot
    jsr gotoxy
    ldx #$60
    lda #$B
    sta ICCOM,x
    lda #0
    sta ICBLL,X
    sta ICBLH,x
    lda tmp1
    jsr ciov
    rts
.endproc

.proc _drawto
    rts
.endproc