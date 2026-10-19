
; ******************************
; BATAROO - base setup
; port of tbasic/bataroo.tba
; ******************************

; CIO equates
ICCOM 	EQU    $0342
ICBAL 	EQU    $0344
ICBAH 	EQU    $0345
ICAX1 	EQU    $034A
ICAX2 	EQU    $034B
CIOV  	EQU    $E456

; sys equates
RAMTOP 	EQU  106
RTCLOK	EQU  $12
SAVMSC 	EQU  $58
SDMCTL	EQU  559
PCOLR0 	EQU  704
COLOR0 	EQU $02C4
COLOR2 	EQU $02C6
COLOR3 	EQU $02C7
COLOR4 	EQU $02C8
STICK0	EQU $0278		; joystick 0 shadow
GPRIOR	EQU $26F

PMBASE 	EQU $D407
GRACTL 	EQU $D01D
HPOSP0 	EQU $D000		; Horizontal position Player 0

SPR_H	EQU 39			; sprite height in bytes (incl. blank top/bottom rows)

; joystick limits (from the BASIC version)
BAT_XMIN	EQU 33
BAT_XMAX	EQU 200
BAT_YMIN	EQU 17
BAT_YMAX	EQU 180
LULA_XMIN	EQU 59
LULA_XMAX	EQU 150
LULA_Y		EQU 20

; zero page vars
PMPG	EQU $80		; PM base page (2K aligned)
BATX	EQU $81
BATY	EQU $82
BATFR	EQU $83		; bat animation frame 0/1
LULAX	EQU $84
LULADX	EQU $85		; +1 / -1
LULAFR	EQU $86		; lula animation frame 0/1
ANIMTK	EQU $87		; bat animation tick
FRAMECT	EQU $88		; frame counter
MOVED	EQU $89		; bat moved this frame?
SRC		EQU $8A ; $8B	; sprite data pointer
DST		EQU $8C ; $8D	; player memory pointer
TMP1	EQU $8E ; $8F

	ORG $2400

	.proc start
		JSR init_ram
		JSR init_gra
		JSR init_colors
		JSR pm_init
		JSR draw_scene

		LDA #49
		STA BATX
		LDA #155
		STA BATY
		LDA #60
		STA LULAX
		LDA #1
		STA LULADX
		LDA #0
		STA BATFR
		STA LULAFR
		STA ANIMTK
		STA FRAMECT
MAINLOOP
		JSR wait_lp
		JSR set_hpos
		JSR draw_bat
		JSR draw_lula
		INC FRAMECT
		JSR read_stick
		JSR move_lula
		JMP MAINLOOP
	.endp

; **************************************
; Init
; **************************************

	; *** reserve 2K for single line PM below RAMTOP ****
	.proc init_ram
		LDA RAMTOP
		SEC
		SBC #8			; reserve 8 pages for PM
		AND #$F8		; single line res needs 2K alignment
		STA PMPG
		STA PMBASE
		STA RAMTOP		; new ramtop, screen goes below
		RTS
	.endp

	; *** GRAPHICS 1 (with text window) ***
	.proc init_gra
		LDX #$60      ; IOCB6 for screen
		LDA #$C       ; CLOSE command
		STA ICCOM,X
		JSR CIOV
		LDX #$60
		LDA #3        ; OPEN command
		STA ICCOM,X
		LDA #NAME&255 ; Name is "S:"
		STA ICBAL,X
		LDA #NAME/256
		STA ICBAH,X
		LDA #1        ; GRAPHICS 1
		STA ICAX2,X
		LDA #$1C      ; read/write + text window
		STA ICAX1,X
		JSR CIOV
		RTS
	.endp

	; SETCOLOR 4,6,8:SETCOLOR 0,1,12:SETCOLOR 3,0,0:SETCOLOR 2,0,2
	.proc init_colors
		LDA #$68
		STA COLOR4
		LDA #$1C
		STA COLOR0
		LDA #$00
		STA COLOR3
		LDA #$02
		STA COLOR2
		RTS
	.endp

	.proc pm_init
		; clear missiles + 4 players (pages +3..+7)
		LDA PMPG
		CLC
		ADC #3
		STA DST+1
		LDA #0
		STA DST
		LDX #5
