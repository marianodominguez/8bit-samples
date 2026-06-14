SDMCTL = $022F ;Disable screen DMA 
VCOUNT = $D40B
WSYNC  = $D40A
COLOR4 = $D01A
COLOR2 = $D018
RTCLOK = $14
COLVAL = $C0

    ORG $0600
    PHA
    TXA
    PHA
    LDX #0
    LDA VCOUNT
    CMP #10
    BEQ done
    CLC
    LDA COLVAL
loop 
    ADC #19
    STA COLVAL
    INX
    CPX VCOUNT
    BNE loop
    LDA VCOUNT
    STA WSYNC
    LDA COLVAL
    STA COLOR2
done
    PLA
    TAX    
    PLA
    RTI