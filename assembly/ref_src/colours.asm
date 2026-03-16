	ICL "header.h"
	ICL "mymacros.h"
zero=$cf
size=prgend-begin-1
	org $600
begin pla	
	lda #0
	sta NMIEN	; disable interrupt
	lda VVBLKI		; save vb jump address
	sta jp
	lda VVBLKI+1
	sta jp+1
	setvb st 6		; set immediate VBI
	lda #<mydl	; set DLI address
	sta VDSLST
	lda #>mydl
	sta VDSLST+1
	lda #%11100000	; DLI VBI RESET
	sta NMIEN	; restore interrupts
	rts
	
	; VB routine, just zero's counter for DLI
st	lda #0
	sta zero
	jmp (jp)	; jump to original vb routine
jp	.word 0	

	; DLI routine
mydl	pha
	txa
	pha
	ldx zero
	lda table,x
	sta wsync
	sta COLPF2
	inc zero
	pla
	tax
	pla
	rti
table .byte 4,20,36,52,68,84,100,116,132,148,164,180,196,212,228,244,148
prgend

