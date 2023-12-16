
mask:
m03:		.byte $03
m0c:		.byte $0c
m30:		.byte $30
mc0:		.byte $c0

m0f:		.byte $0f
m3c:		.byte	$3c
m3f:		.byte	$3f
mf0:		.byte $f0
mfc:		.byte $fc
mff:		.byte $ff

.macro  sub addr
		sec
		sbc addr
.endmacro

.macro  add addr
		clc
		adc addr
.endmacro


.proc PutPixel
		;start position
		lDY Y1

    	jsr find_row
    	jsr find_col

		;byte x offset
		lda X1
		lsr
		lsr
		tay

		;mask - count 3,2,1,0
		lda X1
		and #3
		eor #3
		tax

		;put pixel
		lda (PIXLO),y
		ora mask,x
		sta (PIXLO),y

		rts
.endproc

;------------------------------------

.proc Line
		lda X2
		cmp X1

		;X1=X2 -> check putpixel
		beq L_putpixel
		;X1<X2 -> draw lone
		bcs l_line
		;X2>X1 -> swap and draw line
		bcc L_swap

L_putpixel:
		lda Y2
		cmp Y1
		;Y1=Y2 -> PutPixel
		beq PutPixel
		;draw vertical line
		bne l_line

L_swap:
		tax
		lda X1
		sta X2
		txa
		sta X1

		lda Y2
		tax
		lda Y1
		sta Y2
		txa
		sta Y1

l_line:
		;DX
		lda X2
		sub X1
		sta DX

		;start PIXLO
		lDY Y1

    	jsr find_row
    	jsr find_col

		;byte x offset
		lda X1
		lsr
		lsr
		tay

		;mask - count 3,2,1,0
		lda X1
		and #3
		eor #3
		tax

		;DY
		lda Y2
		sub Y1
		sta DY

		;jcc L34
		bcs nojump
		jmp L34
nojump:

		;dxy = dx-DY
		lda DX
		sub DY
		sta dxy

		bcc L2

L1:
		;pixel count
		lda DX
		add #1
		sta pixcnt

		;q = (dx-1)/2 - DY
		lda DX
		sub #1
		lsr
		sub DY
		sta q

		; q>=0 -> L2b
		bcs L1b

L1a:	;move right and down

		;draw pixel
		lda (PIXLO),y
		ora mask,x
		sta (PIXLO),y

		;quit
		dec pixcnt
		beq l1_out

		;move mask right
		dex
		bpl l1a2

		;move to next byte
		ldx #3

		iny
		bne l1a2
		inc PIXLO+1
		bne l1a2

l1a2:
		;move down
		tya
		add #40
		tay
		bcc skip3
		inc PIXLO+1
skip3:
		;advance q
		lda q
		add dxy
		sta q

		;q<0 -> L1a
		;q>0 -> Llb
		bcc L1a

L1b:	;move right only

		;draw pixel
		lda (PIXLO),y
		ora mask,x
		sta (PIXLO),y

		;quit
		dec pixcnt
		beq l1_out

		;move mask right
		dex
		bpl l1b2

		;move to next byte
		ldx #3

		iny
		bne l1b2
		inc PIXLO+1
		bne l1b2

l1b2:
		;advance q
		lda q
		sub DY
		sta q

		;q<0 -> L1a
		;q>0 -> L1b
		bcc L1a
		bcs L1b

l1_out:
		rts

L2:
		;pixel count
		lda DY
		add #1
		sta pixcnt

		;q = (DY-1)/2-DX
		lda DY
		sub #1
		lsr
		sub DX
		sta q

		; q>=0 -> L2b
		bcs L2b

L2a:		;move right and down

		;draw pixel
		lda (PIXLO),y
		ora mask,x
		sta (PIXLO),y

		;quit
		dec pixcnt
		beq L2_out

		;move mask right
		dex
		bpl L2a2

		;move to next byte
		ldx #3

		iny
		bne L2a2
		inc PIXLO+1
		bne L2a2

L2a2:
		;move down
		tya
		add #40
		tay
		bcc skip
		inc PIXLO+1
skip:
		;advance q
		lda q
		sub dxy
		sta q

		;q<0 -> L2a
		bcc L2a

L2b:		;move down only

		;draw pixel
		lda (PIXLO),y
		ora mask,x
		sta (PIXLO),y

		;quit
		dec pixcnt
		beq L2_out

		;move down
		tya
		add #40
		tay
		bcc skip2
		inc PIXLO+1
skip2:
		;advance q
		lda q
		sub DX
		sta q

		;q<0 -> L2a
		;q>=0 -> L2b
		bcc L2a
		bcs L2b

L2_out:
		rts

L34:
		;invert DY
		lda Y1
		sub Y2
		sta DY

		;dxy = dx-DY
		lda DX
		sub DY
		sta dxy

		;decide variant
		;dx >= DY -> l4
		bcc L4

L3:
		;pixel count
		lda DX
		add #1
		sta pixcnt

		;q = (dx-1)/2 - DY
		lda DX
		sub #1
		lsr
		sub DY
		sta q

		; q>=0 -> L3b
		bcs L3b

L3a:		;move right and up

		;draw pixel
		lda (PIXLO),y
		ora mask,x
		sta (PIXLO),y

		;quit
		dec pixcnt
		beq L3_out

		;move mask right
		dex
		bpl L3a2

		;move to next byte
		ldx #3

		iny
		bne L3a2
		inc PIXLO+1
		bne L3a2

L3a2:
		;move up
		tya
		sub #40
		tay
		bcs skip4
		dec PIXLO+1
skip4:
		;advance q
		lda q
		add dxy
		sta q

		;q<0 -> L3a
		;q>0 -> L3b
		bcc L3a

L3b:		;move right only

		;draw pixel
		lda (PIXLO),y
		ora mask,x
		sta (PIXLO),y

		;quit
		dec pixcnt
		beq L3_out

		;move mask right
		dex
		bpl L3b2

		;move to next byte
		ldx #3

		iny
		bne L3b2
		inc PIXLO+1
		bne L3b2

L3b2:
		;advance q
		lda q
		sub DY
		sta q

		;q<0 -> L3a
		;q>0 -> L3b
		bcc L3a
		bcs L3b

L3_out:
		rts

L4:
		;pixel count
		lda DY
		add #1
		sta pixcnt

		;q = (DY-1)/2-DX
		lda DY
		sub #1
		lsr
		sub DX
		sta q

		; q>=0 -> L4b
		bcs L4b

L4a:		;move right and up

		;draw pixel
		lda (PIXLO),y
		ora mask,x
		sta (PIXLO),y

		;quit
		dec pixcnt
		beq L4_out

		;move mask right
		dex
		bpl L4a2

		;move to next byte
		ldx #3

		iny
		bne L4a2
		inc PIXLO+1
		bne L4a2

L4a2:
		;move up
		tya
		sub #40
		tay
		bcs skip5
		dec PIXLO+1
skip5:
		;advance q
		lda q
		sub dxy
		sta q

		;q<0 -> L4a
		;q>=0 -> L4b
		bcc L4a

L4b:		;move up only

		;draw pixel
		lda (PIXLO),y
		ora mask,x
		sta (PIXLO),y

		;quit
		dec pixcnt
		beq L4_out

		;move up
		tya
		sub #40
		tay
		bcs skip6
		dec PIXLO+1
skip6:

		;advance q
		lda q
		sub DX
		sta q

		;q<0 -> L4a
		;q>=0 -> L4b
		bcc L4a
		bcs L4b

L4_out:
		rts

.endproc

