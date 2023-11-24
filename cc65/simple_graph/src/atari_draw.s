;
; Mariano Domínguez
; 2022-12-4
;
; atari draw lib
;
        .export      __plot,__drawto,__color,__setscreen
        .import      popa,gotoxy,fdtoiocb
        .importzp    tmp1

        .include "atari.inc"

COLOR = $C8 ; not in include. taken from Atari basic source book
SIOCB = $FA ; screen channel, find a permanent location

; set border for debug
debug:
    LDA ROWCRS
    STA COLOR4
    RTS

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

