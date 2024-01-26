;Program 4: VBI Routine
;Source Code
; original: http://archive.org/stream/1985-12-compute-magazine/Compute_Issue_067_1985_Dec#page/n0/mode/2up

; VBI rautine
; for combined fine and
; coarse scrolling
; in graphics mode 0.
;
; Change the 1 in line
; 25 to scroll slower,
; Change the 7 in line
; 33 to the number of scan lines
;per mode line minus 1 far other graphics modes 
;Change the 40 in line 39 to the number of jbytes per mode line f
;or other graphics modes

    ORG $0600   ;Load into page 6.
    PLA         ;Remove argument count.
    LDY #10     ;These 4 statements set up
    LDX #6      ;a deferred vertical blank
    LDA #7      ;inter rupt - use LDA #6 -for
    JMP $E45C   ;an immediate VBI.
    INC ICB     ;SCB is counter for number of
    LDA #1      ;VB cycles before next scroll.
    CMP $CB     ;If not up to desired interval
    BNE EXIT    ;then exit VBI
    INC $CC     ;*CC is counter for number
    LDA $CC     ;of fine scrolls.
    STA $D405   ;Storein vertical fine scroil register.
    LDA #0      ;reset VB counter
    STA $CB
    LDA #7      ;Have We done y fine
    CMP $CC     ;scrolls yet?
    BCS EXIT    ;No, exit VBI.
    LDA #0      ; Yes,
    STA $D405   ;reset vertical scroll register,
    STA $CC     ;reset scroll counter,
    LDA #40     ; and Coarse scroll by
    LDY #4      ;adding 40 to low byte
    CLC         ;of screen memory pointer.
    ADC ($CD),Y
    STA ($CD) ,Y
    BCC EXIT ; If carry not set then exit VBI ,
    INY ;else increment high byte
    LDA #0 ;of screen memory pointer.
    ADC ($CD),Y
    STA ($CD),Y
EXIT: JMP $E462