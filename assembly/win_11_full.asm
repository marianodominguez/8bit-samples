      ORG  $0302
SAVMSC   =  $58
MAXLEN   =  100
STRP    = $C0
OFFSET  = $C2
ASC    = $C4

START
      LDA #0
      JSR $EF9C

      LDA SAVMSC
      STA ASC
      LDA SAVMSC+1
      STA ASC+1

      LDA #40
      STA OFFSET
      LDX #STR&255
      LDY #STR/256
      JSR PRINT

      LDA #80
      STA OFFSET
      LDX #STR1&255
      LDY #STR1/256
      JSR PRINT
PAUSE JMP PAUSE

PRINT CLC
      LDA SAVMSC
      ADC OFFSET
      STA ASC
      STX STRP
      STY STRP+1
      LDY #0
PRN   LDA (STRP),Y
      CMP #$9B
      BEQ PRE
      SBC #31
      STA (ASC),Y
      INY
      CPY #MAXLEN
      BNE PRN
PRE   RTS
STR
  .BY "|    THIS COMPUTER CAN'T RUN WIN11     |",$9B
STR1
  .BY "|       LEARN 6502 ASSEMBLER           |",$9B
