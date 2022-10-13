
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

xcord   =  $C0
ycord   =  $C1 
i		=  $C2
tmp		=  $C3
len		=  $C4
 
XMAX	=	160
YMAX	=	96

  ORG  	$0600
  LDA	#7+16
  JSR	GRAFIC
  
  LDA #0
  STA i
mainl
  LDA #1
  STA STOCOL
  JSR DRWPLY
  JSR delay
  LDA #0
  STA STOCOL
  JSR DRWPLY
  LDX #5
  LDY #3
  JSR TRANS
  LDA i
  ADC #1
  STA i
  CMP #60
  BMI mainl
wait
  JMP wait

delay
  DEY
  BNE delay 
  RTS


; **********
; Translation tranfomation in place
; registers x and y hold the maginitude
; TODO: support negative traslation (signed)

TRANS
  STX xcord
  STY ycord
  LDX #0
  LDA V,X
  STA len
  INX
  CLC
lt
  CPX len
  BEQ endt
  BPL endt
  LDA V,X
  ADC xcord
  BCS endt
  STA V,X
  INX
  LDA V,X
  ADC ycord
  BCS endt
  STA V,X
  INX
  JMP lt
endt
  CLC
  RTS

;Draw a poligon stored in v pointer, end with FF
;Format x1,y1,x2,y2,..,$ff

DRWPLY
; read vertices  
  LDX #0
  LDY #$FF
  LDA V,X ; get array length
  STA len
  INX
loop
  CPX len
  BEQ endv
  BPL endv
  LDA V,X
  STA xcord
  INX
  LDA V,X
  STA ycord
  INX
  STX tmp ;save index to use x for point cord
  LDA #0
  CPY #$FF ;todo, this breaks in gr 8
  BNE line
  LDX xcord
  CPX #XMAX ; do not draw out of screen
  BEQ endv
  BPL endv
  LDY ycord
  CPX #YMAX ; do not draw out of screen
  BEQ endv
  BPL endv
  JSR PLOT
  JMP cont
  LDY #00
line
  LDX xcord
  LDY ycord
  JSR DRAWTO
cont
  LDX tmp
  JMP loop  
endv 
  RTS

V	.BY 10,0,0,0,20,20,20,20,0,0,0

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
