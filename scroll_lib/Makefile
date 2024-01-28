scroll:
	basicParser -f -b GR0SCR.TBA -o tmp/AUTORUN.BAS
	cp ../atr_images/TBXL.atr work.atr
	franny -A  -i tmp/AUTORUN.BAS -o AUTORUN.BAS work.atr
	atari800 -nobasic work.atr &
binary:
	mads scroll.asm -o:tmp/scroll.o
	od -t u1 tmp/scroll.o | sed -E 's/^\w+(\s|$$)/DATA /' > tmp/scroll.txt
	sed -i -E 's/([0-9]+)\s+/\1,/g' tmp/scroll.txt
	cat tmp/scroll.txt | tr -s '\t' ' ' > tmp/scroll.tba
	rm tmp/scroll.txt