clr_pg	LDY #0
		LDA #0
clr		STA (DST),Y
		INY
		BNE clr
		INC DST+1
		DEX
		BNE clr_pg

		LDA #$72		; bat: blue
		STA PCOLR0
		STA PCOLR0+1
		LDA #$02		; lula: dark / brown
		STA PCOLR0+2
		LDA #$26
		STA PCOLR0+3
		LDA #1			; players over playfield
		STA GPRIOR
		LDA #62			; single line PM + missiles + players DMA
		STA SDMCTL
		LDA #3			; enable players + missiles
		STA GRACTL
		RTS
	.endp

	; floor lines, rows 2 and 12 (20 chars per row in GR.1)
	.proc draw_scene
		CLC
		LDA SAVMSC
		ADC #40			; row 2
		STA TMP1
		LDA SAVMSC+1
		ADC #0
		STA TMP1+1
		LDY #19
		LDA #63			; "_" internal code, COLOR0
row2	STA (TMP1),Y
		DEY
		BPL row2

		CLC
		LDA SAVMSC
		ADC #240		; row 12
		STA TMP1
		LDA SAVMSC+1
		ADC #0
		STA TMP1+1
		LDY #19
		LDA #13			; "-"
row12	STA (TMP1),Y
		DEY
		BPL row12
		RTS
	.endp

; **************************************
; Game loop routines
; **************************************

	.proc set_hpos
		LDA BATX
		STA HPOSP0
		CLC
		ADC #8
		STA HPOSP0+1
		LDA LULAX
		STA HPOSP0+2
		STA HPOSP0+3
		RTS
	.endp

	; joystick: bit clear = pressed (0 up, 1 down, 2 left, 3 right)
	.proc read_stick
		LDA #0
		STA MOVED
		LDA STICK0
		STA TMP1

		LSR TMP1		; up
		BCS no_up
		LDA BATY
		CMP #BAT_YMIN
		BCC no_up
		DEC BATY
		INC MOVED
no_up
		LSR TMP1		; down
		BCS no_down
		LDA BATY
		CMP #BAT_YMAX
		BCS no_down
		INC BATY
		INC MOVED
no_down
		LSR TMP1		; left
		BCS no_left
		LDA BATX
		CMP #BAT_XMIN
		BCC no_left
		DEC BATX
		DEC BATX
		INC MOVED
no_left
		LSR TMP1		; right
		BCS no_right
		LDA BATX
		CMP #BAT_XMAX
		BCS no_right
		INC BATX
		INC BATX
		INC MOVED
no_right
		; flap every 8 frames while moving
		LDA MOVED
		BEQ done
		INC ANIMTK
		LDA ANIMTK
		AND #7
		BNE done
		LDA BATFR
		EOR #1
		STA BATFR
done	RTS
	.endp

	; lula walks back and forth, 1 px every other frame
	.proc move_lula
		LDA FRAMECT
		AND #1
		BNE done
		CLC
		LDA LULAX
		ADC LULADX
		STA LULAX
		CMP #LULA_XMIN
		BCS chk_hi
		LDA #1
		STA LULADX
		JMP frame
chk_hi	CMP #LULA_XMAX+1
		BCC frame
		LDA #$FF
		STA LULADX
frame	LDA LULAX		; switch frame every 4 px
		AND #4
		LSR
		LSR
		STA LULAFR
done	RTS
	.endp

	.proc draw_bat
		LDX BATFR
		LDA bat0_lo,X
		STA SRC
		LDA bat0_hi,X
		STA SRC+1
		LDA BATY
		STA DST
		LDA PMPG
		CLC
		ADC #4			; player 0
		STA DST+1
		JSR draw_sprite

		LDX BATFR
		LDA bat1_lo,X
		STA SRC
		LDA bat1_hi,X
		STA SRC+1
		INC DST+1		; player 1
		JSR draw_sprite
		RTS
	.endp

	.proc draw_lula
		LDX LULAFR
		LDA lula0_lo,X
		STA SRC
		LDA lula0_hi,X
		STA SRC+1
		LDA #LULA_Y
		STA DST
		LDA PMPG
		CLC
		ADC #6			; player 2
		STA DST+1
		JSR draw_sprite

		LDX LULAFR
		LDA lula1_lo,X
		STA SRC
		LDA lula1_hi,X
		STA SRC+1
		INC DST+1		; player 3
		JSR draw_sprite
		RTS
	.endp

	; copy SPR_H bytes from (SRC) to (DST)
	; blank first/last rows erase the trail of 1px vertical moves
	.proc draw_sprite
		LDY #SPR_H-1
