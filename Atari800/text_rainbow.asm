; WUDSN IDE Atari Rainbow Example, add labels
SDMCTL = $022F ;Disable screen DMA 
VCOUNT = $D40B
WSYNC  = $D40A
COLOR1 = $D017
COLOR2 = $D018
COLOR3 = $D019
COLOR4 = $D01A
RTCLOK = $14
SAVMSC 	=	$58
MAXLEN 	=	100

;text offset  		
offset = $D0

      ORG $4000 ;Start of code 

start JSR print
	  ;LDA #0 ;Disable screen DMA 
      ;STA SDMCTL

loop  LDA VCOUNT ;Load VCOUNT 
      CLC 
      ADC RTCLOK ;Add counter 
      STA WSYNC 
      STA COLOR4 ;Change FG color 
      JMP loop 
  		
print 	
		lda SAVMSC
		adc #7
		sta OFFSET
		lda SAVMSC+1
		sta OFFSET+1
		 		
		ldy #0
  		lda #0
ploop	lda string,Y
		cmp #$FF
		beq exit
		sta (OFFSET),Y
		iny
		cpy MAXLEN
		bne ploop
exit	rts

string 	.byte $0,$40,"  Hello 6502 World !  ",$40,$FF
 		.byte "please terminate your strings with $FF",$FF
 		 run start ;Define run address