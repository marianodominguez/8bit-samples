SAVMSC 	=	$58

  org $4000
  LDA #2 ; big test mode
  JSR $EF9C ;graphics mode

  LDY #0
print:
  LDA msg,Y
  CMP #$FF
  BEQ done
  STA (SAVMSC),Y
  INY
  JMP print
done:
  
loop:
    JMP loop

msg
    .byte "Hello World!",$FF