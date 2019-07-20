100   REM BASIC Month 4: Lunar Corps
110   REM http://reddit.com/r/RetroBattlestations
120   REM written by FozzTexx
125   REM Atari ST version by papa_robot
200   REM Clear screen and setup variables
210   fullw 2:clearw 2:gotoxy 0,20
220   PEAKS$ = " /\_"
230   COLS = 69:ROWS = 20:cut =0
300   GOSUB DRlunar
310   YS = SQR(2) * SQR(ROWS - TL + ZL) - 1
320   XE = INT((ZE - ZS) / 2) + ZS
330   XV = XE / YS:YV = 0
340   X = 1:Y = 1
400   GOSUB 2010:LM$ = SP$
410   GOSUB 2010:ML$ = SP$:LE$ = SE$
420   FOR I = 1 TO YS
430   SP$ = LE$:cut =3:GOSUB 1510
440   YV = YV + 1
450   X = X + XV:Y = Y + YV
460   SP$ = LM$:IF I >= YS-2 THEN SP$ = ML$
470   cut =3: GOSUB 1510
480   FOR J = 1 TO 400:NEXT J
490   NEXT I
500   cut=3: SP$ = LE$:GOSUB 1510
510   X = (ZE - ZS) / 2 + ZS - 1:Y = ROWS - TL + ZL - 1
520   cut=3: SP$ = LM$:GOSUB 1510
530   cut=-1:SP$="The Eagle has landed":X=(COLS-LEN(SP$))/2:Y=ROWS/2:GOSUB 1510
999   END
1500  REM Draw sprite in SP$ at X,Y
1510  IF Y < 1 OR Y > ROWS OR X < 1 OR X > COLS THEN  RETURN 
1515  if cut>0 then gosub Multiln:return
1525  gotoxy X,Y:print SP$
1550  RETURN
1560  Multiln: for j=1 to len(SP$) step cut
1565  gotoxy X,Y:print MID$(SP$,j,cut);
1570  next j
1580  return
2000  REM Load a sprite from DATA into SP$
2010  SP$ = "":SE$ = "":SR = 0:SC = 0
2020  READ T$,S$
2030  SP$ = SP$ + S$:SR = SR + 1:IF LEN(S$) > SC THEN SC = LEN(S$)
2040  BL$ = "":FOR I = 1 TO LEN(S$):BL$ = BL$ + " ":NEXT I
2060  SE$ = SE$ + BL$
2070  IF T$ <> "SE" THEN GOTO 2020
2080  RETURN
2500  REM Draw lunar surface
2510  DRLunar:DIDUP = 0:L1$ = "":FOR I = 1 TO COLS + 4:L1$ = L1$ + " ":NEXT I
2520  ZS = 0:ZE = 0:TL = 0
2530  L2$ = "  ":UP = DIDUP: IF NOT UP AND MID$(L1$, 3, 1) <> " " THEN UP = 1
2540  IF NOT DIDUP AND UP THEN DIDUP = UP
2550  Z1 = 0:Z2 = 0
2560  FOR I = 3 TO COLS + 2:PRINT "";
2570  C1$ = MID$(L2$, I-2, 1):C2$ = MID$(L2$, I-1, 1)
2580  C3$ = MID$(L1$, I-1, 1):C4$ = MID$(L1$, I, 1)
2590  C5$ = MID$(L1$, I+1, 1):C6$ = MID$(L1$, I+2, 1)
2600  IF PEAK = 0 AND MID$(L1$, I-1, 4) = "    " THEN PEAK = INT(RND(1) * 3):PEAK = PEAK + (PEAK = 2):PEAK = PEAK * INT(RND(1) * 2)
2610  IF  C2$ = "/" AND C4$ = " " THEN PEAK = 2
2620  IF (C1$ = "_" OR C1$ = "\") AND C2$ = " " THEN PEAK = 0
2630  IF C4$ <> " " THEN PEAK = 0
2640  IF (C3$ = "\" OR C3$ = "_") AND C4$ = " " THEN PEAK = 2
2650  IF C2$ = "_" AND C6$ = "/" THEN PEAK = 3
2660  IF (C2$ = "\" OR C2$ = " " OR C2$ = "_") AND C4$ = " " AND (C5$ = "_" OR C5$ = "/") THEN PEAK = 1
2670  IF C2$ = "\" AND C6$ <> " " THEN PEAK = 3
2680  IF (C5$ = "/" OR C5$ = "_") THEN PEAK = 1
2690  IF C4$ <> " " THEN PEAK = 0
2700  IF UP AND PEAK <> 2 THEN PEAK = 0
2710  IF PEAK = 1 THEN UP = 1
2720  IF PEAK = 2 THEN UP = 0
2730  P$ = MID$(PEAKS$, PEAK + 1, 1):PRINT P$;:L2$ = L2$ + P$
2740  IF PEAK = 3 AND NOT Z1 THEN Z1 = I
2750  IF PEAK <> 3 AND C2$ = "_" THEN Z2 = I
2760  IF Z1 AND Z2 THEN Z3 = Z1:Z4 = Z2:Z1 = 0:Z2 = 0:IF Z4 - Z3 >= 3 AND Z3 > ZS THEN ZS = Z3:ZE = Z4:ZL = TL
2770  IF PEAK <> 3 OR (C1$ = "_" AND C2$ = "_") THEN PEAK = 0
2780  NEXT
2790  L1$ = L2$
2800  C2 = 0
2810  FOR I = 3 TO COLS+2
2820  IF MID$(L1$, I, 1) = " " THEN C2 = C2 + 1
2830  NEXT
2840  TL = TL + 1
2850  IF C2 < COLS THEN PRINT:GOTO 2530
2860  ZS = ZS - 2:ZE = ZE - 2:RETURN
9000  DATA  SP ,"(I)"
9010  DATA "SE","/T\"
9020  DATA "SP","(I)"
9030  DATA "SP","/T\"
9040  DATA "SE"," V "
