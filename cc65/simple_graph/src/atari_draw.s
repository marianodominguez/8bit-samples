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
        .define SCR_RAM #32

COLOR = $C8 ; not in include. taken from Atari basic source book
PIXLO=ptr1
PIXHI=ptr1+1
DX=tmp2
DY=tmp3
TXTW=660

;todo get proper addr for these
YX4LO=$F1
YX4HI=$F2
PIXZ=$F3
X2=$F4
Y2=$F6
dtmp=$F7
X1=$F8
Y1=$F0
pixcnt=$FF
q=$EF
dxy=$EE

.include "line.s"

; set border for debug
.proc debug
    LDA TXTW
    STA ptr3
    LDA TXTW+1
    STA ptr3+1
    LDY dtmp
    LDA PIXHI
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
        adc SCR_RAM
        sta tmp1
        lda SAVMSC
        sta PIXLO
sloop:
        lda #0
rloop:
        sta (PIXLO),y
        iny
        bne rloop
        inc PIXHI
        lda PIXHI
        cmp tmp1
        bne sloop
        lda SAVMSC+1
        sta PIXHI
        lda SAVMSC
        sta PIXLO
        rts
.endproc

.proc __fast_draw ;int x1,char y1,int x2,char y2
    ;store y2
    sta Y2
    ;store X2
    jsr popax
    sta X2
    stx X2+1

    jsr popa ;get y1
    sta Y1

    ;store x1
    jsr popax
    sta X1
    stx X1+1

    lda SAVMSC+1
    sta PIXHI
    lda SAVMSC
    sta PIXLO

    jsr Line
    rts
.endproc

; find row Yx40, in accumulator
.proc find_row
    lda #0
    sta YX4HI
    lda Y1
    sta YX4LO  ;y1*1

    asl YX4LO
    rol YX4HI   ;2*y1
    asl YX4LO
    rol YX4HI   ;4*y1
    asl YX4LO
    rol YX4HI   ;yx4lo=8*y1
    clc
    lda PIXLO
    adc YX4LO   ;pixlo+=yx4lo
    sta PIXLO
    lda PIXHI
    adc YX4HI
    sta PIXHI

    asl YX4LO
    rol YX4HI   ;16*y2
    asl YX4LO
    rol YX4HI   ;32*y2
    clc
    lda PIXLO
    adc YX4LO
    sta PIXLO   ;pixlo=8*y1+32*y1
    lda PIXHI
    adc YX4HI
    sta PIXHI
    rts
.endproc

;find the byte x-coord / 8
; TODO: this is 1 byte x
.proc find_col
    lda X1
    lsr a   ;x1 / 2
    lsr a   ;x1 / 4
    lsr a   ;x1 / 8
    clc
    ldx X1+1
    cpx #1
    bne no_high
    adc #31
no_high:
    adc PIXLO
    sta PIXLO
    bcc nocarry
    inc PIXHI
nocarry:
    rts
.endproc

;SIOCB screen channel, slow but safest location
SIOCB: .byte $00

PIXTAB: .byte 128,64,32,16,8,4,2,1