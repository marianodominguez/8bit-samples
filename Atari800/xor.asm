  org $4000
  LDA #9 ; gr mode
  JSR $EF9C ;graphics mode
  
  LDX #0
  LDA #0
  STA 0
  STA 2
  LDY #14 ;pixel lum
  
L LDA 2 
  STA 84 ;row
  LDA 0 
  STA 85 ;col low

  STY 763 ; color reg
  JSR X
C JSR $F1D8 ; call OS PLOT
  JMP L

X INX
  STX 0
  CPX #50
  BNE E
Y LDX #0
  STX 0
  LDA 2
  ADC #1
  STA 2
  INY
  CPY #14
  BNE E
  LDY #0
E RTS
;.END
