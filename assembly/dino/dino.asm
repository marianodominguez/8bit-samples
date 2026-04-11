
; ******************************
; CIO equates
ICHID 	EQU    $0340
ICDNO 	EQU    $0341
ICCOM 	EQU    $0342
ICSTA 	EQU    $0343
ICBAL 	EQU    $0344
ICBAH 	EQU    $0345
ICPTL 	EQU    $0346
ICPTH 	EQU    $0347
ICBLL 	EQU    $0348
ICBLH 	EQU    $0349
ICAX1 	EQU    $034A
ICAX2 	EQU    $034B
CIOV  	EQU    $E456
GRACTL 	EQU	   $D01D
NMIEN	EQU    $D40E
VVBLKI  EQU    $0222
VVBLKD  EQU    $0224
VDSLST  EQU    $0200

; sys equates
RAMTOP 	EQU  106
PMBASE 	EQU  54279
PCOLR0 	EQU  704

COLOR0 	EQU $02C4
COLOR1 	EQU $02C5
COLOR2 	EQU $02C6
COLOR3 	EQU $02C7
COLOR4 	EQU $02C8

COLPF0 EQU $D016
COLPF1 EQU $D017
COLPF2 EQU $D018
COLPF3 EQU $D019
COLBK  EQU $D01A
SETVBV EQU $E45C

SAVMSC 	EQU  $58
CHARSET1 	EQU $E000
CHBAS  		EQU  $2F4
KEYPRES 	EQU $2FC
CONSOL  	EQU $D01F		; Console keys (START=bit0)
PRIOR		EQU $D01B
GPRIOR		EQU $26F
STICK  	EQU   $D300     ; PORTA - Hardware STICK(0) location
HPOSP0 	EQU   $D000     ; Horizontal position Player 0

DMACTL 	EQU $D20F		; DMA control
HPOSM0 	EQU $D004     ; Horizontal position Missile 0
AUDF1   EQU $D200     ; POKEY voice 0 frequency
AUDC1   EQU $D201     ; POKEY voice 0 control (distortion/volume)
SKCTL  EQU $D20F
HITCLR  EQU $D01E     ; Clear hit flag

M0PL EQU $D008
M1PL EQU $D009
M2PL EQU $D00A
P0PL EQU $D00C
P1PL EQU $D00D
P2PL EQU $D00E
P3PL EQU $D00F
RANDOM 		EQU $D20A
WSYNC 		EQU $D40A
NMIEN_DLI 	EQU $40 
NMIEN_VBI 	EQU $80
SDLST 		EQU $0230


; other var
; *********************************************
; DO NOT USE DB to DF, reserved for RMT
; *********************************************

COLWN 	EQU 710

NSTEP 	EQU 10

XLOC   	EQU   $FA
YLOC   	EQU   $FB ; $FC
YLOC1  	EQU   $F1 ; $F2
YLOC2  	EQU   $F3 ; $F4
CHSET  	EQU   $F5 ; $F6 HI
CTPOS1 	EQU   $F7		; cactus position
CTPOS2 	EQU   $F9
CTLOC1 	EQU   $C3 ; $C4      ; Cactus location
CTLOC2 	EQU   $C5 ; $C6      ; Cactus location

INITX  	EQU   $E0       ; Initial X value
INITY  	EQU   $E1       ; Initial Y value
TMPTOP 	EQU   $100      ; Temporary storage (ADRESS)
PSIZE  	EQU   $F0		; Size of player in bytes
TMP1   	EQU   $E2      ; Temporary storage
POFF   	EQU   $E4      ; Offset of player in memory

TMP2   	EQU   $E6      ; Temporary storage
STRADR 	EQU   $E8      ; Address of string to print
MAXLEN 	EQU   $EA       ; Maximum length of string
JMPPOS 	EQU   $EB		; jump position
JMPIDX 	EQU   $ED		; jump index
JMPNG 	EQU   $EF		; is the dino jumping?

