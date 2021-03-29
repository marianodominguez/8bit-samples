    opt l+h+f-
    icl 'hardware.asm'

main equ $2000
scr equ $3010

    org main
    sei
    lda #0
    sta IRQEN
    sta NMIEN
    sta DMACTL
    cmp:rne VCOUNT
    mwa #dlist DLISTL
    mva #$22 DMACTL
    jmp *

dlist
    :2 dta $70
    dta $4E,a(scr)
    :101 dta $E
    dta $4E,a(scr+4096-16)
    :97 dta $E
    dta $41,a(dlist)

    org scr
    :8016 dta #&$FF
    run main
