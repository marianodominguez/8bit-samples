  ; ******************************
; CIO equates
; ******************************
ICCOM =    $0342
ICAX1 =    $034A
ICAX2 =    $034B
CIOV  =    $E456
ICBAL =    $0344
ICBAH =    $0345
ICBLL =    $0348
ICBLH =    $0349

; ******************************

; ******************************
; Other equates needed
; ******************************
COLCRS 	=   $55
ROWCRS 	=   $54
ATACHR 	=   $02FB

X   	=  $F0
Y   	=  $F1 
STOCOL 	=  $CD ;store color

  org $4000
  LDA #7+16 ; gr mode
  ;JSR $EF9C ;graphics mode
  JSR MODE

  LDA #1  ;color registry
  STA STOCOL ;color
  LDA #159
  STA X
  LDA #0
  STA Y
  
  LDA #0
  LDY #0
  LDX #0

loop
  LDA STOCOL
  ADC #1
  CMP #4
  BNE line
  LDA #0
  STA STOCOL
line 
  STA STOCOL
  LDA #0
  LDX #0
  LDY #0
  JSR PLOT ; set cursor
  LDX X
  LDY Y
  INY
  INY
  STY Y

  CPY #90
  BNE dr
  LDY #0
  STY Y
  LDA #0
  JMP LOOP
dr
  JSR DRAWTO
  JMP loop

MODE
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
;.END
