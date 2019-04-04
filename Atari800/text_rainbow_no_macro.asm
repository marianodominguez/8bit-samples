; WUDSN IDE Atari Rainbow Example, add labels
;SDMCTL = $022F ;Disable screen DMA 
;VCOUNT = $D40B
;WSYNC  = $D40A
;COLOR1 = $D017
;COLOR2 = $D018
;COLOR3 = $D019
;COLOR4 = $D01A
;RTCLOK = $14
	
;SAVMSC 	=	$58
MAXLEN 	=	100

;text offset  		
offset = $D0

    org $4000 ;Start of code 
	icl "SystemEquates.asm"
	icl "graph_macros.asm"
	
start ; reset gr. 2
		LDA #2			;mode
		PHA
		LDX #$60		;screen
		LDA #$C			; CLOSE
		STA ICCOM,X
		JSR CIOV 		;do close
		LDX #$60
		LDA #3 			;open
		STA ICCOM,X
		LDA #string&255
		STA ICBAL,X
		LDA #string/256
		STA ICBAH,X
		PLA
		STA ICAX2,X
		AND #$F0
		EOR #$10
		ORA #$C
		STA ICAX1,X
		JSR CIOV
	  	print string, #10, #10
pause 	jmp pause
			
string 	.byte $0,$40,"  Hello 6502 World !  ",$40,$FF
 		.byte "please terminate your strings with $FF",$FF
 		 run start ;Define run address