TICKER 	EQU $C0		; intro tick counter (1 byte)
TMP3 	EQU $C1 ; $C2
SNDVOICE EQU $C7      ; 0..3
SNDPITCH EQU $C8      ; 0..255
SNDDIST EQU $C9      ; 0..14 (even only)
SNDVOL EQU $CA      ; 1..15 (0 = silence)

LEVEL 		EQU $CB
DIST 		EQU $CC
SPDDELAY	EQU $CD

RTCLOK	EQU $12
vcount	EQU $d40b

SCTICKR 	EQU $83
LEVELTICK 	EQU $84
STPTICK 	EQU $87
; score equates
SCRELO 		EQU $80			; Score
SCREMID 	EQU $81
SCREHI 		EQU $82
TITLE_SHOWN EQU $85	; flag to track if title has been shown
zero 		EQU $86
LEG_FRME	EQU $88
LEG_LOC1	EQU $89 ; %8a
LEG_LOC2	EQU $90 ; %91
EYE_LOC		EQU $92

	ORG $2400

	.proc music
STEREOMODE	equ 0				;0 => compile RMTplayer for mono 4 tracks
init_song 	= RASTERMUSICTRACKER+0
play	  	= RASTERMUSICTRACKER+3
stop	  	= RASTERMUSICTRACKER+9

	icl "music/eleph2.feat"

player
	icl "music/rmt_player.asm"			;include RMT player routine
	icl 'music/rmt_relocator.asm'			;include RMT relocator
module
	rmt_relocator 'music/eleph2.rmt' module	;include music RMT module
	.endp

	icl 'utils.asm'
	icl 'intro.asm'

	.proc start	
		JSR init_ram
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
		LDA #140 ;fence bottom row offset
		PHA
		JSR puts
		JSR load_chset

		ldx #<music.module
		ldy #>music.module
		lda #0
		jsr music.init_song

		; init intro tick counter
reset	LDA #0
		STA TICKER
		LDA #19
		STA CTPOS1
		JSR INTRO

		;Clear space between fences
		LDA #blanks&255
		STA STRADR
		LDA #blanks/256
		STA STRADR+1
		LDA #19
		STA MAXLEN
		LDA #120 
		PHA
		JSR puts
		LDA #100 
		PHA
		JSR puts
GAME_START
		JSR reset_eye
		LDA #blanks&255
		STA STRADR
		LDA #blanks/256
		STA STRADR+1
		LDA #19
		STA MAXLEN
		LDA #0
		STA COLWN
		LDA lvl_colors
		STA COLOR4
		SBC #2
		STA COLOR2
		LDA #1 ; top row offset
		PHA
		JSR puts

		; *** Start actual game here ***
		LDA #0
		STA LEG_FRME
		STA LEVEL
		STA LEVELTICK
		STA TICKER
		STA SCRELO
		STA SCREMID
		STA SCREHI
		LDA #11
		STA SPDDELAY   
		LDA #255
		STA CTPOS1
		LDA #255
		STA CTPOS2
		LDA #6
		STA DIST
MAINLOOP
		CLC
		JSR stop_sound
		INC STPTICK
		INC SCTICKR

		JSR level_move
cont
		LDA STPTICK
		CMP #10
		BNE skip_snd
		LDA #0
		STA STPTICK
		JSR play_step_sound
		JSR animate_leg
skip_snd 
		NOP
skip_inc

		CLC
		LDA CTPOS1   ; if cactus is too close to the left side of the screen
		CMP #8
		BCS cc2
		LDA #255
		STA CTPOS1
		
cc2		CLC
		LDA CTPOS2
		CMP #8
		BCS skip_reset		; if greater than 50, keep going
		LDA #255
		STA CTPOS2  ; move cactus to the right side of the screen
		
		LDA RANDOM  ; random byte 0-255
		; test min distance
		
		AND #$1F      ; limit to 0-31
		ADC #38			; value 38-69	
		STA DIST
		CLC
		LDX LEVEL
		LDA min_dist,X
		CMP DIST
		BCS skip_reset
		LDA #8
		STA DIST

