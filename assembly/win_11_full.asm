        ORG   $0302
SAVMSC = $58
MAXLEN = 100
strp   = $C0
offset = $C2
asc    = $C4

START
        LDA SAVMSC
        STA asc
        LDA SAVMSC+1
        STA asc+1

        LDA #40
        STA offset
        LDX #<string
        LDY #>string
        JSR print

        LDA #80
        STA offset
        LDX #<string1
        LDY #>string1
        JSR print
pause   JMP pause

print   CLC
        LDA SAVMSC
        ADC offset
        STA asc
        STX strp
        STY strp+1
        LDY #0
prn     LDA (strp),Y
        CMP #$9B
        BEQ pre
        STA (asc),Y
        INY
        CPY #MAXLEN
        BNE prn
pre     RTS
string 	.BYTE $7C,"    This computer can't run Win11   ",$7C,$9B
string1 .BYTE $7C,"        Learn 6502 assembler        ",$7C,$9B 