loop	LDA (SRC),Y
		STA (DST),Y
		DEY
		BPL loop
		RTS
	.endp

	.proc wait_lp
		lda RTCLOK+2    ; Load current timer value
wait	cmp RTCLOK+2    ; Has it changed yet?
		beq wait        ; No, wait for VBLANK
		rts             ; Yes, VBLANK has occurred
	.endp

; **************************************
; Data
; **************************************

NAME    	.BYTE c"S:",$9B

; frame pointer tables [frame 0, frame 1]
bat0_lo		.BYTE bat_l1&255, bat_l2&255
bat0_hi		.BYTE bat_l1/256, bat_l2/256
bat1_lo		.BYTE bat_r1&255, bat_r2&255
bat1_hi		.BYTE bat_r1/256, bat_r2/256
lula0_lo	.BYTE lula_a0&255, lula_b0&255
lula0_hi	.BYTE lula_a0/256, lula_b0/256
lula1_lo	.BYTE lula_a1&255, lula_b1&255
lula1_hi	.BYTE lula_a1/256, lula_b1/256

; bat frame 1 (P0 left half, P1 right half)
bat_l1	.BYTE 0
		.BYTE 14,11,10,110,100,100,84,86
		.BYTE 82,83,85,87,92,76,79,72
		.BYTE 72,79,104,40,40,40,40,45
		.BYTE 42,45,38,37,54,23,26,11
		.BYTE 6,4,4,4,3,0
bat_r1	.BYTE 0
		.BYTE 224,184,136,108,38,6,6,6
		.BYTE 4,204,248,57,14,73,137,206
		.BYTE 200,200,8,4,4,4,4,84
		.BYTE 168,88,168,88,168,94,177,255
		.BYTE 184,12,2,2,254,0

; bat frame 2
bat_l2	.BYTE 0
		.BYTE 4,10,11,10,110,164,164,164
		.BYTE 166,162,163,165,167,188,140,143
		.BYTE 136,200,79,104,40,40,40,40
		.BYTE 40,45,42,37,38,53,22,27
		.BYTE 11,6,4,4,3,0
bat_r2	.BYTE 0
		.BYTE 64,224,184,136,108,38,6,6
		.BYTE 6,4,204,248,57,14,73,137
		.BYTE 206,200,200,8,4,4,4,4
		.BYTE 4,88,168,88,168,88,168,118
		.BYTE 241,191,12,226,146,0

; lula frame 1 (P2 + P3 overlapped)
lula_a0	.BYTE 0
		.BYTE 0,0,0,195,165,153,153,0
		.BYTE 2,38,229,227,163,161,161,161
		.BYTE 161,161,177,179,51,51,0,0
		.BYTE 0,0,0,0,0,0,0,0
		.BYTE 0,0,0,0,0,0
lula_a1	.BYTE 0
		.BYTE 0,0,0,60,90,102,102,60
		.BYTE 60,24,24,28,92,94,94,94
		.BYTE 30,30,14,12,0,0,0,0
		.BYTE 0,0,0,0,0,0,0,0
		.BYTE 0,0,0,0,0,0

; lula frame 2
lula_b0	.BYTE 0
		.BYTE 1,1,1,195,164,152,88,0
		.BYTE 2,38,229,227,163,161,161,161
		.BYTE 161,161,177,51,102,102,0,0
		.BYTE 0,0,0,0,0,0,0,0
		.BYTE 0,0,0,0,0,0
lula_b1	.BYTE 0
		.BYTE 0,0,0,60,90,102,38,60
		.BYTE 60,24,24,28,92,94,94,94
		.BYTE 30,30,14,12,0,0,0,0
		.BYTE 0,0,0,0,0,0,0,0
		.BYTE 0,0,0,0,0,0

	run start 	;Define run address
