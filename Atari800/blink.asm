;CHARACTER BLINK ROUTINE
CHACT   EQU     $2F3
CDTMV2  EQU     $21A
CDTMA2  EQU     $228
        ORG     $0680
        LDA     $1E
        STA     PERIOD
        LDA     $01
        STA     MASK
        LDA     $01
        STA     FLIP
;STORE VECTOR TO BLINK ROUTINE
        LDA     #BLINK&$00FF
        STA     CDTMA2
        LDA     #HIGH BLINK
        STA     CDTMA2+1
        LDA     PERIOD
        STA     CDTMV2
        RTS
PERIOD  ORG     ORG+1
MASK    ORG     ORG+1
FLIP    ORG     ORG+1
;BLINK ROUTINE
BLINK   LDA     CHACT
        AND     MASK
        EOR     FLIP
        STA     CHACT
;RESET TIMER AND RETURN
        LDA     PERIOD
        STA     CDTMV2
        RTS

