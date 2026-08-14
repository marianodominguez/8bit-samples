SPRX =  $D0
SPRY =  $D1

SCREEN = $D2

    ORG $4000

start:
    LDA SAVMSC
    STA SCREEN ;set screen address
    LDA SAVMSC+1
    STA SCREEN+1

    LDA #10
    STA SPRX ;set x position
    LDA #5
    STA SPRY ;set y position
    
    LDA #0
    JSR MODE ;set graphics mode
    JSR screen_position
    LDY #0
    LDA #0

print_sprite:
    LDA sprite1,Y
    CMP #$FF
    BEQ done
    CMP #13
    BEQ newline
    STA (SCREEN),Y
    INY
    JMP print_sprite
newline:
    LDA SCREEN
    CLC
    ADC #40-4
    STA SCREEN
    LDA SCREEN+1
    ADC #0
    STA SCREEN+1
    INY
    JMP print_sprite
done:

loop:
    JMP loop
sprite1
    .BYTE "ABC",13,"DEF",13,"GHI",$FF
blank
    .BYTE "   ",13,"   ",13,"   ",$FF

    icl "system.inc"

screen_position:
    LDA SCREEN
    ADC SPRX
    STA SCREEN

    LDX #0
pos_loop:
    LDA SCREEN
    ADC #40
    STA SCREEN
    LDA SCREEN+1
    ADC #0
    STA SCREEN+1
    INX
    CPX SPRY
    BNE pos_loop
    RTS