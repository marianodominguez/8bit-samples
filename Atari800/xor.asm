;LDA #9
;JSR $EF9C ;graphics mode
LDA $40
STA $026F ; gr. 9
LDX 0
L LDA #96
JSR X
C JSR $F1D8 ; call OS PLOT

STY 763 ; color
X ADC 0,X
STA 0,X
INX
RTS
.END
