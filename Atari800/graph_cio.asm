
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
       *=  $600
; ******************************
; The SETCOLOR routine
; ******************************
; Before calling this routine,
; the registers should be set
; just like the BASIC SETCOLOR:
; SETCOLOR color,hue,luminance
;    stored respectively in
;   X reg.,accumulator,Y reg.
SETCOL
       ASL A         ; Need to multiply
       ASL A         ; hue by 16, and
       ASL A         ; add it to lumimance.
       ASL A         ; Now hue is * 16
       STA STORE1    ; temporarily
       TYA           ; So we can add
       CLC           ; Before adding
       ADC STORE1    ; Now have sum
       STA COLOR0,X  ; Actual SETCOLOR
       RTS           ; All done
; ******************************
; The COLOR command
; ******************************
; For these routines, we will
; simply store the current COLOR
; in STOCOL, so the COLOR
; command simply requires that
; the accumulator hold the value
; "n" in the command COLOR n
COLOR
       STA STOCOL    ; That's it!
       RTS           ; All done
; ******************************
; The GRAPHICS command
; ******************************
; The "n" parameter of
; a GRAPHICS n command will be
; passed to this routine in the
; accumulator
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
; Identical to the BASIC
; POSITION X,Y command.
; Since X may be greater than
; 255 in GRAPHICS 8, we need to
; use the accumulator for the
; high byte of X.
POSITN
       STX COLCRS    ; Low byte of X
       STA COLCRS+1  ; High byte of X
       STY ROWCRS    ; Y position
       RTS           ; All done
; ******************************
; The PLOT command
; ******************************
; We'll use the X,Y, and A just
; like in the POSITION command.
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
; We'll use the X,Y, and A just
; like in the POSITION command
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
; ******************************
; The FILL command
; ******************************
; We'll use the X,Y, and A just
; like in the POSITION command.
; This is similar to DRAWTO
FILL
       JSR POSITN    ; To store info
       LDA STOCOL    ; Get COLOR
       STA ATACHR    ; Keep CIO happy
       LDX #$60      ; The screen again
       LDA #$12      ; For FILL
       STA ICCOM,X   ; Command byte
       LDA #$C       ; As in XIO
       STA ICAX1,X   ; Auxiliary 1
       LDA #0        ; Clear
       STA ICAX2,X   ; Auxiliary 2
       JSR CIOV      ; FILL the area
       RTS           ; All done
; ******************************
; The LOCATE command
; ******************************
; We'll use the X,Y, and A just
; like in the POSITION command
; and the accumulator will
; contain the LOCATEd color
LOCATE
       JSR POSITN    ; To store info
       LDX #$60      ; The screen again
       LDA #7        ; Get record
       STA ICCOM,X   ; Command byte
       LDA #0        ; Special case of
       STA ICBLL,X   ; data transfer
       STA ICBLH,X   ; in accumulator
       JSR CIOV      ; Do the LOCATE
       RTS           ; All done
; ******************************
; The screen's name
; ******************************
NAME   .BYTE "S:",$9B