skip_reset
		CLC
		LDA #0
		STA HITCLR  ; clear hit flag
		LDA CTPOS1
		STA HPOSP0+3
		LDA CTPOS2
		STA HPOSM0+3
		CLC
		ADC #2
		STA HPOSM0+2
		ADC #2
		STA HPOSM0+1
		ADC #2
		STA HPOSM0
skip_move
		CLC
		LDX #$FF      ; Outer loop count
		LDY #$0B      ; Inner loop count
		JSR delay
		LDA SCTICKR
		CMP #10
		BNE skip_inc_score
		JSR inc_score
		LDA #0
		STA SCTICKR
skip_inc_score
		JSR READKEY
		JSR score_msg
		JSR print_score
		JSR collision
		LDA SCREHI
		CMP #$FF
		BEQ GAME_OVER
		JMP MAINLOOP
	.endp

	.proc GAME_OVER
		JSR stop_sound
		LDA #win_msg&255
		STA STRADR
		LDA #win_msg/256
		STA STRADR+1
		LDA #19
		STA MAXLEN
		LDA #0
		PHA
		LDA #0
		PHA
		JSR putstring

		LDA #pressstart&255
		STA STRADR
		LDA #pressstart/256
		STA STRADR+1
		LDA #16
		STA MAXLEN
		LDA #0
		PHA
		LDA #13
		PHA
		JSR putstring

		JSR wait_lp
		JSR wait_start
		LDA #blanks&255
		STA STRADR
		LDA #blanks/256
		STA STRADR+1
		LDA #19
		STA MAXLEN
		LDA #0
		PHA
		LDA #0
		PHA
		JSR putstring
		LDA #0
		PHA
		LDA #13
		PHA
		JSR putstring
		JMP start.GAME_START
	.endp

	.proc level_move
		INC TICKER
		DEC CTPOS1		
		LDA CTPOS2
		SBC CTPOS1
		CMP DIST
		BCC skip
		DEC CTPOS2
skip	LDA TICKER
		CLC
		LDA SPDDELAY
		CMP TICKER
		BNE skip_dec
		LDA #0
		STA TICKER
		DEC CTPOS1
		LDA CTPOS2
		SBC CTPOS1
		CMP DIST
		BCC skip_dec
		DEC CTPOS2
skip_dec
		RTS
	.endp

; **************************************
; Subroutines
; **************************************
	.proc animate_eye
		LDA YLOC1
		STA EYE_LOC
		LDA YLOC1+1
		STA EYE_LOC+1
		LDY #0
loop	LDA eye,Y
		STA (EYE_LOC),Y
		INY
		CPY #8
		BNE loop
		RTS
	.endp

	.proc reset_eye
		LDA YLOC1
		STA EYE_LOC
		LDA YLOC1+1
		STA EYE_LOC+1
		LDY #0
loop	LDA player1,Y
		STA (EYE_LOC),Y
		INY
		CPY #8
		BNE loop
		RTS
	.endp

	.proc animate_leg
		PHA
		TYA
		PHA
		CLC
		LDA YLOC1
		ADC #16
		STA LEG_LOC2
		LDA YLOC1+1
		ADC #0
		STA LEG_LOC2+1

		CLC
		LDA YLOC
		ADC #16
		STA LEG_LOC1
		LDA YLOC+1
		ADC #0
		STA LEG_LOC1+1
		
		CLC
		LDA LEG_FRME
		CMP #1
		BEQ lleg1
		CMP #2
		BEQ lleg2
		CMP #3
		BEQ lleg3

lleg0	LDY #0
loop	LDA fr1,Y
		STA (LEG_LOC1),Y
		INY
		CPY #8
		BNE loop
		LDA #1
		STA LEG_FRME
		JMP end_leg

