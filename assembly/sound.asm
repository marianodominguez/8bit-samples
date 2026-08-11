
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
duration = $C3  ; Zero-page note duration value
state = $C4     ; Zero-page initialization flag

.MACRO SOUND voice,pitch,dist,vol
    LDA :pitch
    STA AUDF1+2*:voice
    LDA #[[:dist * 16] | :vol]
    STA AUDC1+2*:voice
.ENDM

VBI              ; Vertical blank interrupt handler
    LDA state
    BNE SKIP_INIT
    LDA #1
    STA state
    LDA #0
    STA tick
    STA note
    STA pitch
SKIP_INIT
    LDA #0
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
    
    LDA TABLE,X
    STA COLOR0+4   ; Change color for visual feedback
    STA pitch      ; Store current pitch
    LDY #41
    JSR DEBUG
    INX
    LDA TABLE,X   ;get duration of note
    CMP #$FF
    BEQ reset
    STA duration
    LDY #1
    ADC #16
    JSR DEBUG
    INC tick
    LDA tick
    CMP duration
    BNE PLAY_NOTE
    LDA #0
    STA tick
    LDX note
    INX
    INX
    STX note
    CPX #82
    BNE SKIP_RESET
reset
    LDX #0
    STX note
    STX tick

SKIP_RESET
    LDX note
PLAY_NOTE
    
    SOUND 0,pitch,10,8 ; Play current note on voice 0
SKIP
    JMP XITVBV

DEBUG            ; Helper to save A into zero page using Y offset
    STA (SAVMSC),Y
    RTS

.MACRO NOTE_PAIR pitch,duration
    .BYTE :pitch, :duration
.ENDM

.MACRO REST duration
    NOTE_PAIR 0, :duration
.ENDM

TABLE
    ; First phrase
    NOTE_PAIR 35,10
    NOTE_PAIR 40,10
    NOTE_PAIR 35,40
    REST 10
    NOTE_PAIR 40,10
    NOTE_PAIR 45,10
    NOTE_PAIR 47,10
    NOTE_PAIR 53,10
    NOTE_PAIR 57,20
    NOTE_PAIR 53,20
    REST 10

    ; Second phrase
    NOTE_PAIR 72,10
    NOTE_PAIR 81,10
    NOTE_PAIR 72,40
    REST 10
    NOTE_PAIR 96,20
    NOTE_PAIR 91,20
    NOTE_PAIR 114,20
    NOTE_PAIR 108,20
    REST 30

    ; Third phrase
    NOTE_PAIR 144,10
    NOTE_PAIR 162,10
    NOTE_PAIR 182,20
    NOTE_PAIR 193,20
    NOTE_PAIR 217,20
    NOTE_PAIR 230,20
    NOTE_PAIR 66,20
    NOTE_PAIR 230,10
    NOTE_PAIR 193,10

    ; Fourth phrase
    NOTE_PAIR 162,20
    NOTE_PAIR 136,20
    NOTE_PAIR 121,20
    NOTE_PAIR 96,20
    NOTE_PAIR 81,20
    NOTE_PAIR 68,20
    NOTE_PAIR 108,20
    NOTE_PAIR 91,20
    NOTE_PAIR 72,20
    NOTE_PAIR 53,20
    REST 20
    REST $FF ; this signals end of song, will loop back to start

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
