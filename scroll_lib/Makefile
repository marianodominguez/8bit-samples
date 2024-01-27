scroll:
	tr '\12\11' '\233\177' < GR0SCR.TBA > GR0SCR.LST
	cp ../atr_images/blank_SD.atr work.atr
	franny -A  -i GR0SCR.LST -o WORK.LST work.atr
	atari800 -nobasic ../atr_images/TBXL.atr work.atr &
	sleep 5
	xdotool type -delay 200 'E."D2:WORK.LST'
	xdotool key Return
binary:
	mads scroll.asm -o:tmp/scroll.o
	od -t u1 tmp/scroll.o | sed -E 's/^\w+(\s|$\)/DATA /' > tmp/scroll.txt
	sed -i -E 's/([0-9]+)\s+/\1,/g' tmp/scroll.txt
	nl -v 2000 -i 10 tmp/scroll.txt > tmp/scroll.tba
	rm tmp/scroll.txt