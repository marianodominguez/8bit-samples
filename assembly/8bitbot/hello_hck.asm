    org $4000
CM=$0342
BAL=$0344
BAH=$0345
AX1=$034A
AX2=$034B
CV=$E456

    LDA #2
    JSR  $EF9C
L   LDA M,Y
    CMP #$9B
    BEQ C
    STA ($58),Y
    INY
    JMP L
C   LDA $D40B
    CLC
    ADC $14
    STA $D40A 
    STA $D017
    JMP C
M   .BYTE 0,40,"ello",0,22,21,16,18,0,"world",1,$9B