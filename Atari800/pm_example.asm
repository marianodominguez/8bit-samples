
; ******************************
; CIO equates
ICHID =    $0340
ICDNO =    $0341
ICCOM =    $0342
ICSTA =    $0343
ICBAL =    $0344
ICBAH =    $0345
ICPTL =    $0346
ICPTH =    $0347
ICBLL =    $0348
ICBLH =    $0349
ICAX1 =    $034A
ICAX2 =    $034B
CIOV  =    $E456
GRACTL=		53277

; sys equates
RAMTOP =	106
PMBASE =	54279
PCOLR0 =	704

; other var
TMPTOP =   $100
XLOC   =   $CE
YLOC   =   $CC
INITX  =   $D0       ; Initial X value
INITY  =   $D1       ; Initial Y value
STOTOP =   $100      ; Temporary storage (ADRESS)
STICK  =   $D300     ; PORTA - Hardware STICK(0) location
HPOSP0 =   $D000     ; Horizontal position Player 0

		ORG $600
; lower ramtop
start	LDA RAMTOP
		STA TMPTOP
		SEC
		SBC #8		;reserve 8 pages
		STA RAMTOP	;new ramtop
		STA PMBASE  ;
		STA XLOC+1  ;erase PM ram
		LDA #0
		STA XLOC
		
; reset gr. 0
		LDA #0
		PHA
		LDX #$60 	;screen
		LDA #$C 	; CLOSE
		STA ICCOM,X
		JSR CIOV 	;do close
		LDX #$60
		LDA #3 		;open
		STA ICCOM,X
		LDA #name&255
		STA ICBAL,X
		LDA #name/256
		STA ICBAH,X
		PLA
		STA ICAX2,X
		AND #$F0
		EOR #$10
		ORA #$C
		STA ICAX1,X
		JSR CIOV
; PM graphics setup
		LDA #120
		STA INITX
		LDA #50
		STA INITY
		LDA #46
		STA 559 ; SDMCTL
;pm area clear
		LDY	#0
clear
		LDA #0
		STA (XLOC),Y
		DEY
		BNE clear	;loop for clear page
		INC XLOC+1  ; next page
		LDA XLOC+1
		CMP TMPTOP
		BEQ clear ; one extra page
		BCC clear		
; copy player data
		LDA	RAMTOP
		CLC
		ADC #2
		STA YLOC+1
		LDA INITY
		STA YLOC
		LDY #0
insert
		LDA player,Y
		STA (YLOC),Y
		INY
		CPY #8	;player Size
		BNE insert
		LDA INITX
		STA HPOSP0
		STA XLOC
		LDA #68  ;color red
		STA PCOLR0
		LDA #3	;enable player
		STA GRACTL ; resolution
MAIN
		JSR RDSTK     ; Read stick - move player
		LDX #5        ; To control the
		LDY #0        ; player, we
DELAY
		DEY           ; have to add
		BNE DELAY     ; a delay - this
		DEX           ; routine slows
		BNE DELAY     ; things down.
		JMP MAIN      ; And do it again
RDSTK
		LDA STICK
		RTS
		
player .BYTE 255,129,129,129,129,129,129,255
name   .BYTE "S:",$9B
	 	run start 	;Define run address
	
	