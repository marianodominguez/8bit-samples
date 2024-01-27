  org $4000
  
 ;user variables
 x=$c0 ;current x coord
 y=$c1 ; current y coord
 yadj=$c2 ;adjusted y for using double vert pixels
 
 ; system labels
 OSGRAPH=$EF9C  ; Graphics mode
 OSPLOT=$F1D8   ; plot a pixel
 ROWCRS=84      ; cursor coordinates
 COLCRS=85
 
  LDA #9    ;gr mode
  JSR OSGRAPH ;graphics 9
  
  LDA #0
  LDY #0
  STA x
  STA y
  STA yadj
  
loop
  LDA y 
  STA ROWCRS ;row
  LDA x
  STA COLCRS ;col low
  
  LDA y
  LDX #2
  SEC
d INX
  SBC #2
  BCS d
  STX yadj
  
  LDA x ; color = x xor y/2
  EOR yadj
  JSR mod
  TAY
  
N STY 763   ;color reg
C JSR OSPLOT ;call OS PLOT
  JSR Xloop
  LDA Y
  CMP #192
  BEQ reset
  JMP loop
reset
  LDA #0
  JSR OSGRAPH
wait JMP wait

Xloop
  LDX x
  INX
  STX x
  CPX #80
  BNE exit
Yloop
  LDY #0
  STY x
  LDY y
  INY
  STY y
exit
  RTS

; return accumulator modulo 15 by subtracting
mod
  CMP #15
  BMI endmod 
  SBC #15
  JMP mod
endmod
  RTS
  
;.END
