
; ******************************
; CIO equates
ICHID EQU    $0340
ICDNO EQU    $0341
ICCOM EQU    $0342
ICSTA EQU    $0343
ICBAL EQU    $0344
ICBAH EQU    $0345
ICPTL EQU    $0346
ICPTH EQU    $0347
ICBLL EQU    $0348
ICBLH EQU    $0349
ICAX1 EQU    $034A
ICAX2 EQU    $034B
CIOV  EQU    $E456
GRACTL EQU	   53277

; sys equates
RAMTOP EQU  106
PMBASE EQU  54279
PCOLR0 EQU  704
SAVMSC EQU  $58
CHARSET1 EQU $E000
CHBAS  EQU  $2F4
KEYPRES EQU $2FC
; other var

COLWN EQU 710
COLBK EQU 711
NSTEP EQU 9

XLOC   EQU   $CC
YLOC   EQU   $CE
YLOC1  EQU   $C1
YLOC2  EQU   $C3
CHSET  EQU   $C5 		;C5 HI
CTPOS1 EQU $C7		; cactus position
CTPOS2 EQU $C9

INITX  EQU   $D0       ; Initial X value
INITY  EQU   $D1       ; Initial Y value
TMPTOP EQU   $100      ; Temporary storage (ADRESS)
STICK  EQU   $D300     ; PORTA - Hardware STICK(0) location
HPOSP0 EQU   $D000     ; Horizontal position Player 0
PSIZE  EQU   $C0		; Size of player in bytes
TMP1    EQU   $D2      ; Temporary storage
POFF   EQU   $D4      ; Offset of player in memory

TMP2   EQU   $D6      ; Temporary storage
STRADR EQU   $D8      ; Address of string to print
MAXLEN EQU   $DA       ; Maximum length of string
JMPPOS EQU   $DB		; jump position
JMPIDX EQU   $DC		; jump index
JMPNG  EQU   $DD		; is the dino jumping?

rtclok	= $12
vcount	= $d40b

	org $2400
	.proc music
STEREOMODE	equ 0				;0 => compile RMTplayer for mono 4 tracks
init_song = RASTERMUSICTRACKER+0
play	  = RASTERMUSICTRACKER+3

	icl "music/music.feat"

player
	icl "music/rmt_player.asm"			;include RMT player routine
	icl 'music/rmt_relocator.asm'			;include RMT relocator
module
	rmt_relocator 'music/bassandnoise.rmt' module	;include music RMT module
	.endp

		.proc start	
		
		JSR init_ram
		JSR init_gra
		JSR pm_init
		JSR load_players
	;
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

		ldx #<music.module
		ldy #>music.module
		lda #0
		;jsr music.init_song

; **************************************
; Main loop
; **************************************

MAIN    jsr wait
		LDA #$34
		STA $d01a
		;jsr music.play
		LDA #$00
		STA $d01a

		LDX #5        
		LDY #0        
		JSR READKEY
		JSR DisplayCactus
		; DEC CTPOS1
		LDA CTPOS1
		CMP #0
		BNE MAIN
		LDA #19
		STA CTPOS1
		JMP MAIN      
	.endp
; **************************************
; Subroutines
; **************************************

		.proc load_players
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
		.endp

		; *** Initial RAM setup ****
		.proc init_ram	
		LDA RAMTOP
		STA TMPTOP
		SEC
		SBC #4			;reserve 4 pages for charset

		STA CHSET  	;
		SEC
		SBC #8			;reserve 8 pages for PM
		STA PMBASE
		STA RAMTOP		;new ramtop
		STA XLOC+1  	;erase PM ram
		LDA #0
		STA XLOC

		LDA #0
		STA JMPPOS
		STA JMPIDX
		STA JMPNG
		LDA #10
		STA CTPOS1
		LDA #19
		STA CTPOS2
		RTS
		.endp		
		
		.proc init_gra
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
		.endp
		
		.proc pm_init
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
		.endp

		.proc copy_player
		; Pull return address from stack and save it
		PLA
		STA TMP2		; Save return address low byte
		PLA
		STA TMP2+1		; Save return address high byte
		; Now pull the player address parameters
		PLA
		STA TMP1			; Player address low byte
		PLA
		STA TMP1+1		; Player address high byte
		; Push return address back onto stack
		LDA TMP2+1
		PHA
		LDA TMP2
		PHA
		; Continue with copy operation

		LDY #0
