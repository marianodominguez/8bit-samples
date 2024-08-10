        ORG $2000
        LDX #0
        LDA #0
        STA $FF
loop    LDA $FF
        STA $0400,X
        INC $FF
        LEAX 1,X
        CMPA #$FF
        BNE loop
        RTS

