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
  LDA #7 ; gr mode
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

loop LDA Y 
  LDX STOCOL
  INX
  CPX #4
  BNE line
  LDX #0
line 
  STX STOCOL
  LDX #10 ;x
  LDY #10 ;y
  LDA STOCOL
  JSR PLOT ; set cursor
  LDY Y
  INY
  INY
  CPY #90
  BNE dr
  LDY #0
dr
  STY Y
  LDX X
  JSR DRAWTO
  JMP loop

PLOT
   JSR $F1D8 ;call OS PLOT
   JSR POSITN    ; To store info
   LDX #$60      ; For the screen
   LDA #0        ; Special case of
   STA ICBLL,X   ;  I/O using the
   STA ICBLH,X   ;  accumulator
   LDA STOCOL    ; Get COLOR to use


POSITN
  	STX COLCRS    ; Low byte of X
  	STY ROWCRS    ; Y position
  	RTS           ; All done

DRAWTO
	 JSR POSITN    ; To store info
	 LDA STOCOL       ; Get COLOR
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

MODE
   	PHA
	LDX #$60      ; The screen again
   	LDA #NAME&255 ; Name is "S:"
   	STA ICBAL,X   ; Low byte
   	LDA #NAME/256 ; High byte
   	STA ICBAH,X
   	PLA
   	JSR $EF9C
   	LDA #0
   	STA COLCRS+1   ;this is mode <8 
	RTS
 
NAME   .BY "S:",$9B
;.END
