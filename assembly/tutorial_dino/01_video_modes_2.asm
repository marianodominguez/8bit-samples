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
COLCRS 	=   $55
ROWCRS 	=   $54

STOCOL =   $CD
ATACHR =   $02FB
XCORD =     $CE
YCORD =     $CF

  org $4000
  LDA #9 ; bitmapped graphics mode
  JSR MODE ;set graphics mode

  LDA #0
  STA YCORD
  LDA #0
  STA XCORD
  LDA #15
  STA STOCOL   ;color reg
plot_line:
  LDX XCORD
  LDY YCORD
  LDA #0
  JSR PLOT    ;call PLOT routine
  INC YCORD
  INC XCORD
  LDA XCORD
  CMP #160
  BNE plot_line
done:
  
loop:
    JMP loop

NAME   
    .BY "S:",$9B

; ******************************
; The MODE command
; ******************************

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