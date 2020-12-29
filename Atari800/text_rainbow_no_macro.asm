	opt s+

SDMCTL = $022F ;Disable screen DMA
COLOR1 = $D017
COLOR2 = $D018
COLOR3 = $D019
COLOR4 = $D01A
RTCLOK = $14

MAXLEN	  = 100

    org $4000 ;Start of code
	icl "hardware.asm"

start ; reset gr. 2
		LDA #2			;mode
		JSR gr
	  	
		; print message
	
loop	LDA string,Y
		CMP #$9B
		beq pexit
		sta (SAVMSC),Y
		iny
		cpy #MAXLEN
		bne loop
pexit	nop
	  
cloop	 LDA VCOUNT ;Load VCOUNT 
      	CLC 
      	ADC RTCLOK ;Add counter 
      	STA WSYNC 
      	STA COLOR1 ;Change FG color 
      	JMP cloop

gr		PHA
		LDX #$60		;screen
		LDA #$C			; CLOSE
		STA ICCOM,X
		JSR CIOV 		;do close
		LDX #$60
		LDA #3 			;open
		STA ICCOM,X     ; in command byte
		LDA #screen&255 ; name is :s
		STA ICBAL,X
		LDA #screen/256
		STA ICBAH,X
		PLA				;gr mode
		STA ICAX2,X
		AND #$F0		;high 4 bytes
		EOR #$10		;Flip high bit
		ORA #$C
		STA ICAX1,X     ;n+16, etc
		JSR CIOV
		RTS

screen  .byte $53,$3A,$9B
string 	.byte $0,$40,"Hello 6502 World !",$40,$9B
 		.byte "please terminate your strings with $9B",$9B
 		 run start ;Define run address
