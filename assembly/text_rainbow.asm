SETVBV = $E45C  ; OS routine to set VBI vector

    org $4000 ;Start of code 
	icl "SystemEquates.asm"
	icl "graph_macros.asm"

cc=$F1

		; Install the VBI routine at the OS vector
start 
 	  graphics #2
	  print message, #10, #10
	  ;LDA #0 ;Disable screen DMA 
      ;STA SDMCTL
	  LDA #0
	  LDY #0
	  STA cc
	  LDA #$07
	  LDX #>color_vbi
	  LDY #<color_vbi
	  JSR SETVBV	  
loop  
      JMP loop

color_vbi
	  LDA VCOUNT ;Load VCOUNT
	  CLC
      ADC cc ;Add counter
      INC cc
	  STA WSYNC 
      STA COLOR0 ;Change FG color
      STA COLOR2 ;Change win 
	  JMP XITVBV

message .byte $0,$40,"Hello 6502 World !  ",$40,$9B
 		.byte "please terminate your strings with $9B",$9B
 	  RUN start ;Define run address
	  END