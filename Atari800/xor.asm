  org $4000
  LDA #9 ; gr mode
  JSR $EF9C ;graphics mode
  
  LDA #0
  STA $0 ;x
  STA $2 ;y
  STA $4 ;color
  
L LDA $2 
  STA 84 ;row
  LDA $0
  STA 85 ;col low
  
  ;LDA $0 ;c=x xor y
  ;EOR $1
  ;TAY
  LDA $4
  ADC #1
  CMP #14
  BNE N
  LDA #0
  STA $4

N STA 763   ;color reg
C JSR $F1D8 ;call OS PLOT
  JSR X
  JMP L

X LDA $0
  ADC #1
  STA 0
  CMP #80
  BNE E
Y LDA #0
  STA $0
  LDA $2
  ADC #1
  STA $2
  CMP #192
  BNE E
  LDA #0
  STA $2
E RTS
;.END
