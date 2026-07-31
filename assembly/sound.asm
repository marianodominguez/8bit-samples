
AUDF1=$D200
AUDC1=$D201
AUDCTL=$D208
SKCTL=$D20F
COLOR0=$02C4

VVBLKI=$0222
SETVBV=$E45C
VVBLKD=$0222
XITVBV=$E462

    ORG $2000

pitch=$C0

.MACRO SOUND voice,pitch,dist,vol
    lda :pitch
    sta AUDF1+2*:voice
    lda #[[:dist * 16] | :vol]
    sta AUDC1+2*:voice
.ENDM

vbi:

    lda #0
    sta pitch
    sta AUDCTL
    lda #3
    sta SKCTL
; *Insert a vertical blank interrupt to keep the music playing smoothly*
    lda #$07
    ldx #>start
    ldy #<start
    JSR SETVBV
wait:
    jmp wait
    RTS

start:

    inc pitch
    lda pitch
    sta COLOR0+4
    ; pause for a while
    ldx #$FF
    SOUND 0,pitch,10,8
    JMP XITVBV
    
    RUN vbi
    END