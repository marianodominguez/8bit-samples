
; **************************************
; Intro loop - auto-jump every ~1 sec
; exits on START key press
; **************************************

    .proc INTRO
		; print PRESS START message
		LDA #pressstart&255
		STA STRADR
		LDA #pressstart/256
		STA STRADR+1
		LDA #27
		STA MAXLEN
		LDA #0
		PHA
		LDA #12		; text window row 0, centered (200 + 10)
		PHA
		JSR putstring
		jsr wait_lp
		jsr music.play

		; check START key (CONSOL bit 0 = 0 when pressed)
		LDA CONSOL
		AND #1
		BEQ END_INTRO

		; auto-jump every ~50 frames (~1 second)
		INC TICKER
		LDA TICKER
		CMP #40
		BEQ move_cactus
		CMP #50
		BCC intro_no_jump
		LDA #0
		STA TICKER
		LDA #1
		STA JMPNG		; trigger a jump
intro_no_jump
		LDA JMPNG
		BEQ INTRO
		LDX #5
		LDY #0
		JSR autojump
		JMP INTRO
move_cactus
		DEC CTPOS1
		LDA CTPOS1
		CMP #0
		BNE cont
		LDA #18
		STA CTPOS1
cont	JSR DisplayCactus
		JSR print_title
		JMP INTRO
END_INTRO
		JSR music.stop
		JSR install_dli
		RTS
    .endp

	.proc print_title
		LDA TITLE_SHOWN
		BEQ show_title
		JMP print_title_done
show_title
		LDA #title&255
		STA STRADR
		LDA #title/256
		STA STRADR+1
		LDA #19
		STA MAXLEN
		LDA #0
		PHA
		LDA #0		
		PHA
		JSR putstring
		LDA #1
		STA TITLE_SHOWN
		JSR wait_lp
		RTS
print_title_done
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
		STA TITLE_SHOWN
		RTS
	.endp

	.proc install_dli
		; Install DLI at $E000, with IRQ handler at $E002
		LDA #$0
		STA NMIEN			; Disable DLI during setup
		LDA VVBLKI
		STA jump_a			; Set DLI address low byte
		LDA VVBLKI+1
		STA jump_a+1			; Set DLI address high byte
		
		ldx #>callback 
		ldy #<callback
		lda #6
		jsr SETVBV

		LDA #callback.my_dli&255
		STA VDSLST			; Set IRQ handler address low byte
		LDA #callback.my_dli/256
		STA VDSLST+1			; Set IRQ handler address high byte
		
		;JSR wait_lp			; Wait for VBI to ensure DLI is set up before enabling it
		LDA #%11100000	; Enable DLI and IRQs (bit 4 = DLI enable, bit 0 = IRQ enable)
		STA NMIEN			; Enable DLI with interrupts
		RTS
	.endp

	.proc callback
		; This is the callback address used for the DLI, called by the DLI handler at $E002
		; It can be used to update graphics registers or perform other tasks during the DLI
		LDA #0
		STA zero
		jmp (jump_a)			; Jump to the DLI code at $E000, which can be changed dynamically by writing to jump_a
my_dli	PHA
		txa
		pha
		ldx zero
		lda table,x
		sta WSYNC
		sta COLBK
		inc zero
		;cpx #16
		;bne skip_reset
		;ldx #0
		;stx zero
skip_reset
		pla
		tax
		PLA  ; restore accumulator before returning
		rti
	.endp
