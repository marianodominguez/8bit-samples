0100     .OPT NO LIST
0110 NOSHIFT = $6F
0120 ADDLO = $A500
0130 ADDHI = $A600
0140 NEWCOL = $6C
0150 STORE = $64
0160 COLOUR = 200
0170 MASK =  $6E
0180 UNDER = $6D
0190 XPOS =  $55
0200 YPOS =  $54
0210 PLOTMODE = $0600
0220 TEXTUREF = $0601
0230 TEXTDEF = $0604
0240 TEXTIND = MASK
0250 OLDDATA = $71
0260 ;
0270 ; PLOT + TEXTURES, VER. 3.1
0280 ;
0290     *=  $A400
0300     LDA COLOUR
0310     PHA 
0320     LDA XPOS
0330     CMP #160
0340     BCS RETURN
0350     TAY 
0360     AND #3
0370     STA NOSHIFT
0380     AND #1
0390     STA TEXTIND
0400     LDA #3
0410     SEC 
0420     SBC NOSHIFT
0430     STA NOSHIFT
0440     TYA 
0450     LDY YPOS
0460     CPY #192
0470     BCS RETURN
0480     LSR A
0490     LSR A
0500     CLC 
0510     ADC ADDLO,Y
0520     STA $64
0530     LDA #0
0540     ADC ADDHI,Y
0550     STA $64+1
0560     TYA 
0570     AND #1
0580     ASL A
0590     CLC 
0600     ADC TEXTIND
0610     TAX 
0620     LDA TEXTUREF
0630     BEQ NOTEXTURE
0640     LDA TEXTDEF,X
0650     STA COLOUR
0660 NOTEXTURE
0670     LDA COLOUR
0680     AND #3
0690     STA COLOUR
0700     LDX NOSHIFT
0710     LDY MASKTAB,X
0720     STY MASK
0730     INX 
0740     DEX 
0750     BEQ OK
0760 SHIFT = *
0770     ASL A
0780     ASL A
0790     DEX 
0800     BNE SHIFT
0810 OK
0820     STA NEWCOL
0830     LDY #0
0840     LDA ($64),Y
0850     STA OLDDATA
0860     LDA PLOTMODE
0870     AND #3
0880     BEQ PLOTOVER
0890     TAX 
0900     DEX 
0910     BEQ PLOTEOR
0920     DEX 
0930     BEQ PLOTAND
0940 ; LOCATE
0945     PLA 
0946     STA COLOUR
0950     LDA OLDDATA
0960     LDX NOSHIFT
0970     BEQ OK2
0980 SHIFT2 = *
0990     LSR A
1000     LSR A
1010     DEX 
1020     BNE SHIFT2
1030 OK2 =   *
1040     AND #3
1050     STA UNDER
1055     RTS 
1060 RETURN
1070     CLC 
1080     BCC RET2
1090 PLOTOVER = *
1100     LDA OLDDATA
1110     AND MASK
1120     ORA NEWCOL
1130 STORECOL = *
1140     LDY #0
1150     STA ($64),Y
1160 RET2
1170     PLA 
1180     RTS 
1190 PLOTEOR = *
1200     LDA OLDDATA
1210     EOR NEWCOL
1220     CLC 
1230     BCC STORECOL
1240 PLOTAND = *
1250     LDA MASK
1260     ORA NEWCOL
1270     AND OLDDATA
1280     CLC 
1290     BCC STORECOL
1300 MASKTAB
1310     .BYTE $FC,$F3,$CF,$3F
1320     *=  $A4D0
1330 INITADDTAB
1340     LDA $58
1350     STA $64
1360     LDA $59
1370     STA $64+1
1380     LDY #0
1390 LOOP =  *
1400     LDA $64
1410     STA ADDLO,Y
1420     CLC 
1430     ADC #40
1440     STA $64
1450     LDA $64+1
1460     STA ADDHI,Y
1470     ADC #0
1480     STA $64+1
1490     INY 
1500     CPY #195
1510     BCC LOOP
1520     RTS 
