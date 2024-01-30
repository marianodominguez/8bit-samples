        CPU 6502
        ;
        ; Line draw routines from SubLogic A2-FS1
        ; 1979, Bruce Artwick
        ; Atari 800 port, 2023, Claus Buchholz
        ;
SAVMSC: EQU 058H            ; OS bitmap address
SPZ:    EQU 064H            ; screen pointer
TMZ:    EQU 0DBH            ; temp
BPZ:    EQU 0DCH            ; bit pattern
ACZ:    EQU 0DDH            ; accumulator
XLZ:    EQU 0DEH            ; x length
YLZ:    EQU 0DFH            ; y length
        ORG 7D00H           ; 32000 decimal
X1:     DFB 0               ; start point, x, 0 to 159
Y1:     DFB 0               ; start point, y, 0 to 191
X2:     DFB 0               ; end point, x, 0 to 159
Y2:     DFB 0               ; end point, y, 0 to 191

        PLA                 ; BASIC USR(32004) entry
        JMP INICL           ; init clear routine
        PLA                 ; BASIC USR(32008) entry
        JMP CLEAR           ; clear screen
        PLA                 ; BASIC USR(32012) entry
PLOTL:  LDA X2              ; Sbr: plot line (X1,Y1) to (X2,Y2)
        SEC
        SBC X1
        BCC L1C3E
        STA XLZ             ; x length
        LDA Y2
        SEC
        SBC Y1
L1C09:  BCC L1C22
        STA YLZ             ; y length
        SEC
        SBC XLZ             ; yl-xl
        BCC L1C31           ; shallow line
        JMP L1ECC           ; steep line
L1C15:  LDA #256-40
        STA MODAD+1         ; mod row inc to -40
        LDA #255
        STA MODAD+5
        JMP L1C55           ; draw
L1C22:  EOR #255
        CLC
        ADC #1
        STA YLZ             ; y length
        SEC    
        SBC XLZ             ; yl-xl
        BCC L1C15           ; shallow line
        JMP L1E4A           ; steep line
L1C31:  LDA #40
        STA MODAD+1         ; mod row inc to +40
        LDA #0
        STA MODAD+5
        JMP L1C55           ; draw
L1C3E:  LDX X2
        STX X1
        EOR #255
        CLC
        ADC #1
        STA XLZ             ; x length
        LDA Y1
        LDX Y2
        SEC
        SBC Y2
        STX Y1
        JMP L1C09

L1C55:  LDA #0              ; draw shallow line
        SEC
        SBC XLZ
        SEC
        ROR A  
        STA ACZ             ; -xl/2
        JSR SCRNP           ; set up screen ptr
        LDX XLZ
        INX                 ; xl+1
        AND #07FH           ; 7-bit pattern
        CMP #018H
        BMI L1C88           ; <18
        CMP #040H
        BEQ L1C7E
L1C79:  JSR L1CB3           ; =30  path2
        BNE L1C9B
L1C7E:  JSR L1CA0           ; =40  path1
        BNE L1C9B
L1C88:  CMP #006H
        BMI L1C93           ; <06
        JSR L1D09           ; >06 =0C  path3
        BNE L1C9B
L1C93:  JSR L1DDB           ; =03  path4
L1C9B:  ORA (SPZ),Y
        STA (SPZ),Y
        RTS
L1CA0:  LDA ACZ             ; Path1 Sbr: pattern=C0
L1CA2:  DEX
        BEQ L1CBF           ; P1 done w 1 pixel
        CLC
        ADC YLZ
        BCS L1CC8           ; P1 next row w 1 pixel
        DEX
        BEQ L1CC2           ; P1 done w 2 pixels
        ADC YLZ
        BCS L1CD3           ; P1 next row w 2 pixels
        BNE L1CE6           ; P1 continue w 3 pixels
