  org $4000
  LDA #7 ; gr mode
  JSR $EF9C ;graphics mode
  X   =  $F0
  Y   =  $F1 
  col =  $CD ;store color

  LDA #1  ;color registry
  STA col ;color
  
  LDA #0
  LDY #0
  STA X 
  STA Y 

loop LDA Y 
  LDA #0
  LDX #10 ;x
  LDY #10 ;y
  JSR POSITN ; set cursor
  LDX #100
  LDY #50
  JSR DRAWTO
  JMP loop

POSITN
STX COLCRS    ; Low byte of X
STA COLCRS+1  ; High byte of X
STY ROWCRS    ; Y position
RTS           ; All done

DRAWTO
 JSR POSITN    ; To store info
 LDA col    ; Get COLOR
 STA ATACHR    ; Keep CIO happy
 LDX #$60      ; The screen again
 LDA #$11      ; For DRAWTO
 STA ICCOM,X   ; Command byte
 LDA #$C       ; As in XIO
 STA ICAX1,X   ; Auxiliary 1
 LDA #0        ; Clear
 STA ICAX2,X   ; Auxiliary 2
 JSR CIOV      ; Draw the line
 RTS           ; All done

;.END
