
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
RAMTOP =  106
PMBASE =  54279
PCOLR0 =  704
SAVMSC =  $58
CHARSET1= $E000
CHBAS  =  $2F4
KEYPRES = $2FC
; other var

COLWN = 710
COLBK = 711

XLOC   =   $CC
YLOC   =   $CE
YLOC1  =   $C1
YLOC2  =   $C3
CHSET  =   $C5 		;C5 HI

INITX  =   $D0       ; Initial X value
INITY  =   $D1       ; Initial Y value
TMPTOP =   $100      ; Temporary storage (ADRESS)
STICK  =   $D300     ; PORTA - Hardware STICK(0) location
HPOSP0 =   $D000     ; Horizontal position Player 0
PSIZE  =   $C0		; Size of player in bytes
TMP    =   $D2      ; Temporary storage
POFF   =   $D4      ; Offset of player in memory
TMP2   =   $D6      ; Temporary storage
STRADR =   $D8      ; Address of string to print
MAXLEN =   $DA       ; Maximum length of string

		ORG $0600
; lower ramtop
start	JSR init_ram
		JSR init_gra
		JSR pm_init
		JSR load_players

		; print fence 
		LDA #fence&255
		STA STRADR
		LDA #fence/256
		STA STRADR+1
		LDA #18
		STA MAXLEN
		LDA #62 ; top row offset
		PHA
		JSR puts
		LDA #18   
		STA MAXLEN
		LDA #140 ;fence bottom row offset
		PHA
		JSR puts
		JSR load_chset

; **************************************
; Main loop
; **************************************

MAIN    
		
		LDX #5        ; To control the
		LDY #0        ; player, we
		JSR READKEY
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
		
		; Push player0 address onto stack (high byte first)
		LDA #player0/256
		PHA
		LDA #player0&255
		PHA
		LDA YLOC
		STA POFF
		LDA YLOC+1
		STA POFF+1
		JSR copy_player

		; Push player1 address onto stack (high byte first)
		LDA #player1/256
		PHA
		LDA #player1&255
		PHA
		LDA YLOC1
		STA POFF
		LDA YLOC1+1
		STA POFF+1
		JSR copy_player
		
		; Push player2 address onto stack (high byte first)
		LDA #player2/256
		PHA
		LDA #player2&255
		PHA
		LDA YLOC2
		STA POFF
		LDA YLOC2+1
		ADC #0
		STA POFF+1
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
		LDA #60
		STA INITX
		LDA #50
		STA INITY
		LDA #46
		STA 559 	;SDMCTL
		LDA #1
		STA 623  ; priority 

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

		LDA	RAMTOP
		CLC
		ADC #2
		STA YLOC+1
		LDA INITY
		ADC #0
		STA YLOC
		;save locations for players
		
		LDA YLOC
		ADC #128
		STA YLOC1
		LDA YLOC+1
		ADC #0
		STA YLOC1+1

		LDA YLOC
		STA YLOC2
		LDA YLOC+1
		ADC #1
		STA YLOC2+1
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

		LDY #0
insert
		LDA (TMP),Y
		STA (POFF),Y
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

; read key
READKEY
		LDA KEYPRES
		CMP #33
		BNE retk
        JSR UP
		LDA #255
		STA KEYPRES
retk	RTS			
		
 ; ******************************
 ; Now move player appropriately,
 ; starting with upward movement.
 ; ******************************
UP		LDY #1        ; Setup for moving byte 1
		DEC YLOC      ; Now 1 less than YLOC
		DEC YLOC1
		DEC YLOC2
UP1		LDA (YLOC),Y  ; Get 1st byte
		DEY           ; To move it up one position
		STA (YLOC),Y
		INY
		LDA (YLOC1),Y  ; Get 1st byte
		DEY
		STA (YLOC1),Y  ; Move it
		INY
		LDA (YLOC2),Y  ; Get 1st byte
		DEY
		STA (YLOC2),Y  ; Move it
		INY           ; Now original value
		INY
		CLC           ; Now set for next byte
		LDA PSIZE
		ADC #2
		STA TMP
		CPY TMP    ; Are we done?
		BCC UP1       ; No
		RTS

 ; ******************************
 ; Now move player down
 ; ******************************
DOWN	LDY PSIZE   ; Move top byte first
DOWN1	LDA (YLOC),Y ; Get top byte
		INY          ; to move it down screen
		STA (YLOC),Y ; Move it
		DEY
		LDA (YLOC1),Y ; Get top byte
		INY 
		STA (YLOC1),Y ; Move it
		DEY
		LDA (YLOC2),Y ; Get top byte
		INY 
		STA (YLOC2),Y ; Move it

		DEY          ; Now back to starting value
		DEY          ; Set for next lower byte

		BPL DOWN1    ; If Y >= 0 keep going
		INY          ; Set to zero
		LDA #0       ; to clear top byte
		STA (YLOC),Y ; Clear it
		STA (YLOC1),Y
		STA (YLOC2),Y
		INC YLOC     ; Now is 1 higher
		INC YLOC1
		INC YLOC2
		RTS

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
; ******************************
; Load custom character set
; ******************************
load_chset
		LDA #0
		STA TMP
		LDA RAMTOP  ;First 8 pages are for PM
		SBC #12		;reserve 4 pages more for chars
		STA CHSET
		STA TMP+1     ; copy the charset address

		CLC
		LDA #CHARSET1&255
		STA TMP2
		LDA #CHARSET1/256
		STA TMP2+1
		LDY #0
		LDX #0
lp_page
		LDY #0
loop_load
		LDA (TMP2),Y   ;tmp2 is the address of the charset
		STA (TMP),Y
		INY
		CPY #0
		BNE loop_load
		INC TMP+1
		INC TMP2+1
		INX
		CPX #4
		BNE lp_page
		LDY #0
		; load cactus characters in an offset of 8 characters
		LDA #13*8
		STA TMP
		LDA CHSET
		STA TMP+1


loopc	LDA cactus1,y
		STA (TMP),y
		INY
		CPY #16
		BNE loopc
		LDY #16
loopc2	LDA cactus2,y
		STA (TMP),y
		INY
		CPY #32
		BNE loopc2
		LDY #32
loopc3	LDA cactus3,y
		STA (TMP),y
		INY
		CPY #48
		BNE loopc3
				
		LDA CHSET ;switch charset
		STA CHBAS
		LDA #0
		STA TMP
		STA TMP2
		RTS

player0 .BYTE 0,0,0,0,0,0,0,0
		.BYTE 0,0,128,128,192,231,255,255
		.BYTE 127,63,31,15,7,6,4,6
player1 .BYTE 0,0,0,7,15,27,31,31
		.BYTE 31,28,63,124,252,255,253,252
		.BYTE 248,248,240,224,96,32,32,48
player2 .BYTE 0,0,0,224,240,240,240,240
		.BYTE 240,0,224,0,0,0,0,0
		.BYTE 0,0,0,0,0,0,0,0

cactus1 .BYTE 0,0,0,48,48,50,50,178,190,176,240,48,48,48,48,48
cactus2 .BYTE 0,0,0,24,26,26,26,94,88,88,88,120,24,24,24,24
cactus3 .BYTE 0,0,26,26,90,90,90,94,88,120,24,24,24,24,24,24

fence 	.BYTE "--------------------",$9B
blanks	.BYTE "                    ",$9B
NAME    .BY "S:",$9B
	 	run start 	;Define run address

