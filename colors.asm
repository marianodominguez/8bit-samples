# example for 6502 JS simulator

define SCREEN $0200
define PTRL $A0 #unused page 0
define PTRH $A1
CLC
LDA #$02
STA PTRH
LDX #$00
LDA #$00
STA PTRL

loop:
LDA PTRL
TAY
TXA
STA PTRL
TYA
INX
ADC #$01
LDY #0
STA (PTRL),Y
LDA PTRH
BCC nocarry
ADC #$01
STA PTRH
CLC
nocarry:
CMP #$05 
BMI loop
