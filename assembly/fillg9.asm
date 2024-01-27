  org $4000
  LDA #9 ; gr mode
  JSR $EF9C ;graphics mode
  
  LDA #0
  LDY #0
  STA $F0 ;x
  STA $F1 ;y
  STA $F2 ;color
  
L LDA $F1 
  STA 84 ;row
  LDA $F0
  STA 85 ;col low
  
  LDY $F2
  CPY #14
  BPL dcr
  INY
  JMP N
dcr
  CPY #0
  BEQ N
  DEY
  
N STY $F2
  STY 763   ;color reg
C JSR $F1D8 ;call OS PLOT
  JSR X
  JMP L

X LDX $F0
  INX
  STX $F0
  CPX #80
  BNE E
Y LDX #0
  STX $F0
  LDX $F1
  INX
  STX $F1
  CPX #192
  BNE E
  LDX #0
  STX $F1
E RTS
;.END
