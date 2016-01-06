; WUDSN IDE Atari Rainbow Example, add labels
SDMCTL = $022F ;Disable screen DMA 
VCOUNT = $D40B
WSYNC  = $D40A
COLOR4 = $D01A

      ORG $4000 ;Start of code 

start LDA #0 ;Disable screen DMA 
      STA SDMCTL
loop  LDA VCOUNT ;Load VCOUNT 
      CLC 
      ADC 20 ;Add counter 
      STA WSYNC 
      STA COLOR4 ;Change background color 
      JMP loop 

      run start ;Define run address