;{A} S 
    org $3000
COLOR1=$D017
RTCLOK=$14
ICCOM=$0342
ICBAL=$0344
ICBAH=$0345
ICAX1=$034A
ICAX2=$034B
CIOV=$E456
WSYNC=$D40A

    LDA #2
    JSR G
L   LDA M,Y
    CMP #$9B
    BEQ C
    STA ($58),Y
    INY
    JMP L
      
C   LDA $D40B
    CLC 
    ADC RTCLOK
    STA WSYNC 
    STA COLOR1
    JMP C

G   PHA
    LDX #$60
    LDA #$C
    STA ICCOM,X
    JSR CIOV
    LDX #$60
    LDA #3
    STA ICCOM,X
    LDA #SC&255
    STA ICBAL,X
    LDA #SC/256
    STA ICBAH,X
    PLA
    STA ICAX2,X
    AND #$F0
    EOR #$10
    ORA #$C
    STA ICAX1,X
    JSR CIOV
    RTS

SC  .BYTE $53,$3A,$9B
M 	.BYTE $0,$40,"Hello 6502 World !",$40,$9B
