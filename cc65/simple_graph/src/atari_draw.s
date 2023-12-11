;
; Mariano Domínguez
; 2022-12-4
;
; atari draw lib
;
        .export      __plot,__drawto,__color,__setscreen, __clear,__fast_draw
        .import      popa,popax,gotoxy,fdtoiocb
        .importzp    tmp1,tmp2,tmp3,tmp4,ptr1,ptr2,ptr3

        .include "atari.inc"

COLOR = $C8 ; not in include. taken from Atari basic source book
PIXLO=ptr1
PIXHI=ptr1+1
DX=tmp2
DY=tmp3
TXTW=660

;todo get proper addr for these
YX4HI=$E1
YX4LO=$E2
PIXZ=$E3
X2=$E4
Y2=$E6
dtmp=$E7
X1=$E8
Y1=$EA


; set border for debug
.proc debug
    LDA TXTW
    STA ptr3
    LDA TXTW+1
    STA ptr3+1
    LDY dtmp
    LDA Y1
    CLC
    ADC #16
    STA (ptr3),y
    iny
    sty dtmp
    RTS
.endproc

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

.proc __fast_draw ;int x1,char y1,int x2,char y2
    ;store y2
    sta Y2
    ;store X1
    jsr popax
    sta X2
    sta X2+1;

    jsr popa ;get y1
    sta Y1
    ;jsr debug

    ;store x1
    jsr popax
    sta X1
    stx X1+1

    jsr find_row
    jsr find_col
    ;find but for pixel to draw
    lda X1
    and #7
    tax
    lda PIXTAB,x
    sta PIXZ
    ldy #0
    lda PIXZ
    ora (PIXLO),y
    sta (PIXLO),y
    ;line routine called here
    rts
.endproc

; find row Yx40, in accumulator
.proc find_row
    lda Y1
    lsr a
    lsr a
    lsr a
    lsr a       ;y/16
    sta PIXHI
    lsr a       ;y/32
    lsr a       ;y/64
    sta YX4HI   ;y/64*256
    lda Y1
    asl a       ;y*2
    asl a       ;y*4
    sta YX4LO
    asl a       ;y*8
    asl a       ;y*16
    clc
    adc YX4LO   ;y*16+y*4
    sta PIXLO
    lda PIXHI   
    adc YX4HI
    sta PIXHI
    ; y*20 multiply per 2
    clc
    asl PIXLO
    lda PIXHI
    adc #0
    sta PIXHI
    rts
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
    rts
.endproc

;SIOCB screen channel, slow but safest location
SIOCB: .byte $00

PIXTAB: .byte 128,64,32,16,8,4,2,1