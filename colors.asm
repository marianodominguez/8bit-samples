;Example for 6502.js

define SCREEN $0200
define PTRL $A0 #unused page 0
define PTRH $A1
CLC
LDA #$02
STA PTRH
LDY #$00
LDX #$00 ;counter for color
LDA #$00 
STA PTRL

loop:
LDA PTRL
TAY ; store current position
TXA 
STA PTRL
TYA
LDY #0
INX
STA (PTRL),Y
ADC #$01
LDA PTRH
BCC nocarry
CLC
ADC #$01
STA PTRH
nocarry:
CMP #$06
BMI loop
BRK
