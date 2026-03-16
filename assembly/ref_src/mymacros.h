	opt l-
; Useful Macros

; close channel	
	;ICL "header.h"	 
CLOSECH	 .macro chan ; channel number 0 thro 7
		 LDA #:chan
		 :+4 ASL ; chan * 16
		 TAX
		 MVA #CLOSE ICCOM,X
		 JSR CIOV
		 .endm

; Open Screen
OSCREEN  .macro chan mode file ; channel, Graphics Mode, E:/S:
		 LDA #:chan
		 :+4 ASL ; chan * 16
		 TAX
		 MVA #OPEN ICCOM,X
        	 MVA #<:file ICBAL,X
        	 MVA #>:file ICBAH,X
         	MVA #3 ICBLL,X
         	MVA #0 ICBLH,X
         	MVA #12 ICAX1,X
         	MVA :mode ICAX2,X
         JSR CIOV
		 .endm
		 
; open a channel
OPENCH	.macro chan mode file
		LDA #:chan
		:+4 ASL ; chan * 16
		TAX
		MVA #OPEN ICCOM,X
         	MVA #<:file ICBAL,X
         	MVA #>:file ICBAH,X
         	MVA #$80 ICBLL,X
         	MVA #0 ICBLH,X
         	MVA #:mode ICAX1,X
         	MVA #0 ICAX2,X
         	JSR CIOV
		 .endm
		 
; get record from channel
READREC  .macro chan buff size
		LDA #:chan
		:+4 ASL ; chan * 16
		TAX
		lda #<:buff
		STA $0344,X
         	LDA #>:buff
         	STA $0345,X
         	LDA #GETREC
         	STA $0342,X
         	LDA #<:SIZE
         	STA $0348,X
         	LDA #>:SIZE
         	STA $0349,X
		 JSR CIOV
        .endm
        
; get record from channel
WRITEREC  .macro chan buff size
		LDA #:chan
		:+4 ASL ; chan * 16
		TAX
		lda #<:buff
		STA $0344,X
         	LDA #>:buff
         	STA $0345,X
         	LDA #PUTREC
         	STA $0342,X
         	LDA #<:SIZE
         	STA $0348,X
         	LDA #>:SIZE
         	STA $0349,X
		JSR CIOV
        .endm        
; get bytes from channel
READBYTES  .macro chan buff size
		LDA #:chan
		:+4 ASL ; chan * 16
		TAX
		lda #<:buff
		STA $0344,X
         	LDA #>:buff
         	STA $0345,X
         	LDA #GETBYTES
         	STA $0342,X
         	LDA #<:SIZE
         	STA $0348,X
         	LDA #>:SIZE
         	STA $0349,X
		JSR CIOV
        .endm       
 ; put bytes from channel
WRITEBYTES  .macro chan buff size
		LDA #:chan
		:+4 ASL ; chan * 16
		TAX
		lda #<:buff
		STA $0344,X
         	LDA #>:buff
         	STA $0345,X
         	LDA #PUTBYTES
         	STA $0342,X
         	LDA #<:SIZE
         	STA $0348,X
         	LDA #>:SIZE
         	STA $0349,X
		JSR CIOV
        .endm  
;	PHA,PHX
PHX		.macro	
		PHA
		TXA
		PHA
		.endm
PLX		.macro
		PLA
		TAX
		PLA
		.endm
;	PHA,PHY
PHY		.macro
		PHA
		TYA
		PHA
		.endm
PLY		.macro
		PLA
		TAY
		PLA
		.endm
		
; unconditional branch
BRA		.macro branch ; tested
		CLV
		BVC :branch
		.endm
; branch > than		
BGT		.macro branch ; tested
		BCS :branch
		BNE :branch
		.endm
; branch >=
BGE		.macro branch ; tested
		BCS :branch	
		.endm
		
; branch < than
BLT		.macro branch ; tested
		BCC :branch
		.endm

; branch <= than 
BLE		.macro branch ; tested
		BCC :branch
		BEQ :branch
		.endm
	
 ;increment pointer in page zero	
inczp   .macro addr
		.if :addr <= 255
			inc :addr
			bne dl3
			inc :addr+1
		.else
			lda <:addr
			clc
			adc #1
			sta :addr
			lda #0
			adc >:addr
			sta :addr+1
		.endif
dl3		;sta (:addr),y
		.endm		
		
squares 	.macro pat	
ll2		ldy #63
l1		ldx #9
ll1		MVA :pat,x (PIXEL),y
		dey
		dex
		bpl ll1
		tya
		bpl l1
		jsr lines ; write 10 lines
		bpl ll2	
		.endm	
		
	; SETVBV Macro 7 deferred, 6 immediate
setvb 	.macro address type
		ldx #>:address 
		ldy #<:address
		lda #:type
		jsr SETVBV
		.endm
	
	; print text message to channel	
MESSAGE  .macro chan buff
		LDA #:chan
		:+4 ASL ; chan * 16
		TAX
		lda #<:buff
		STA $0344,X
         	LDA #>:buff
         	STA $0345,X
         	LDA #PUTREC
         	STA $0342,X
         	LDA #120
         	STA $0348,X
         	LDA #0
         	STA $0349,X
		JSR CIOV
        	.endm
		
		; floating point to integer
