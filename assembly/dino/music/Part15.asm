;
; RASTER Music Tracker Modules
;
; http://raster.infos.cz/atari/rmt/rmt.htm#download
;
; C:\jac\wudsn\Tools\ASM\MADS\examples\players\rmt_player_relocator


rtclok	= $12
vcount	= $d40b

	org $2400

	.proc music
STEREOMODE	equ 0				;0 => compile RMTplayer for mono 4 tracks
init_song = RASTERMUSICTRACKER+0
play	  = RASTERMUSICTRACKER+3

	icl "music.feat"

player
	icl "rmt_player.asm"			;include RMT player routine
	
	icl 'rmt_relocator.asm'	

module
	rmt_relocator 'music.rmt' module	;include music RMT module
	
	.endp

	.proc main
	
	ldx #<music.module
	ldy #>music.module
	lda #0
	jsr music.init_song
	
main_loop
	jsr wait
	mva #$34 $d01a
	jsr music.play
	mva #$00 $d01a

	jmp main_loop
	
	.proc wait
loop	lda vcount
	cmp #$20
	bne loop
	rts
	.endp

	.endp
	
	run main
