  org $2000
  LDA #9 ; gr mode
  JSR $EF9C ;graphics mode
  
  LDX #0
  LDA #0
  STA $0
  STA $2
  LDY #14 ;pixel lum
  
L LDA $2 
  STA 84 ;row
  LDA $0 
  STA 85 ;col low

  STY 763 ; color reg
C JSR $F1D8 ; call OS PLOT
  JSR X
  JMP L

X INX
  STX $0
E RTS
;.END
