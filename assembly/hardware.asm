; GTIA Write
HPOSP0  = $d000
HPOSP1  = $d001
HPOSP2  = $d002
HPOSP3  = $d003
HPOSM0  = $d004
HPOSM1  = $d005
HPOSM2  = $d006
HPOSM3  = $d007
SIZEP0  = $d008
SIZEP1  = $d009
SIZEP2  = $d00a
SIZEP3  = $d00b
SIZEM   = $d00c
GRAFP0  = $d00d
GRAFP1  = $d00e
GRAFP2  = $d00f
GRAFP3  = $d010
GRAFM   = $d011
COLPM0  = $d012
COLPM1  = $d013
COLPM2  = $d014
COLPM3  = $d015
COLPF0  = $d016
COLPF1  = $d017
COLPF2  = $d018
COLPF3  = $d019
COLBK   = $d01a
PRIOR   = $d01b
VDELAY  = $d01c
GRACTL  = $d01d
HITCLR  = $d01e
CONSOL  = $d01f

; GTIA Read
M0PF    = $d000
M1PF    = $d001
M2PF    = $d002
M3PF    = $d003
P0PF    = $d004
P1PF    = $d005
P2PF    = $d006
P3PF    = $d007
M0PL    = $d008
M1PL    = $d009
M2PL    = $d00a
M3PL    = $d00b
P0PL    = $d00c
P1PL    = $d00d
P2PL    = $d00e
P3PL    = $d00f
TRIG0   = $d010
TRIG1   = $d011
TRIG2   = $d012
TRIG3   = $d013
PAL     = $d014

; POKEY Write
AUDF1   = $d200
AUDC1   = $d201
AUDF2   = $d202
AUDC2   = $d203
AUDF3   = $d204
AUDC3   = $d205
AUDF4   = $d206
AUDC4   = $d207
;AUDCTL  = $d208
STIMER  = $d209
SKREST  = $d20a
POTGO   = $d20b
SEROUT  = $d20d
IRQEN   = $d20e
SKCTL   = $d20f

; POKEY Read
POT0    = $d200
POT1    = $d201
POT2    = $d202
POT3    = $d203
POT4    = $d204
POT5    = $d205
POT6    = $d206
POT7    = $d207
ALLPOT  = $d208
KBCODE  = $d209
RANDOM  = $d20a
SERIN   = $d20d
IRQST   = $d20e
SKSTAT  = $d20f

; PIA
PORTA   = $d300
PORTB   = $d301
PACTL   = $d302
PBCTL   = $d303

; ANTIC
DMACTL  = $d400
CHACTL  = $d401
DLISTL  = $d402
DLISTH  = $d403
HSCROL  = $d404
VSCROL  = $d405
PMBASE  = $d407
CHBASE  = $d409
WSYNC   = $d40a
VCOUNT  = $d40b ; Read
PENH    = $d40c ; Read
PENV    = $d40d ; Read
NMIEN   = $d40e
NMIRES  = $d40f ; Write
NMIST   = $d40f ; Read

; ROM
STDCH	= $e000
SAVMSC 	=	$58

; CIO equates
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



