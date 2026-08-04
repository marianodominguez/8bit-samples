
AUDF1=$D200
AUDC1=$D201
AUDCTL=$D208
SKCTL=$D20F
COLOR0=$02C4

VVBLKI=$0222
SETVBV=$E45C
VVBLKD=$0222
XITVBV=$E462
SAVMSC   =  $58

    ORG $2000

pitch=$C0
note=$C1
tick=$C2

.MACRO SOUND voice,pitch,dist,vol
    lda :pitch
    sta AUDF1+2*:voice
    lda #[[:dist * 16] | :vol]
    sta AUDC1+2*:voice
.ENDM

vbi
    lda #0
    sta tick
    sta note
    sta pitch
    sta AUDCTL
    lda #3
    sta SKCTL
; *Insert a vertical blank interrupt to keep the music playing smoothly*
    lda #$07
    ldx #>start
    ldy #<start
    JSR SETVBV
wait
    jmp wait
    RTS

start
    ldx note
    ldy #41
    lda note
    adc #16
    jsr debug

    lda table,x
    sta COLOR0+4
    sta pitch

    lda tempo,x
    ldy #1
    jsr debug
    cmp tick
    bne skip
    lda #0
    sta tick
    inc note
    lda note
    cmp #34
    bne skip_reset
    ldx #0
    stx note
    stx tick
    SOUND 0,0,0,0
skip_reset
    SOUND 0,pitch,10,8
skip
    inc tick
    JMP XITVBV

debug
    sta (SAVMSC),y
    RTS
table
    .byte 0, 35, 40, 45, 47, 53, 57, 53, 72, 81, \
         91, 96, 108, 114, 108, 144, 162, 182, 193, \
         217,230, 33, 230, 193, 162, 136, 121, 96, 81, \
         68, 108, 91, 72, 53
tempo
    .byte 10, 10, 10, 40, 10, 10, 10, 10, 10, 40, 10, 10, 40, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10
    RUN vbi
    END

; notes [
; "A5", "G5", "F5", "E5", "D5", "C#5", "D5",
; "A4", "G4", "F4", "E4", "D4", "C#4", "D4",
; "A3", "G3", "F3", "E3", "D3", "C#3", "Bb2",
; "C#3", "E3", "G3", "Bb3", "C#4", "E4", "G4", "Bb4",
; "D4", "F4", "A4", "D5"
; ]


; C3	243	
; C3#	230	
; D3	217
; D3#	204	
; E3	193	
; F3	182	 
; F3#	172	
; G3	162	 
; G3#	153
; A3	144	
; A3#	136
; B3	128	
; C4	121	
; C4#	114
; D4	108
; D4#	102
; E4	96
; F4	91
; F4#	85
; G4	81
; G4#	76
; A4	72
; A4#	68
; B4	64	 	
; C5	60	
; C5#	57	 
; D5	53	 
; D5#	50	 
; E5	47	 
; F5	45	 
; F5#	42	 
; G5	40	 
; G5#	37	 
; A5	35	 
; A5#	33	 
; B5	31	