L1CB3:  DEX                 ; Path2 Sbr: pattern=30
        BEQ L1CC5           ; P2 done w 1 pixel
        LDA ACZ
        CLC
        ADC YLZ
        BCS L1CDB           ; P2 next row w 1 pixel
        BNE L1CFC           ; P2 continue w 2 pixels
L1CBF:  LDA #0C0H           ; P1
        RTS
L1CC2:  LDA #0F0H           ; P1
        RTS
L1CC5:  LDA #030H           ; P2
        RTS
L1CC8:  SBC XLZ
        STA ACZ
        LDA #0C0H           ; P1
        JSR L1DEC           ; P1 draw
        BCS L1CB3           ; P1>2
L1CD3:  SBC XLZ
        STA ACZ
        LDA #0F0H           ; P1
        BNE L1CE1
L1CDB:  SBC XLZ
        STA ACZ
        LDA #030H           ; P2
L1CE1:  JSR L1DEC           ; P12 draw
        BCS L1D09           ; P12>3
L1CE6:  DEX                 ; P1
        BEQ L1CF6           ; P1 done w 3 pixels
        ADC YLZ
        BCS L1D32           ; P1 next row w 3 pixels
        STA ACZ
        LDA #0FFH           ; P1
        BMI L1D17           ; P1 continue w 4 pixels
L1CF3:  LDA #03CH
        RTS
L1CF6:  LDA #0FCH           ; P1
        RTS
L1CF9:  LDA #00CH           ; P3
        RTS
L1CFC:  DEX                 ; P2
        BEQ L1CF3           ; P2 done w 2 pixels
        ADC YLZ
        BCS L1D2A           ; P2 next row w 2 pixels
        STA ACZ
        LDA #03FH           ; P2
        BPL L1D17           ; P2 continue w 3 pixels
L1D09:  DEX                 ; Path3 Sbr: pattern=0C
        BEQ L1CF9           ; P3 done w 1 pixel
        LDA ACZ
        CLC
        ADC YLZ
        BCS L1D22           ; P3 next row w 1 pixel
        STA ACZ
        LDA #00FH           ; P3 continue w 2 pixels
L1D17:  JMP L1DB0           ; P123 draw P123>4
L1D22:  SBC XLZ
        STA ACZ
        LDA #00CH           ; P3
        BNE L1D38
L1D2A:  SBC XLZ
        STA ACZ
        LDA #03CH           ; P2
        BNE L1D38
L1D32:  SBC XLZ
        STA ACZ
        LDA #0FCH           ; P1
L1D38:  JSR L1DEC           ; P123 draw
L1D3B:  LDA #003H
        CLC
        BNE L1D17
L1DB0:  ORA (SPZ),Y         ; P4 draw
        STA (SPZ),Y
        INY
        DEX
        BEQ L1DDF           ; P4 done
        LDA ACZ
        CLC
        ADC YLZ
        BCS L1DE2           ; P4 next row
        JMP L1CA2           ; P4 continue
L1DDB:  LDA #003H           ; Path4 Sbr: pattern=03
        BNE L1DB0
L1DDF:  PLA
        PLA
        RTS
L1DE2:  SBC XLZ
        STA ACZ
        JSR L1DF0           ; P4 next row
        JMP L1CA0           ; P4 continue
L1DEC:  ORA (SPZ),Y
        STA (SPZ),Y
L1DF0:  LDA SPZ
        CLC
MODAD:  ADC #40             ; mod'd above to -40
        STA SPZ
        LDA #0
        ADC SPZ+1
        STA SPZ+1           ; next row
        SEC
        RTS

L1E4A:  LDA YLZ             ; draw steep line
        CLC
        ROR A
        STA ACZ             ; half y length
        JSR SCRNP           ; set up screen ptr
        LDX YLZ
        INX
L1E58:  LDA BPZ
L1E5C:  ORA (SPZ),Y
        STA (SPZ),Y         ; draw pixel
        DEX
        BEQ L1E8D
