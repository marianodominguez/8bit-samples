  org $4000
  LDA #9    ;gr mode
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
  
  LDA $F1
  LDX #2
  SEC
d INX
  SBC #2
  BCS d
  STX $f2
  
  LDA $F0 ; color = x xor y/2
  EOR $F2
  JSR M
  TAY
  
N STY 763   ;color reg
C JSR $F1D8 ;call OS PLOT
  JSR X
  JMP L

X LDX $F0
  INX
  STX $F0
  CPX #80
  BNE E
Y LDY #0
  STY $F0
  LDY $F1
  INY
  STY $F1
  CPY #192
  BNE E
  LDY #0
  STY $F1
E RTS

M SEC
i SBC #14
  BCS i
  ADC #14
  RTS
  
;.END
