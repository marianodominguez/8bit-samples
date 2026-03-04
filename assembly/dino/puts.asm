; *** PRINT a String ***
; Caller pushes: col (first), then row (second, popped first)
; STRADR = string address, MAXLEN = max chars
; GR.2 split screen: 20 bytes per row
;
; Stack on entry (after JSR):
;   SP+1 = return lo
;   SP+2 = return hi
;   SP+3 = row
;   SP+4 = col
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