L1E63:  LDA SPZ
        CLC
        ADC #256-40
        STA SPZ
        LDA #255
        ADC SPZ+1
        STA SPZ+1           ; 1 row up
        LDA ACZ
        SEC
        SBC XLZ
        STA ACZ
        BCS L1E58
        ADC YLZ
        STA ACZ
        CLC
        LDA BPZ
        ROR A
        ROR A
        BCC L1E84
        ROR A
        INY
L1E84:  STA BPZ             ; 1 col right
        ORA (SPZ),Y
        STA (SPZ),Y         ; draw pixel
        DEX
        BNE L1E63
L1E8D:  RTS

L1ECC:  LDA YLZ             ; draw steep line
        CLC
        ROR A
        STA ACZ             ; half y length
        JSR SCRNP           ; set up screen ptr
        LDX YLZ
        INX
L1EDA:  LDA BPZ
L1EDE:  ORA (SPZ),Y
        STA (SPZ),Y         ; draw pixel
        DEX
        BEQ L1F0F
L1EE5:  LDA SPZ
        CLC
        ADC #40
        STA SPZ
        LDA #0
        ADC SPZ+1
        STA SPZ+1           ; 1 row down
        LDA ACZ
        SEC
        SBC XLZ
        STA ACZ
        BCS L1EDA
        ADC YLZ
        STA ACZ
        CLC
        LDA BPZ
        ROR A
        ROR A
        BCC L1F06
        ROR A
        INY
L1F06:  STA BPZ             ; 1 col right
        ORA (SPZ),Y
        STA (SPZ),Y         ; draw pixel
        DEX
        BNE L1EE5
L1F0F:  RTS

SCRNP:  LDA SAVMSC          ; Sbr: build screen ptr
        STA SPZ
        LDA SAVMSC+1
        STA SPZ+1
        LDY #0
        STY TMZ+1
        LDA Y1
        ASL A
        ROL TMZ+1
        ASL A
        ROL TMZ+1
        ASL A
        ROL TMZ+1
        STA TMZ
        ADC SPZ
        STA SPZ
        LDA TMZ+1
        ADC SPZ+1
        STA SPZ+1
        LDA TMZ
        ASL A
        ROL TMZ+1
        ASL A
        ROL TMZ+1
        ADC SPZ
        STA SPZ
        LDA TMZ+1
        ADC SPZ+1
        STA SPZ+1           ; row pointer = SAVMSC + y*40
        LDA X1
        LSR A
        LSR A
        TAY                 ; offset into row
        LDA X1
        AND #3 
        TAX 
        LDA BITS,X
        STA BPZ   	        ; bit pattern for 1st pixel 
        RTS
BITS:   DFB 0C0H, 30H, 0CH, 03H  ; Tbl: bit patterns for each x coord

INICL:  LDX SAVMSC+1        ; Sbr: init clear screen
        LDY #90
ILOOP:  DEY
        TXA
        STA CLOOP,Y
        DEY
        LDA SAVMSC
        STA CLOOP,Y
        INX
        DEY
        BNE ILOOP
        RTS

CLEAR:  LDA #0             ; Sbr: clear screen
        TAY
CLOOP:  STA 33333,Y
        STA 33333,Y
        STA 33333,Y
        STA 33333,Y
        STA 33333,Y
        STA 33333,Y
        STA 33333,Y
        STA 33333,Y
        STA 33333,Y
        STA 33333,Y
        STA 33333,Y
        STA 33333,Y
        STA 33333,Y
        STA 33333,Y
        STA 33333,Y
        STA 33333,Y
        STA 33333,Y
        STA 33333,Y
        STA 33333,Y
        STA 33333,Y
        STA 33333,Y
        STA 33333,Y
        STA 33333,Y
        STA 33333,Y
        STA 33333,Y
        STA 33333,Y
        STA 33333,Y
        STA 33333,Y
        STA 33333,Y
        STA 33333,Y
        INY
        BNE CLOOP
        RTS