lleg1	
		LDY #0
loop2	LDA leg1,Y
		STA (LEG_LOC1),Y
		INY
		CPY #8
		BNE loop2
		LDA #2
		STA LEG_FRME
		JMP end_leg

lleg2	LDY #0
loop3	LDA leg2,Y
		STA (LEG_LOC2),Y
		INY
		CPY #8
		BNE loop3
		LDA #3
		STA LEG_FRME
		JMP end_leg

lleg3	LDY #0
loop4	LDA fr2,Y
		STA (LEG_LOC2),Y
		INY
		CPY #8
		BNE loop4
		LDA #0
		STA LEG_FRME

end_leg
		PLA
		TYA
		PLA
		RTS
	.endp

	.proc collision
		CLC
		LDA P3PL
		AND #1
		BNE collide
		LDA P3PL
		AND #2
		BNE collide
		LDA P3PL
		AND #4
		BNE collide
		LDA M0PL
		AND #1
		BNE collide
		LDA M1PL
		AND #1
		BNE	collide
		LDA #0
		STA HITCLR
		RTS

collide
		JSR play_hit_sound
		; print game over
		LDA #gameover&255
		STA STRADR
		LDA #gameover/256
		STA STRADR+1
		LDA #17
		STA MAXLEN
		LDA #1 ; top row offset
		PHA
		JSR puts
		LDA #pressstart&255
		STA STRADR
		LDA #pressstart/256
		STA STRADR+1
		LDA #16
		STA MAXLEN
		LDA #0
		PHA
		LDA #12
		PHA
		JSR putstring
		JSR animate_eye
		JSR wait_start
		JMP start.GAME_START
skip
		JSR wait_lp
		JMP wait_start
	.endp


	.proc wait_start
		; wait for start key
		LDA CONSOL
		CMP #6
		BEQ end
		JSR wait_lp
		JMP wait_start
end		RTS
	.endp

	.proc play_hit_sound
		LDA #0
		STA SNDVOICE
		LDA #$A8
		STA SNDPITCH
		LDA #10
		STA SNDDIST
		LDA #10
		STA SNDVOL
		JSR play_sound
		LDX #$FF      ; Outer loop count
		LDY #$FF      ; Inner loop count
		JSR delay
		JSR stop_sound
		RTS
	.endp

	.proc inc_score
		CLC
		LDA SCRELO
		ADC #1
		STA SCRELO
		LDA SCREMID
		ADC #0			; propagate carry
		STA SCREMID
		LDA SCREHI
		ADC #0			; propagate carry
		STA SCREHI
		INC LEVELTICK
		LDA LEVELTICK
		CMP #100
		BNE skip_level_inc
		LDA #0
		STA LEVELTICK
		LDA LEVEL
		CMP #10
		BCS skip_level_inc
		INC LEVEL
		DEC SPDDELAY
		JSR play_level_sound
		LDX LEVEL
		LDA lvl_colors,X
		STA COLOR4
		;SBC #2
		;STA COLOR2
