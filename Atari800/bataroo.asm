RAMTOP 	= $6A
PMBASE  = $d407
GRACTL  = $d01d
SDMCTL  = $22f
HPOSP0 	= $D000
		
p0addr	= $f0
		
		ORG $0600
start	LDX #0
		LDA #0
		JSR setup
wait	JMP wait
		
setup	LDA RAMTOP
		SBC #8
		STA PMBASE
		STA p0addr+1
		LDA #0
		STA p0addr
		LDA #3
		STA GRACTL
		LDA #46
		STA SDMCTL
		LDA #100
		STA HPOSP0
		LDA #0
		LDX #0
clear	STA p0addr
		RTS
		END	