FP2I     	.MACRO addr buff ; FP number buffer, int result in buff
         	LDX #<:addr
         	LDY #>:addr         
		JSR FLD0R		; load FP number using x and y reg
         	JSR FPI		; FP to INT
         	LDA FR0		; result D4 and D5
         	STA :buff
         	LDA FR0+1
         	STA :buff+1
         	.ENDM 
		; Int to FP
I2FP		.MACRO val buff ; integer , buffer for result
		lda :val
		sta FR0
		lda :val+1
		sta FR0+1
		JSR IFP
		ldx #5	; store FP in buffer
?loop	lda FR0,x
		sta :buff,x
		dex
		bpl ?loop
		.endm
		; FP Divide FR0/FR1
FPDIV	.macro num, div, buff
		ldx #<:num
		ldy #>:num
		jsr FLD0R
		ldx #<:div
		ldy #>:div
		jsr FLD1R
		jsr FDIV
		ldx #5	; store FP in buffer
?loop	lda FR0,x
		sta :buff,x
		dex
		bpl ?loop
		.endm
		
		; ASCII to INT		 
A2FP		.MACRO string var	; ASCII number in string, result in var
         	LDA #<:string
         	STA INBUFF
         	LDA #>:string
         	STA INBUFF+1
         	LDA #0
         	STA CIX
         	JSR AFP		; ASCII 2 FP
         	JSR FPI		; FP 2 INT
         	LDA FR0		; result D4 and D5
         	STA :var
         	LDA FR0+1
         	STA :var+1         	
         	.ENDM 
         	
FPLD0	.MACRO number	; load user float into FR0
		lda #<:number
		sta FLPTR
		lda #>:number
		sta FLPTR+1
		jsr FLD0P
		.ENDM     
		
FPLD1	.MACRO number	; load user float into FR1
		lda #<:number
		sta FLPTR
		lda #>:number
		sta FLPTR+1
		jsr FLD1P
		.ENDM  		
		   
;  		Set system timer  
SETTIMER .MACRO timer hi lo vector
		.if :timer<1 .or :timer>5
			.error "Timer value out of range"
		.else
			.if :timer=3 .or :timer=4 .or :timer=5
			lda #$ff
		.endif
		.if :timer=3
			sta CDTMF3
		.endif
		.if :timer=4
			sta CDTMF4
		.endif
		.if :timer=5 
			sta CDTMF5
		.endif	 
		.endif			 
		.if :timer=1
			lda #<:vector
			sta CDTMA1
			lda #>:vector
			sta CDTMA1+1
		.endif
		.if :timer=2
			lda #<:vector
			sta CDTMA2
			lda #>:vector
			sta CDTMA2+1
		.endif
		lda #:timer
		ldx #:hi
		ldy #:lo
		JSR SETVBV
		.ENDM
		
checktimer .MACRO timer
		 .if :timer<1 .or :timer>5
		 	.error "Timer value out of range"
		 .else
			.if :timer=3 .or :timer=4 .or :timer=5
				.if :timer=3
c3					lda CDTMA3
					bmi	c3
				.endif
				.if :timer=4
c4					lda CDTMA4
					bmi C4
				.endif
				.if :timer=5
c5					lda CDTMA5
					bmi C5
				.endif	 
			.endif			 
		.endif
		.ENDM
		
	; macro to check if num1<num2 - do action based on result
	; either use passed in number which will be less that 255
	; or use address of variable passed in src		
lessthan 	.macro num1 num2 src dest 
		lda :num1+1	; check if num1 < num 2 16 bit compare
       		cmp  :num2+1	
        	bcc lower
        	bne higher
		lda :num1
		cmp :num2
		bcc lower
        	BRA higher	; >=
lower 	.if :src<256		; if src < 256 then it's not an address, use the number passed in
			MWA #:src :dest	;	
		.else	
			MWA :src :dest		; if scr >= 256 then it's an address
		.endif
higher					; continuation point for program
	.endm		
	; Modulus macro, not quick, but does work, 16 bit source, 8bit modulus
	; result in A
MODULUS	.MACRO NUM,NUM1,RESULT
LOOP LDA :NUM
         SEC 
         SBC :NUM1
         STA :NUM
         BCS LOOP
         LDA :NUM+1
         SBC #0
         STA :NUM+1
         BNE LOOP
LOOP1    LDA :NUM
         SEC 
         SBC :NUM1
         STA :NUM
         BCS LOOP1
         ADC :NUM1
;         STA :RESULT
;         RTS 
;NUM      .WORD $4000
;NUM1     .BYTE 48
;RESULT   .BYTE 0
		.ENDM		
DELAY	.MACRO time
		lda #<:time
		sta RTCLOK+2
		lda #>:time
		sta RTCLOK+1
		lda #0
		sta RTCLOK
wait		lda RTCLOK+1
		bne wait
wait1		lda RTCLOK+2
		bne wait1
		.ENDM
			opt l+