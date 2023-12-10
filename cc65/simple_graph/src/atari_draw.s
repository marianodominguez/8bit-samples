;
; Mariano Domínguez
; 2022-12-4
;
; atari draw lib
;
        .export      __plot,__drawto,__color,__setscreen, __clear,__fast_draw
        .import      popa,gotoxy,fdtoiocb
        .importzp    tmp1,tmp2,tmp3,tmp4,ptr1,ptr2

        .include "atari.inc"

COLOR = $C8 ; not in include. taken from Atari basic source book
PIXLO=ptr1
PIXHI=ptr1+1
DX=tmp2
DY=tmp3
X1=ptr2
Y1=tmp4

;todo get proper addr fort these
tmp5=$f1
tmp6=$f2

; set border for debug
; debug:
;    LDA ROWCRS
;    STA COLOR4
;    RTS

; position x,y
.proc __position
    sta ROWCRS    ; Y position
    jsr popa      ; get X
    sta COLCRS    ; Low byte of X
    stx COLCRS+1  ; High byte of X
    rts           ; All done
.endproc

;color c - Set current color
.proc __color
    sta COLOR
    rts
.endproc

;setscreen fd - file descriptor for screen
.proc __setscreen
    jsr fdtoiocb
    sta SIOCB
    rts
.endproc


; plox x,y - x is 2 bytes only in mode 8
.proc  __plot
    jsr __position
    ;ldx #$60        ; For the screen
    ldx SIOCB
    lda #$B         ; Put record
    sta ICCOM,x
    lda #0
    sta ICBLL,X
    sta ICBLH,x
    lda COLOR
    jsr CIOV
    rts
.endproc

; drawto x,y

.proc __drawto
    jsr __position    ; To store info
    lda COLOR     ; Get COLOR
    sta ATACHR    ; Keep CIO happy
    ;ldx #$60      ; The screen again
    ldx SIOCB
    lda #$11      ; For DRAWTO
    sta ICCOM,X   ; Command byte
    lda #$C       ; As in XIO
    sta ICAX1,X   ; Auxiliary 1
    lda #0        ; Clear
    sta ICAX2,X   ; Auxiliary 2
    jsr CIOV      ; Draw the line
    rts
.endproc

; TODO: make this for other graphic modes
.proc __clear
        lda SAVMSC+1
        sta PIXHI
        clc
        adc #32
        sta tmp1
        lda SAVMSC
        sta PIXLO
sloop:  lda #0
rloop:  sta (PIXLO),y
        iny
        bne rloop
        inc PIXHI
        lda PIXHI
        cmp tmp1
        bne sloop
        rts
.endproc

.proc __fast_draw
    ;store x1
    sta X1
    stx X1+1

    jsr popa ;get y1
    sta Y1
    jsr find_row
    jsr find_col
.endproc

; find row Yx40, in accumulator
.proc find_row
    lda Y1
    lsr a
    lsr a
    lsr a
    lsr a  ;clear top nibble
    sta PIXHI
    lsr a
    lsr a
    sta tmp5 ; first 2 bits
    lda Y1
    asl a
    asl a
    asl a
    sta tmp6
    asl a
    asl a
    clc
    adc tmp6
    sta PIXLO
    lda PIXHI
    adc tmp5
    sta PIXHI
.endproc

;find the byte x-coord / 8
; TODO: this is 1 byte x
.proc find_col
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
    lda SAVMSC+1
    adc PIXHI
    sta PIXHI

.endproc

;SIOCB screen channel, slow but safest location
SIOCB: .byte $00