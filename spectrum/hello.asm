    org $8000
    LD HL,Message
    CALL PrintString
    RET
Print:
    PUSH HL
    PUSH BC
    PUSH AF
    PUSH DE
    LD A,2
    CALL $1601
    POP AF
    PUSH AF
    RST 16
    POP AF
    POP DE
    POP BC
    POP HL
    RET
PrintString:
    LD A,(HL)
    CP 255
    RET Z
    INC HL
    CALL Print
    JR PrintString
    RET

Message: DB 'Hello World !!',255
