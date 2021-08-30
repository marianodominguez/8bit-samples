
    org $4000 ;Start of code 
	icl "SystemEquates.asm"
	icl "graph_macros.asm"

cc=$F1
	
start graphics #2
	  print message, #10, #10
	  ;LDA #0 ;Disable screen DMA 
      ;STA SDMCTL
	  LDA #0
	  LDY #0
	  STA cc	  
loop  LDA VCOUNT ;Load VCOUNT
      CLC
      ADC cc ;Add counter
      STY cc
	  INY
st    STA WSYNC 
      STA COLOR0 ;Change FG color
      STA COLOR2 ;Change win 
      JMP loop 
  		
message .byte $0,$40,"Hello 6502 World !  ",$40,$9B
 		.byte "please terminate your strings with $9B",$9B
 		 run start ;Define run address