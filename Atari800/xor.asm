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
  INY
  STY $F2
  CPY #14
  BNE N
  LDY #0
  STY $F2

N STY 763   ;color reg
C JSR $F1D8 ;call OS PLOT
  JSR X
  JMP L

X LDA $F0
  CLC
  ADC #1
  STA $F0
  CMP #80
  BNE E
Y LDA #0
  CLC
  STA $F0
  LDA $F1
  ADC #1
  STA $F1
  CMP #192
  BNE E
  LDA #0
  STA $F1
E RTS
;.END
