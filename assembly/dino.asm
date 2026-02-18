
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
SAVMSC   =  $58

; other var

XLOC   =   $CE
YLOC   =   $CC
YLOC1  =   $C1
YLOC2  =   $C3

INITX  =   $D0       ; Initial X value
INITY  =   $D1       ; Initial Y value
TMPTOP =   $100      ; Temporary storage (ADRESS)
STICK  =   $d300     ; PORTA - Hardware STICK(0) location
HPOSP0 =   $D000     ; Horizontal position Player 0
PSIZE  =   $C0		; Size of player in bytes
TMP    =   $D2      ; Temporary storage
POFF   =   $D4      ; Offset of player in memory
TMP2   =   $D6      ; Temporary storage
STRADR =   $D8      ; Address of string to print
MAXLEN =   $C5       ; Maximum length of string

		ORG $0600
; lower ramtop
start	JSR init_ram
		JSR init_gra
		JSR pm_init
		JSR load_players
		LDA #fence&255
		STA STRADR
		LDA #fence/256
		STA STRADR+1
		LDA #18
		STA MAXLEN
		LDA #62 ; row offset
		PHA
		JSR puts
		LDA #20
		STA MAXLEN
		LDA #160
		PHA
		JSR puts

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
		LDA #24
		STA PSIZE
		LDA #0
		STA POFF
		STA POFF+1
		; Push player0 address onto stack (high byte first)
		LDA #player0/256
		PHA
		LDA #player0&255
		PHA
		JSR copy_player
		LDA #128
		STA POFF
		; Push player1 address onto stack (high byte first)
		LDA #player1/256
		PHA
		LDA #player1&255
		PHA
		JSR copy_player
		LDA #0
		STA POFF
		LDA #1
		STA POFF+1
		; Push player2 address onto stack (high byte first)
		LDA #player2/256
		PHA
		LDA #player2&255
		PHA
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
       LDA #2
       PHA           ; Store on stack
       LDX #$60      ; IOCB6 for screen
       LDA #$C       ; CLOSE command
       STA ICCOM,X   ; in command byte
       JSR CIOV      ; Do the CLOSE
       LDX #$60      ; The screen again
       LDA #3        ; OPEN command
       STA ICCOM,X   ; in command byte
       LDA #NAME&255 ; Name is "S:"
       STA ICBAL,X   ; Low byte
       LDA #NAME/256 ; High byte
       STA ICBAH,X
       PLA           ; Get GRAPHICS n
       STA ICAX2,X   ; Graphics mode
       AND #$F0      ; Get high 4 bits
       EOR #$10      ; Flip high bit
       ORA #$C       ; Read or write
       STA ICAX1,X   ; n+16, n+32 etc.
       JSR CIOV      ; Setup GRAPHICS n
       RTS           ; All done
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
		; Pull return address from stack and save it
		PLA
		STA TMP2		; Save return address low byte
		PLA
		STA TMP2+1		; Save return address high byte
		; Now pull the player address parameters
		PLA
		STA TMP			; Player address low byte
		PLA
		STA TMP+1		; Player address high byte
		; Push return address back onto stack
		LDA TMP2+1
		PHA
		LDA TMP2
		PHA
		; Continue with copy operation
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
		
; *** PRINT a String ***
puts 	
		; Pull return address
		PLA
		STA TMP2
		PLA
		STA TMP2+1
		CLC
		PLA				; Row offset
		ADC SAVMSC
		STA TMP
		LDA SAVMSC+1
		ADC #0
		STA TMP+1
		LDY #0
loop	LDA (STRADR),Y
		CMP #$9B
		BEQ DONE
		STA (TMP),Y
		INY
		CPY MAXLEN
		BNE loop
		LDA TMP2+1 ; Restore return address
		PHA
		LDA TMP2
		PHA
DONE	RTS


player0 .BYTE 0,0,0,0,0,0,0,0
		.BYTE 0,0,128,128,192,231,255,255
		.BYTE 127,63,31,15,7,6,4,6
player1 .BYTE 0,0,0,7,15,27,31,31
		.BYTE 31,28,63,124,252,255,253,252
		.BYTE 248,248,240,224,96,32,32,48
player2 .BYTE 0,0,0,224,240,240,240,240
		.BYTE 240,0,224,0,0,0,0,0
		.BYTE 0,0,0,0,0,0,0,0
fence 	.BYTE "--------------------",$9B
blanks	.BYTE "                    ",$9B
NAME    .BY "S:",$9B
	 	run start 	;Define run address

