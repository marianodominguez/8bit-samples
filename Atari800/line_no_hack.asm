
; ******************************
; CIO equates
; ******************************
ICHID =    $0340
ICDNO =    $0341
ICCOM =    $0342
ICSTA =    $0343
ICBAL =    $0344
ICBAH =    $0345
ICPTL =    $0346
ICPTH =    $0347
ICBLL =    $0348
ICBLH =    $0349
ICAX1 =    $034A
ICAX2 =    $034B
CIOV  =    $E456
; ******************************
; Other equates needed
; ******************************
COLOR0 =   $02C4
COLCRS =   $55
ROWCRS =   $54
ATACHR =   $02FB
STORE1 =   $CC
STOCOL =   $CD

X   	=  $F0
Y   	=  $F1 

XMAX=48
YMAX=48

  ORG  	$400
  LDA #5+16; gr mode
  JSR GRAFIC

  LDA #1  ;color registry
  STA STOCOL ;color
  LDA #0
  STA X
  STA Y
  
loop
  LDX STOCOL
  INX
  CPX #4
  BMI line
  LDX #0
line 
  STX STOCOL
  LDX X
  INX
  CPX #XMAX-1
  BMI rx
  LDX #0
  STX STOCOL
rx
  STX X
  LDY #0
  LDA #0
  JSR PLOT ; set cursor
  LDY Y
  INY
  CPY #YMAX-1
  BMI ry
  LDY #0
  STY STOCOL
ry
  STY Y
dr
  LDA #0
  LDX #XMAX-1
  LDY Y
  JSR DRAWTO
  LDY #0
  JMP loop	

GRAFIC
       PHA           ; Store on stack
       LDX #$60      ; IOCB6 for screen
       LDA #$C       ; CLOSE command
       STA ICCOM,X   ; in command byte
       JSR CIOV      ; Do the CLOSE
       LDX #$60      ; The screen again
       LDA #3        ; OPEN command
       STA ICCOM,X   ; in command byte
       LDA #NAME&255 ; Name is "S:"
       STA ICBAL,X   ; Low byte
       LDA #NAME/256 ; High byte
       STA ICBAH,X
       PLA           ; Get GRAPHICS n
       STA ICAX2,X   ; Graphics mode
       AND #$F0      ; Get high 4 bits
       EOR #$10      ; Flip high bit
       ORA #$C       ; Read or write
       STA ICAX1,X   ; n+16, n+32 etc.
       JSR CIOV      ; Setup GRAPHICS n
       RTS           ; All done
; ******************************
; The POSITION command
; ******************************
POSITN
       STX COLCRS    ; Low byte of X
       STA COLCRS+1  ; High byte of X
       STY ROWCRS    ; Y position
       RTS           ; All done
; ******************************
; The PLOT command
; ******************************
PLOT
       JSR POSITN    ; To store info
       LDX #$60      ; For the screen
       LDA #$B       ; Put record
       STA ICCOM,X   ; Command byte
       LDA #0        ; Special case of
       STA ICBLL,X   ;  I/O using the
       STA ICBLH,X   ;  accumulator
       LDA STOCOL    ; Get COLOR to use
       JSR CIOV      ; Plot the point
       RTS           ; All done
; ******************************
; The DRAWTO command
; ******************************
DRAWTO
       JSR POSITN    ; To store info
       LDA STOCOL    ; Get COLOR
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

NAME   .BY "S:",$9B
