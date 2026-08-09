
AUDF1 = $D200   ; Audio frequency register for voice 1
AUDC1 = $D201   ; Audio control register for voice 1
AUDCTL = $D208  ; Audio control register
SKCTL = $D20F   ; Audio/keyboard control register
COLOR0 = $02C4  ; Screen color register

VVBLKI = $0222  ; Vertical blank interrupt vector address
SETVBV = $E45C  ; OS routine to set VBI vector
VVBLKD = $0222  ; Vertical blank vector pointer (duplicate alias)
XITVBV = $E462 ; OS return-from-VBI routine
SAVMSC = $58    ; Zero-page pointer used by DEBUG routine

    ORG $2000    ; Program load address

pitch = $C0     ; Zero-page temporary pitch value
note = $C1      ; Zero-page note index
tick = $C2      ; Zero-page tempo tick counter

.MACRO SOUND voice,pitch,dist,vol
    LDA :pitch
    STA AUDF1+2*:voice
    LDA #[[:dist * 16] | :vol]
    STA AUDC1+2*:voice
.ENDM

VBI              ; Vertical blank interrupt handler
    LDA #0
    STA tick
    STA note
    STA pitch
    STA AUDCTL
    LDA #3
    STA SKCTL
    ; Install the VBI routine at the OS vector
    LDA #$07
    LDX #>START
    LDY #<START
    JSR SETVBV
WAIT
    JMP WAIT
    RTS

START            ; Main music playback entry point
    LDX note
    LDY #41
    LDA note
    ADC #16
    JSR DEBUG

    LDA TABLE,X
    STA COLOR0+4   ; Change color for visual feedback
    STA pitch      ; Store current pitch

    LDA TEMPO,X
    LDY #1
    JSR DEBUG
    CMP tick
    BNE SKIP
    LDA #0
    STA tick
    INC note
    LDA note
    CMP #41
    BNE SKIP_RESET
    LDX #0
    STX note
    STX tick
    
SKIP_RESET
    SOUND 0,0,0,0

;    LDX #0
; DELAY
;     INX
;     CPX #10
;     BNE DELAY
    
    SOUND 0,pitch,10,8 ; Play current note on voice 0
SKIP
    INC tick
    JMP XITVBV

DEBUG            ; Helper to save A into zero page using Y offset
    STA (SAVMSC),Y
    RTS

TABLE
    .BYTE 35,40,35,0,40,45,47,53,57,53,0,\
          72,81,72,0,96,91,114,108,0,\
          144,162,182,193,217,230,66,\
          230,193,162,136,121,96,81,\
          68,108,91,72,53,0,0
TEMPO
    .BYTE 10,\
          10,10,40,10,10,10,10,20,20,20,\
          10,\
          10,10,40,10,20,20,20,20,30,\
          10,10,40,10,10,10,10,\
          10,10,40,20,20,20,20,\
          20,20,20,20,20,20,40
    RUN VBI
    END

; Song notes sequence in table order:
; A5, G5, A5,, G5, F5, E5, D5, C#5, D5
; A4, G4, A4, E4, F4, C#4, D4,,
; A3, G3, F3, E3, D3, C#3, Bb2,
; C#3, E3, G3, Bb3, C#4, E4, G4, Bb4,
; D4, F4, A4, D5

; Pitch constants (approximate values):
; C3 243, C#3 230, D3 217, D#3 204, E3 193, F3 182, F#3 172,
; G3 162, G#3 153, A3 144, A#3 136, B3 128,
; C4 121, C#4 114, D4 108, D#4 102, E4 96, F4 91, F#4 85,
; G4 81, G#4 76, A4 72, A#4 68, B4 64,
; C5 60, C#5 57, D5 53, D#5 50, E5 47, F5 45, F#5 42, G5 40, G#5 37,
; A5 35, A#5 33, B5 31