skip_level_inc
		CLC
		; LDA #$0E
		; STA PCOLR0
		; STA PCOLR0+1
		; STA PCOLR0+2
		RTS
	.endp

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

		LDA #16
		STA PSIZE
		; Player 3 is the cactus
		LDA #cactus1/256
		PHA 
		LDA #cactus1&255
		PHA
		LDA CTLOC1
		STA POFF
		LDA CTLOC1+1
		STA POFF+1
		JSR copy_player

		LDA #16
		STA PSIZE
		; Player 4 is the second cactus
		LDA #cactus2/256
		PHA 
		LDA #cactus2&255
		PHA
		LDA CTLOC2
		STA POFF
		LDA CTLOC2+1
		STA POFF+1
		JSR copy_player

		LDA #24
		STA PSIZE
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
		LDA #0
		STA LEVEL
		LDA #11
		STA SPDDELAY
		RTS
	.endp		
	
	.proc init_gra
       LDA #2
       PHA           ; Store on stack (GR.2+16 = split screen + text window)
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
		LDA #68     ; Initial postitions fort players
		STA INITX
		LDA #50
		STA INITY
		LDA #100
		STA CTPOS1
		LDA #100
		STA CTPOS2
		
		LDA #46
		STA 559 	;SDMCTL
		LDA #17
		STA GPRIOR  ; priority
		;LDA #32
		;STA PRIOR  ;Enable missiles as 5th player

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

		LDA YLOC2
		ADC #128
		ADC #8   ; cactus 1 vertical position
		STA CTLOC1
		LDA YLOC2+1
		ADC #0
		STA CTLOC1+1
		
		LDA YLOC
		SEC
		SBC #120
		STA CTLOC2
		LDA YLOC+1
		SBC #0
		STA CTLOC2+1
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
loop
		LDA (TMP1),Y
		STA (POFF),Y
		INY
		CPY PSIZE			;player Size
		BNE loop
		LDA INITX
		STA HPOSP0
		STA XLOC
		CLC
		ADC #8
		STA HPOSP0+1
		ADC #8
		STA HPOSP0+2

		; Set cactus position off screen
		LDA #255
		STA HPOSP0+3
		LDA #$C4        ; color green
		STA PCOLR0+3
		LDA #$C4        ; color green
		STA COLOR3
		
		LDA #$0E 		;color white
		STA PCOLR0
		STA PCOLR0+1
		STA PCOLR0+2
		LDA #3		;enable player
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
jp		JSR jump
		
		LDA #255
		STA KEYPRES
retk	RTS			
	.endp

	.proc autojump
		LDA JMPNG
		CMP #1
		BEQ jp
		LDA #1
		STA JMPNG
jp		JSR jump	
		LDA #255
		STA KEYPRES
retk	RTS			
	.endp

	.proc play_level_sound
		LDA #0
		STA SNDVOICE
		LDA #$F2
		STA SNDPITCH
		LDA #10
		STA SNDDIST
		LDA #10
		STA SNDVOL
		JSR play_sound
		LDX #$FF      ; Outer loop count
		LDY #$FF      ; Inner loop count
		JSR delay
		LDA #0
		STA SNDVOICE
		LDA #$30
		STA SNDPITCH
		LDA #10
		STA SNDDIST
		LDA #10
		STA SNDVOL
		JSR play_sound
		LDX #$FF      ; Outer loop count
		LDY #$FF      ; Inner loop count
		JSR delay
		JSR stop_sound
		RTS
	.endp

	.proc play_step_sound
		LDA #0
		STA SNDVOICE
		LDA #100
		STA SNDPITCH
		LDA #12
		STA SNDDIST
		LDA #100
		STA SNDVOL
		JSR play_sound
		RTS
	.endp

	.proc jump
		LDY JMPIDX
		LDA jumpseq,Y
		CMP JMPPOS
		BEQ jstep_done
		BCS jmove_up        ; A > JMPPOS -> move up
		JSR DOWN            ; A < JMPPOS -> move down
		JSR DOWN
		DEC JMPPOS
		RTS
jmove_up
		JSR UP
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
	.endp

	.proc stop_sound
		LDA #0
		STA SNDVOICE
		STA SNDVOL
		JSR play_sound
		RTS
	.endp

		; Inputs (via params):
		;   SNDVOICE = voice 0..3
		;   SNDPITCH = pitch 0..255
		;   SNDDIST  = distortion 0..14 (even values)
		;   SNDVOL   = volume 0..15 (1..15 audible)
	.proc play_sound
		LDA SNDVOICE
		AND #3
		ASL
		TAX

		LDA SNDPITCH
		STA AUDF1,X

		LDA #0
		STA AUDC1
		LDA #3
		STA SKCTL
		
		LDA SNDVOL
		AND #$0F
		STA SNDVOL

		LDA SNDDIST
		AND #$0E
		ASL
		ASL
		ASL
		ASL
		CLC
		ADC SNDVOL
		STA AUDC1,X
		RTS
		.endp
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
LEFT
		DEC XLOC     ; To move it left
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
		

		; ******************************
		; Load custom character set
		; ******************************
	.proc load_chset
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
		; load cactus characters in an offset of 1 characters (!)
		LDA #8
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
	.endp

	.proc wait_lp
		lda RTCLOK+2    ; Load current timer value
