SAVMSC 	=	$58
MAXLEN 	=	100
  		org	$0600
strp    = $C0
offset  = $C2
asc		= $C4	

start 	
		lda SAVMSC
		sta asc
		lda SAVMSC+1
		sta asc+1

		lda #40
		sta offset
		ldx #<string
		ldy #>string
  		jsr print
 
  		lda #79
  		sta offset
  		ldx #<string1
		ldy #>string1
  		jsr print
pause 	jmp pause

print   lda SAVMSC
		adc offset
		sta asc
		stx strp
		sty strp+1
		ldy #0
prn		lda (strp),Y
		cmp #$9B
		beq pre
		sta (asc),Y
		iny
		cpy MAXLEN
		bne prn
pre		rts
string 	.byte $7C,"    This computer can't run Win11   ",$7C,$9B
string1 .byte $7C,"        Learn 6502 assembler        ",$7C,$9B 