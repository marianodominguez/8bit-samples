
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
GRACTL=	   53277

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
STICK  =   $d300     ; PORTA - Hardware STICK(0) location
HPOSP0 =   $D000     ; Horizontal position Player 0
PSIZE =   $C0		; Size of player in bytes
TMP    =   $D2      ; Temporary storage
POFF   =   $D4      ; Offset of player in memory

		ORG $0600
; lower ramtop
start	JSR init_ram
		JSR init_gra
		JSR pm_init
		JSR load_players

; **************************************
; Main loop
; **************************************

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

; **************************************
; Subroutines
; **************************************

load_players
		LDA #0
		STA POFF
		STA POFF+1
		LDA #player0/256
		STA TMP+1
		LDA #player0&255
		STA TMP
		LDA #24
		STA PSIZE
		JSR copy_player
		LDA #128
		STA POFF
		LDA #player1/256
		STA TMP+1
		LDA #player1&255
		STA TMP
		LDA #24
		STA PSIZE
		JSR copy_player
		LDA #0
		STA POFF
		LDA #1
		STA POFF+1
		LDA #player2/256
		STA TMP+1
		LDA #player2&255
		STA TMP
		LDA #24
		STA PSIZE
		JSR copy_player
		RTS

init_ram	
		LDA RAMTOP
		STA TMPTOP
		SEC
		SBC #8			;reserve 8 pages
		STA RAMTOP		;new ramtop
		STA PMBASE  	;
		STA XLOC+1  	;erase PM ram
		LDA #0
		STA XLOC
		RTS
		
init_gra
; reset gr. 2
		LDA #2
		PHA
		LDX #$60 		;screen
		LDA #$C 		; CLOSE
		STA ICCOM,X
		JSR CIOV 		;do close
		LDX #$60
		LDA #3 			;open
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
		RTS
pm_init
; PM graphics setup
		LDA #120
		STA INITX
		LDA #50
		STA INITY
		LDA #46
		STA 559 	;SDMCTL
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
		BEQ clear 	;one extra page
		BCC clear
		RTS

copy_player
		LDA	RAMTOP
		CLC
		ADC #2
		ADC POFF+1
		STA YLOC+1
		LDA INITY
		ADC POFF ; player offset
		STA YLOC
		LDY #0
insert
		LDA (TMP),Y
		STA (YLOC),Y
		INY
		CPY PSIZE			;player Size
		BNE insert
		LDA INITX
		STA HPOSP0
		STA XLOC
		CLC
		ADC #8
		STA HPOSP0+1
		ADC #8
		STA HPOSP0+2
		LDA #14 		;color white
		STA PCOLR0
		STA PCOLR0+1
		STA PCOLR0+2
		LDA #3			;enable player
		STA GRACTL 		; resolution
		RTS
RDSTK
		LDA STICK     ; Get joystick value
		AND #1        ; Is bit 0 = 1?
		BEQ UP        ; No - 11, 12 or 1 o'clock
		LDA STICK     ; Get it again
		AND #2        ; Is bit 1 = 1?
		BEQ DOWN      ; No - 5, 6 or 7 o'clock
SIDE	LDA STICK     ; Get it again
		AND #4        ; Is bit 3 = 1?
		BEQ LEFT      ; No - 8, 9 or 10 o'clock
		LDA STICK     ; Get it again
		AND #8        ; Is bit 4 = 1?
		BEQ RIGHT     ; No - 2, 3 or 4 o'clock
		RTS           ; Joystick straight up
		
 ; ******************************
 ; Now move player appropriately,
 ; starting with upward movement.
 ; ******************************
UP		LDY #1        ; Setup for moving byte 1
		DEC YLOC      ; Now 1 less than YLOC
UP1		LDA (YLOC),Y  ; Get 1st byte
		DEY           ; To move it up one position
		STA (YLOC),Y  ; Move it
		INY           ; Now original value
		INY
		CLC           ; Now set for next byte
		LDA PSIZE
		ADC #2
		STA TMP
		CPY TMP    ; Are we done?
		BCC UP1       ; No
		BCS SIDE      ; Forced branch!!!
 ; ******************************
 ; Now move player down
 ; ******************************
DOWN	LDY PSIZE   ; Move top byte first
DOWN1	LDA (YLOC),Y ; Get top byte
		INY          ; to move it down screen
		STA (YLOC),Y ; Move it
		DEY          ; Now back to starting value
		DEY          ; Set for next lower byte
		BPL DOWN1    ; If Y >= 0 keep going
		INY          ; Set to zero
		LDA #0       ; to clear top byte
		STA (YLOC),Y ; Clear it
		INC YLOC     ; Now is 1 higher
		CLC          ; Setup for forced branch
		BCC SIDE     ; Forced branch again
 ; ******************************
 ; Now side-to-side - left first
 ; ******************************
LEFT	DEC XLOC     ; To move it left
		LDA XLOC     ; Get it
		STA HPOSP0   ; Move it
		ADC #8   
		STA HPOSP0+1 ; Move p1
		ADC #8
		STA HPOSP0+2
		RTS          ; Back to MAIN - we're done
 ; ******************************
 ; Now right movement
 ; ******************************
RIGHT	INC XLOC     ; To move it right
		LDA XLOC     ; Get it
		STA HPOSP0   ; Move it
		ADC #8   
		STA HPOSP0+1 ; Move p1
		ADC #8
		STA HPOSP0+2
		RTS          ; Back to MAIN - we're done
		
player0 .BYTE 0,0,0,0,0,0,0,0 	
		.BYTE 0,0,128,128,192,231,255,255
		.BYTE 127,63,31,15,7,6,4,6
player1 .BYTE 0,0,0,7,15,27,31,31
		.BYTE 31,28,63,124,252,255,253,252
		.BYTE 248,248,240,224,96,32,32,48
player2 .BYTE 0,0,0,224,240,240,240,240
		.BYTE 240,0,224,0,0,0,0,0
		.BYTE 0,0,0,0,0,0,0,0
name    .BYTE "S:",$9B
	 	run start 	;Define run address
	
	