wait	cmp RTCLOK+2    ; Has it changed yet?
		beq wait        ; No, wait for VBLANK
		rts             ; Yes, VBLANK has occurred
	.endp

	; print SCORE message
	.proc score_msg
		LDA #score&255
		STA STRADR
		LDA #score/256
		STA STRADR+1
		LDA #27
		STA MAXLEN
		LDA #0
		PHA
		LDA #12		; text window row 0, centered (200 + 10)
		PHA
		JSR putstring
		RTS
	.endp

	; Delay routine
	; Input: X = outer loop count, Y = inner loop count
	.proc delay
		STY TMP1      ; Save inner loop count
OUTER   LDY TMP1      ; Reset inner loop counter
INNER   DEY
        BNE INNER
        DEX
        BNE OUTER
		RTS
	.endp

player0 .BYTE 0,0,0,0,0,0,0,0
		.BYTE 0,0,128,128,192,231,255,255
leg1	.BYTE 127,63,31,15,7,6,4,6
player1 .BYTE 0,0,0,7,15,27,31,31
		.BYTE 31,28,63,124,252,255,253,252
leg2	.BYTE 248,248,240,224,96,32,32,48
player2 .BYTE 0,0,0,224,240,240,240,240
		.BYTE 240,0,224,0,0,0,0,0
		.BYTE 0,0,0,0,0,0,0,0

fr1 	.BYTE $7F,$3F,$1F,$0F,$07,$06,$03,$00
fr2 	.BYTE $F8,$F8,$F0,$E0,$60,$38,$00,$00
eye 	.BYTE $00,$00,$00,$07,$08,$18,$18,$18

cactus1 .BYTE 0,0,0,48,48,50,50,178,190,176,240,48,48,48,48,48
cactus2 .BYTE 0,0,0,24,26,26,26,94,88,88,88,120,24,24,24,24
cactus3 .BYTE 0,0,26,26,90,90,90,94,88,120,24,24,24,24,24,24

fence 	.BYTE "!!!!!!!!!!!!!!!!!!",$9B
c1 		.BYTE "!"+130,"!"+131,$9B
c2 		.BYTE "!"+128,"!"+129,$9B
c3 		.BYTE "!"+132,"!"+133,$9B
clr 	.BYTE " ",$9B

blanks		.BYTE "                    ",$9B
pressstart 	.BYTE " *** PRESS START TO BEGIN ***",$9B
score 	    .BYTE "   SCORE:                    ",$9B
gameover 	.BYTE "*** GAME OVER ***",$9B
; Snappier, faster peak
title		.BYTE "  THE JUMPY DINO  ",$9B
win_msg .BYTE "*** MAX SCORE ***",$9B
jumpseq		.BYTE 2,4,8,12,16,12,12,4,2,0
NAME    	.BYTE c"S:",$9B
tabpp  		.BYTE 156,78,52,39			;line counter spacing table for instrument speed from 1 to 4
lvl_colors 	.BYTE $83,$81,$90,$36,$32,0,$55,$52,$30,$32,$34
	 	run start 	;Define run address
;table .byte 212,228,244,148,196,4,20,36,52,68,84,100,116,132,148,164,180
table 		.byte $6A,$62,$60,$10,$10
min_dist 	.byte 65,60,60,60,55,55,50,45,45,40,38
jump_a		.word 0