insert
		LDA (TMP1),Y
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
		.endp

		.proc READKEY
; read key
		LDA JMPNG
		CMP #1
		BEQ jp
		LDA KEYPRES
		CMP #33
		BNE retk
		LDA #1
		STA JMPNG
		DEC CTPOS1
jp		JSR jump
		
		LDA #255
		STA KEYPRES
retk	RTS			
		.endp

		.proc jump
		LDY JMPIDX
		LDA jumpseq,Y
		CMP JMPPOS
		BEQ jstep_done
		BCS jmove_up        ; A > JMPPOS -> move up
		JSR DOWN            ; A < JMPPOS -> move down
		DEC JMPPOS
		RTS
		.endp
		
jmove_up
		JSR UP
		INC JMPPOS
		RTS
jstep_done
		INC JMPIDX
		LDA #NSTEP
		CMP JMPIDX
		BNE jxit
		LDA #0
		STA JMPIDX
		LDA #0
		STA JMPNG
jxit	RTS

 ; ******************************
 ; Now move player appropriately,
 ; starting with upward movement.
 ; ******************************
UP		LDY JMPIDX        ; Setup for moving byte 1
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
		STA TMP1
		CPY TMP1    ; Are we done?
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

		BPL DOWN1    ; If Y >EQU 0 keep going
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
		STA TMP1
		LDA SAVMSC+1
		ADC #0
		STA TMP1+1
		LDY #0
loop	LDA (STRADR),Y
		CMP #$9B
		BEQ DONE
		STA (TMP1),Y
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
		STA TMP1
		LDA CHSET
		STA TMP1+1     ; copy the charset address

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
		STA (TMP1),Y
		INY
		CPY #0
		BNE loop_load
		INC TMP1+1
		INC TMP2+1
		INX
		CPX #4
		BNE lp_page
		LDY #0
		; load cactus characters in an offset of 8 characters
		LDA #13*8
		STA TMP1
		LDA CHSET
		STA TMP1+1

loopc	LDA cactus1,y
		STA (TMP1),y
		INY
		CPY #16
		BNE loopc
		LDY #16
loopc2	LDA cactus2,y
		STA (TMP1),y
		INY
		CPY #32
		BNE loopc2
		LDY #32
loopc3	LDA cactus3,y
		STA (TMP1),y
		INY
		CPY #48
		BNE loopc3
				
		LDA CHSET ;switch charset
		STA CHBAS
		LDA #0
		STA TMP1
		STA TMP2
		RTS

; Display Cactus
DisplayCactus
		; Clear the previous cactus
		LDA #clr&255
		STA STRADR
		LDA #clr/256
		STA STRADR+1
		LDA #1
		STA MAXLEN
		CLC
		LDA #100
		ADC CTPOS1
		ADC #1
		PHA
		JSR puts
		LDA #119
		ADC CTPOS1
		ADC #1
		PHA
		JSR puts
		
		; print 1 char of cactus per column
		LDA #c1&255
		STA STRADR
		LDA #c1/256
		STA STRADR+1
		LDA #1
		STA MAXLEN
		CLC
		LDA #100
		ADC CTPOS1 ; top row offset
		PHA
		JSR puts
		INC STRADR
		LDA #119
		ADC CTPOS1 ; top row offset
		PHA 
		JSR puts
		RTS

	.proc wait
loopw	lda vcount
	cmp #$20
	bne loopw
	rts
	.endp

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
c1 		.BYTE "-"+130,"-"+131,$9B
c2 		.BYTE "-"+128,"-"+129,$9B
c3 		.BYTE "-"+132,"-"+133,$9B
clr 	.BYTE " ",$9B

blanks	.BYTE "                    ",$9B

jumpseq	.BYTE 4,8,16,24,24,16,8,4,0
NAME    .BYTE c"S:",$9B
tabpp  .BYTE 156,78,52,39			;line counter spacing table for instrument speed from 1 to 4

	 	run start 	;Define run address

