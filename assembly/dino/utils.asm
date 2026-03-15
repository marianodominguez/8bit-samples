

; *** PRINT a String ***
;
        .proc putstring
        ; Save return address
        PLA
        STA TMP2
        PLA
        STA TMP2+1

        ; Pull row and col from stack
        PLA                 ; row
        STA TMP1            ; stash row temporarily
        PLA                 ; col
        STA TMP1+1          ; stash col temporarily

        ; Compute row * 20 (16-bit): row * 16 + row * 4
        LDA TMP1            ; row
        ASL               ; row * 2
        ASL               ; row * 4
        STA TMP3            ; save partial (row*4) lo
        LDA #0
        ROL               ; carry from last shift
        STA TMP3+1          ; row*4 hi

        LDA TMP1            ; row again
        ASL               ; *2
        ASL               ; *4
        ASL               ; *8
        ASL               ; *16
        TAX                 ; save row*16 lo
        LDA #0
        ROL              ; carry
        ; add row*4 + row*16 = row*20
        CLC
        TXA
        ADC TMP3            ; row*16 + row*4
        STA TMP3
        LDA #0
        ADC TMP3+1
        STA TMP3+1          ; TMP3 = row * 20 (16-bit)

        ; Add col
        CLC
        LDA TMP3
        ADC TMP1+1          ; + col
        STA TMP3
        LDA TMP3+1
        ADC #0
        STA TMP3+1          ; TMP3 = row*20 + col

        ; Add SAVMSC (screen base, 16-bit)
        CLC
        LDA TMP3
        ADC SAVMSC
        STA TMP1
        LDA TMP3+1
        ADC SAVMSC+1
        STA TMP1+1          ; TMP1 = final screen address

        ; Restore return address
        LDA TMP2+1
        PHA
        LDA TMP2
        PHA

        ; Print loop
        LDY #0
puts_loop
        LDA (STRADR),Y
        CMP #$9B            ; ATASCII EOL
        BEQ puts_done
        STA (TMP1),Y
        INY
        CPY MAXLEN
        BNE puts_loop
puts_done
        RTS
        .endp

; *** PRINT a String ***
.proc puts 	
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
	.endp

	.proc print_score
		; Convert SCREHI:SCREMID:SCRELO (24-bit binary) to 6 decimal digits
		; Atari internal screen code for '0'-'9' = $10-$19
		; Algorithm: repeated 24-bit subtraction against pow10 table

		; Make working copy of score
		LDA SCRELO
		STA work
		LDA SCREMID
		STA work+1
		LDA SCREHI
		STA work+2

		LDX #0			; scr_buf index (0..5)
		LDY #0			; pow10 table byte index (stride 3)

dig_loop
		; Load current power of 10 (little-endian, 3 bytes)
		LDA pow10,Y
		STA d_lo
		LDA pow10+1,Y
		STA d_mid
		LDA pow10+2,Y
		STA d_hi

		LDA #0
		STA d_cnt		; digit counter = 0

sub_loop
		; Is work >= (d_hi:d_mid:d_lo)?  Compare high to low.
		LDA work+2
		CMP d_hi
		BCC do_store		; work.hi < d_hi -> done
		BNE do_sub		; work.hi > d_hi -> subtract
		LDA work+1
		CMP d_mid
		BCC do_store
		BNE do_sub
		LDA work
		CMP d_lo
		BCC do_store		; work < power -> done

do_sub
		; work -= power (24-bit)
		SEC
		LDA work
		SBC d_lo
		STA work
		LDA work+1
		SBC d_mid
		STA work+1
		LDA work+2
		SBC d_hi
		STA work+2
		INC d_cnt
		JMP sub_loop

do_store
		; digit = d_cnt, convert to Atari internal screen code
		LDA d_cnt
		CLC
		ADC #$10		; '0' in Atari internal = $10
		STA scr_buf,X
		INX

		; advance to next power-of-10 entry (3 bytes per entry)
		INY
		INY
		INY
		CPX #6
		BNE dig_loop

		; point STRADR at scr_buf and display
		LDA #scr_buf&255
		STA STRADR
		LDA #scr_buf/256
		STA STRADR+1
		LDA #27
		STA MAXLEN
		LDA #10
		PHA
		LDA #12
		PHA
		JSR putstring
		RTS

		; Powers of 10 table (little-endian, 3 bytes each)
pow10	.byte $A0,$86,$01	; 100000
		.byte $10,$27,$00	; 10000
		.byte $E8,$03,$00	; 1000
		.byte $64,$00,$00	; 100
		.byte $0A,$00,$00	; 10
		.byte $01,$00,$00	; 1

		; Working copy of score (3 bytes)
work	.byte 0,0,0

		; Current power-of-10 (3 bytes, loaded per digit)
d_lo	.byte 0
d_mid	.byte 0
d_hi	.byte 0
d_cnt	.byte 0			; digit accumulator

		; 6-char screen buffer + ATASCII EOL
scr_buf	.byte 0,0,0,0,0,0,$9B
		.endp
