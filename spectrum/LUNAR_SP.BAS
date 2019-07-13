100 REM BASIC Month 4: Lunar Corps
110 REM http://reddit.com/r/RetroBattlestations
120 REM Original written by FozzTexx
130 REM ZX Spectrum version by papa_robot

200 REM Clear screen and setup variables
205 LET w=7: LET b=1: LET PEAK=0: LET T$="": LET o$="": LET cut=-1
210 BORDER 0: PAPER 0: INK w: CLS: RANDOMIZE:PRINT AT 21,0;"";
220 LET k$ = " /\\_"
230 LET COLS = 31: LET ROWS = 22

300 GO SUB 2510
310 LET YS = SQR(2) * SQR(ROWS - TL + zl) - 1
320 LET XE = INT( (ze - zs) / 2) + zs
330 LET XV = XE / YS: LET YV = 0
340 LET X = 1: LET Y = 1

400 GO SUB 2010:LET l$ = s$
410 GO SUB 2010:LET m$ = s$:LET a$ = n$
420 FOR I = 1 TO YS
430 LET s$ = a$: LET cut=3 : GO SUB 1510
440 LET YV = YV + 1
450 LET X = X + XV: LET Y = Y + YV
460 LET s$ = l$:IF I >= YS-2 THEN LET s$ = m$
470 LET cut = 3: GO SUB 1510
480 FOR J = 1 TO 40: NEXT J
490 NEXT I
500 LET s$ = a$:LET cut = 3:GO SUB 1510
510 LET X = (ze - zs) / 2 + zs - 1:LET Y = ROWS - TL + zl - 1
520 LET s$ = l$:GO SUB 1510
530 LET cut = -1: LET s$ = "The Eagle has landed":LET X = (COLS - LEN(s$)) / 2:LET Y = ROWS / 2:GO SUB 1510
540 LET cut = -1: LET s$ = "/u/papa_robot":LET X = (COLS - LEN(s$)) / 2:LET Y = 2:GO SUB 1510
550 LET cut = -1: LET s$ = "13-Jul-2019":LET X = (COLS - LEN(s$)) / 2:LET Y = 3:GO SUB 1510
998 IF INKEY$ = "" THEN GO TO 998
999 STOP

1500 REM Draw sprite in s$ at X,Y
1510 IF Y < 1 OR Y > ROWS OR X < 1 OR X > COLS THEN  RETURN
1512 LET of=0
1520 IF cut>0 THEN FOR j=1 TO LEN(s$) STEP cut: PRINT AT Y + of,X; s$(j TO j + cut-1);: LET of=of+1 : NEXT j:RETURN
1530 PRINT AT Y,X; s$;
1540 REM POKE 32,0
1550 RETURN

2000 REM Load a sprite from DATA into s$
2010 LET s$ = "":LET n$ = "":LET SR = 0:LET SC = 0
2020 READ T$,o$
2030 LET s$ = s$ + o$:LET SR = SR + 1:IF LEN(S$) > SC THEN LET SC = LEN(S$)
2040 LET b$ = "":FOR I = 1 TO LEN(S$):LET b$ = b$ + " ":NEXT I
2050 REM
2060 LET n$ = n$ + b$
2070 IF T$ <> "SE" THEN GO TO 2020
2080 RETURN

2500 REM Draw lunar surface
2510 LET DIDUP = 0:LET r$ = "":FOR I = 1 TO COLS + 4:LET r$ = r$ + " ": NEXT I
2520 LET zs = 0:LET ze = 0:LET TL = 0
2530 LET s$ = "  ":LET UP = DIDUP: IF NOT UP AND r$(3) <> " " THEN LET UP = 1
2540 IF NOT DIDUP AND UP THEN LET DIDUP = UP
2550 LET Z1 = 0:LET Z2 = 0
2560 FOR I = 3 TO COLS + 2:PRINT ".";CHR$(8);
2565 IF I+2> LEN(r$) THEN LET r$=r$ + " "
2570 LET C$ = s$(I-2):LET D$ = s$(I-1)
2580 LET E$ = r$(I-1):LET F$ = r$(I)
2590 LET G$ = r$(I+1):LET H$ = r$(I+2)
2600 IF PEAK = 0 AND r$(I-1 TO I+2) = "    " THEN LET PEAK = INT ( RND * 3 ): LET PEAK = PEAK + ( PEAK = 2 ): LET PEAK = PEAK * INT (RND * 2)
2610 IF D$ = "/" AND F$ = " " THEN LET PEAK = 2
2620 IF (C$ = "_" OR C$ = "\\") AND D$ = " " THEN LET PEAK = 0
2630 IF F$ <> " " THEN LET PEAK = 0
2640 IF (E$ = "\\" OR E$ = "_") AND F$ = " " THEN LET PEAK = 2
2650 IF D$ = "_" AND H$ = "/" THEN LET PEAK = 3
2660 IF (D$ = "\\" OR D$ = " " OR D$ = "_") AND F$ = " " AND (G$ = "_" OR G$ = "/") THEN LET PEAK = 1
2670 IF D$ = "\\" AND H$ <> " " THEN LET PEAK = 3
2680 IF (G$ = "/" OR G$ = "_") THEN LET PEAK = 1
2690 IF F$ <> " " THEN LET PEAK = 0
2700 IF UP AND PEAK <> 2 THEN LET PEAK = 0
2710 IF PEAK = 1 THEN LET UP = 1
2720 IF PEAK = 2 THEN LET UP = 0
2730 LET P$ = k$(PEAK + 1):PRINT P$;:LET s$ = s$ + P$
2740 IF PEAK = 3 AND NOT Z1 THEN LET Z1 = I
2750 IF PEAK <> 3 AND D$ = "_" THEN LET Z2 = I
2760 IF Z1 AND Z2 THEN LET Z3 = Z1:LET Z4 = Z2:LET Z1 = 0:LET Z2 = 0:IF (Z4 - Z3) >= 3 AND Z3 > zs THEN LET zs = Z3:LET ze = Z4:LET zl = TL
2770 IF PEAK <> 3 OR (C$ = "_" AND D$ = "_") THEN LET PEAK = 0
2780 NEXT I
2790 LET r$ = s$
2800 LET C2 = 0
2810 FOR I = 3 TO COLS + 2
2820 IF r$(I) = " " THEN LET C2 = C2 + 1
2830 NEXT I
2840 LET TL = TL + 1
2845 POKE 23692,5
2850 IF C2 < COLS THEN PRINT:GOTO 2530
2860 LET zs = zs - 4:LET ze = ze - 4: RETURN

9000 DATA "SP","(I)"
9010 DATA "SE","/T\\"
9020 DATA "SP","(I)"
9030 DATA "SP","/T\\"
9040 DATA "SE"," V "
