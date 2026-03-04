
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

		jsr wait
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
		JMP INTRO
END_INTRO
		JSR music.stop
		RTS
        .endp