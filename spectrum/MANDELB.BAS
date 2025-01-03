100 REM BASIC Month 6: The Mandelbaum Set
110 REM http://reddit.com/r/RetroBattlestations
120 REM Original written by FozzTexx
125 REM ZX spectrum veruon By u/papa_robot
200 REM === Initialize variables and constants
210 DIM T(128):DIM G(9):DIM M(9):DIM Z(230):DIM N(9):DIM O(9): DIM K(9)
220 LET G(1) = 33:LET G(2) = 138:LET G(3) = 200
230 LET M(1) = 1:LET M(2) = 0:LET M(3) = 0
240 LET M(4) = 0:LET M(5) = 1:LET M(6) = 0
250 LET M(7) = 0:LET M(8) = 0:LET M(9) = 1
260 LET GW = G(3) * G(3) / G(2)
270 LET TH = G(3) + 5:GO SUB 2630:LET TH = TH + Z(2):GO SUB 2630:LET TH = TH + Z(2)
280 LET Z(1) = 255:LET Z(2) = 175:REM Width & height of screen
290 LET SX = (Z(1) - Z(1) * 0.05) / GW:LET SY = (Z(2) - Z(2) * 0.07) / TH
300 LET SK = SX:IF SY < SK THEN LET SK = SY

310 PAPER 0:INK 7:BORDER 0:CLS
320 REM "What in holy hell?"
330 LET X = -GW / 2:LET Y = -G(3) / 2:GO SUB 2030:REM Translate
340 LET X = SK:LET Y = SK:GO SUB 2230:REM Scale
350 LET X = Z(1) / 2:LET Y = Z(2) / 2:GO SUB 2030:REM Translate
360 GO SUB 2820
370 RESTORE:REM Reset reading of DATA back to first object
380 GO SUB 2630:GO SUB 2720
390 GO SUB 2630
400 LET X = (GW - Z(1)) * SK:LET Y = (G(3) + Z(2) + 5) * SK
410 GO SUB 2030:GO SUB 2720:GO SUB 2920
420 GO SUB 2630
430 LET GX = G(2) / 2:LET GY = G(3) / 2:LET GB = GY - GX:LET OO = G(3) * G(3) / G(2) - G(2)
440 GO SUB 4510

500 REM "Step aside, string bean."
510 LET X = -Z(1) / 2:LET Y = -Z(2) / 2:GO SUB 2030:REM Translate
520 LET A = PI / 2:GO SUB 2130:REM Rotate
530 LET X = G(2) / G(3):LET Y = X:GO SUB 2230:REM Scale
540 LET X = Z(1) / 2 + (GW / 2 - G(2) / 2) * SK:LET Y = Z(2) / 2:GO SUB 2030:REM Translate
550 GO SUB 4510
560 IF HT > 1 THEN GO TO 510
570 GO SUB 4610

999 STOP

1000 REM === Update current transformation matrix
1010 REM  - Input: 3x3 matrix in 1D array NT
1020 REM  - Updates 3x3 Matrix in 1D array CM
1030 FOR R = 0 TO 2:FOR C = 0 TO 2
1040 LET K(R * 3 + C +1) = 0
1050 FOR K = 0 TO 2
1060 LET K(R * 3 + C + 1) = K(R * 3 + C +1 ) + N(R * 3 + K + 1) * M(K * 3 + C+1)
1070 NEXT K:NEXT C:NEXT R
1080 FOR K = 1 TO 3 * 3 :LET M(K) = K(K):NEXT K
1090 RETURN

2000 REM === Translate - move origin
2010 REM  - Input: X, Y
2020 REM  - Updates current transformation matrix in CM
2030 LET N(1) = 1:LET N(2) = 0:LET N(3) = X
2040 LET N(4) = 0:LET N(5) = 1:LET N(6) = Y
2050 LET N(7) = 0:LET N(8) = 0:LET N(9) = 1
2060 GO SUB 1030
2070 RETURN

2100 REM === Rotate - rotate drawing space
2110 REM  - Input: Angle in radians in A
2120 REM  - Updates current transformation matrix in CM
2130 LET N(1) = COS(A):LET N(2) = -SIN(A):LET N(3) = 0
2140 LET N(4) = -N(2):LET N(5) = N(1):LET N(6) = 0
2150 LET N(7) = 0:LET N(8) = 0:LET N(9) = 1
2160 GO SUB 1030
2170 RETURN

2200 REM === Scale - modify unit lengths of drawing
2210 REM  - Input: X, Y
2220 REM  - Updates current transformation matrix in CM
2230 LET N(1) = X:LET N(2) = 0:LET N(3) = 0
2240 LET N(4) = 0:LET N(5) = Y:LET N(6) = 0
2250 LET N(7) = 0:LET N(8) = 0:LET N(9) = 1
2260 GO SUB 1030
2270 RETURN

2300 REM === Transform single point using current transformation matrix
2310 REM  - Input: X, Y
2320 REM  - Returns transformed point in X and Y
2330 LET N(1) = X:LET N(2) = Y:LET N(3) = 1
2340 FOR R = 0 TO 2
2350 LET K(R+1) = 0
2360 FOR K = 0 TO 2
2370 LET K(R+1) = K(R+1) + N(K+1) * M(R * 3 + K+1)
2380 NEXT K: NEXT R
2390 LET X = K(1):LET Y = K(2)
2400 RETURN

2500 REM === Draw line
2510 REM  - Input: X1,Y1 X2,Y2
2520 LET X = X1:LET Y = Y1:GO SUB 2330:LET A1 = X:LET B1 = Y
2530 LET X = X2:LET Y = Y2:GO SUB 2330:LET A2 = X:LET B2 = Y
2535 LET S1=175-B1:LET S2=175-B2
2540 PLOT A1,S1: DRAW A2-A1,S2-S1
2550 RETURN

2600 REM === Load object from DATA
2610 REM  - Reads the next object from DATA and leaves size in array Z
2620 REM    and paths in array PT
2630 LET ZI = 1:READ ZX:LET Z(1) = ZX:READ ZY:LET Z(2) = ZY
2640 READ ZC:LET T(ZI) = ZC:LET ZI = ZI + 1
2650 IF ZC = 0 THEN RETURN
2660 FOR J = 1 TO ZC : READ ZX:READ ZY
2670 LET T(ZI) = ZX:LET ZI = ZI + 1:LET T(ZI) = ZY:LET ZI = ZI + 1
2680 NEXT J
2690 GO TO 2640

2700 REM === Draw path
2710 REM  - Input: paths to draw in array PT
2720 LET ZI = 1
2730 LET ZC = T(ZI):LET ZI = ZI + 1:IF ZC = 0 THEN RETURN
2740 LET X1 = T(ZI):LET ZI = ZI + 1:LET Y1 = T(ZI):LET ZI = ZI + 1
2750 FOR J = 1 TO ZC-1
2760 LET X2 = T(ZI):LET ZI = ZI + 1:LET Y2 = T(ZI):LET ZI = ZI + 1
2770 GO SUB 2520
2780 LET X1 = X2:LET Y1 = Y2:NEXT J
2790 GO TO 2730

2800 REM == Save current transformation matrix
2810 REM  Copies array CM to array OM
2820 FOR I = 1 TO 9:LET O(I) = M(I):NEXT I
2830 RETURN

2900 REM == Restore transformation matrix
2910 REM  Copies array OM to array CM
2920 FOR I = 1 TO 9:LET M(I) = O(I):NEXT I
2930 RETURN

3000 REM Mandelbaum arc
3010 REM  - Input: Arc center at CX,CY; Start/end radians in SA,EA
3020 REM "If you want to live in a butcher shop, I'm gonna treat you like a piece of meat."
3030 IF (EA < SA) THEN LET EA = EA + 2 * PI
3040 LET NW = Z(1):LET NH = Z(1):LET NS = G(1) / NW:LET SH = NH * NS
3050 LET RO = G(2) / 2:LET RI = RO - G(1)
3060 LET AL = (EA - SA) * G(2) / 2:LET SG = IN(AL / SH)
3070 LET GA = (EA - SA) / SG
3080 LET GC = COS(2 * PI - GA):LET GS = SIN(2 * PI - GA):LET ZC = COS(0):LET ZS = SIN(0)
3090 LET F1 = CX + RI * GC:LET G1 = CY + RI * GS
3100 LET F2 = CX + RO * GC:LET G2 = CY + RO * GS
3110 LET F3 = CX + RI * ZC:LET G3 = CY + RI * ZS
3120 LET F4 = CX + RO * ZC:LET G4 = CY + RO * ZS
3130 LET D1 = F3 - F1:LET D2 = G3 - G1:LET D3 = F4 - F2:LET D4 = G4 - G2
3140 LET L1 = SQR(D1 * D1 + D2 * D2):LET L2 = SQR(D3 * D3 + D4 * D4)
3150 GO SUB 2820
3160 LET X = CX:LET Y = CY:GO SUB 2330:LET AX = X:LET AY = Y

3170 REM Walk through PT and draw
3180 FOR S = 0 TO SG-1 
3190 GO SUB 2920
3200 LET X = -AX:LET Y = -AY:GO SUB 2030:REM Translate
3210 LET A = 2 * PI - (SA + S * GA+1):GO SUB 2130:REM Rotate
3220 LET X = AX:LET Y = AY:GO SUB 2030:REM Translate
3230 LET ZI = 1
3240 LET ZC = T(ZI):LET ZI = ZI + 1:IF ZC = 0 THEN GO TO 3350
3250 LET X1 = T(ZI) * NS:LET ZI = ZI + 1
3260 LET Y1 = T(ZI) * NS * (L1 - 1 + (L2 - L1 - 1) * (X1 / G(1))) / L2:LET ZI = ZI + 1
3270 LET X1 = X1 + CX + RI:LET Y1 = Y1 + CY
3280 FOR J = 1 TO ZC-1 
3290 LET X2 = T(ZI) * NS:LET ZI = ZI + 1
3300 LET Y2 = T(ZI) * NS * (L1 - 1 + (L2 - L1 - 1) * (X2 / G(1))) / L2:LET ZI = ZI + 1
3310 LET X2 = X2 + CX + RI:LET Y2 = Y2 + CY
3320 GO SUB 2520
3330 LET X1 = X2:LET Y1 = Y2:NEXT J
3340 GO TO 3240
3350 NEXT S
3360 GO SUB 2920
3370 RETURN

4000 REM Mandelbaum line
4010 REM  - Input: Start and end diagonal corners in X1,Y1 and X2,Y2
4020 REM "Wrong attitude, you're not bringing that trash into my house."
4030 LET NW = Z(1):LET NH = Z(2) + 1
4040 LET XD = X2 - X1:LET YD = Y2 - Y1
4050 IF XD > 0 AND YD < 0 THEN LET A = 0:LET WD = XD:LET HT = YD
4060 IF XD < 0 AND YD < 0 THEN LET A = 1.5 * PI:LET HT = XD:LET WD = YD
4070 IF XD < 0 AND YD > 0 THEN LET A = PI:LET WD = XD:LET HT = YD
4080 IF XD > 0 AND YD > 0 THEN LET A = 0.5 * PI:LET HT = XD:LET WD = YD
4090 LET WD = ABS(WD):LET HT = ABS(HT)
4100 LET NS = WD / NW:LET SH = IN(NH * NS)
4110 LET SG = IN((HT + SH - 1) / SH):LET SH = HT / SG
4120 LET SX = G(1) / NW:LET SY = SH / NH
4130 GO SUB 2820
4140 LET AX = X1:LET AY = Y1:LET X = X1:LET Y = Y1:GO SUB 2330:LET OX = X:LET OY = Y
4150 LET X = X2:LET Y = Y2:GO SUB 2330:LET XD = X - OX:LET YD = Y - OY
4160 LET X = 0:LET Y = 0:GO SUB 2330
4170 LET X = -X:LET Y = -Y:GO SUB 2030:REM Translate
4180 GO SUB 2130:REM Rotate
4190 LET X = SX:LET Y = SY
4200 IF (XD < 0 AND YD < 0) OR (XD > 0 AND YD > 0) THEN LET Y = SX:LET X = SY
4210 GO SUB 2230:REM Scale
4220 LET X = OX:LET Y = OY:GO SUB 2030:REM Translate

4230 REM Walk through PT and draw
4240 FOR N = 0 TO SG - 1
4250 LET ZI = 1
4260 LET ZC = T(ZI):LET ZI = ZI + 1:IF ZC = 0 THEN GO TO 4350
4270 LET X1 = T(ZI):LET ZI = ZI + 1
4280 LET Y1 = T(ZI) * (SH - 1) / SH - N * (SH / SY):LET ZI = ZI + 1
4290 FOR J = 2 TO ZC
4300 LET X2 = T(ZI):LET ZI = ZI + 1
4310 LET Y2 = T(ZI) * (SH - 1) / SH - N * (SH / SY):LET ZI = ZI + 1
4320 GO SUB 2520
4330 LET X1 = X2:LET Y1 = Y2:NEXT J
4340 GO TO 4260
4350 NEXT N
4360 GO SUB 2920

4370 REM Return height to decide if it's time to stop
4380 LET X = AX:LET Y = AY + SH:GO SUB 2330
4390 LET HT = SQR((X - OX) * (X - OX) + (Y - OY) * (Y - OY))
4400 RETURN

4500 REM === G
4510 LET CX = GX:LET CY = GY - GB:LET SA = 0:LET EA = PI:GO SUB 3030
4520 LET X1 = G(1):LET Y1 = GY - GB:LET X2 = 0:LET Y2 = GY + GB:GO SUB 4030
4530 LET CX = GX:LET CY = GY + GB:LET SA = PI:LET EA = 0:GO SUB 3030
4540 LET X1 = G(2):LET Y1 = GY + GB:LET X2 = GX:LET Y2 = GY + GB - G(1):GO SUB 4030
4550 RETURN

4600 REM === O
4610 LET CX = GX + OO:LET CY = GY - GB:LET SA = 0:LET EA = PI:GO SUB 3030
4620 LET X1 = G(1) + OO:LET Y1 = GY - GB:LET X2 = OO:LET Y2 = GY + GB:GO SUB 4030
4630 LET CX = GX + OO:LET CY = GY + GB:LET SA = PI:LET EA = 0:GO SUB 3030
4640 LET X1 = G(2) - G(1) + OO:LET Y1 = GY + GB:LET X2 = G(2) + OO:LET Y2 = GY - GB:GO SUB 4030
4650 RETURN

9000 REM "All aboard the pain train."
9010 DATA 39,16,15,3,-16,0,-16,0,-13,3,-13,3,-3,0,-3,0,0,10,0,10,-3,6,-3
9020 DATA 6,-13,10,-13,10,-16,6,-16,3,-16,11,16,-16,12,-16,12,-13,16,-13
9030 DATA 16,0,19,0,19,-13,23,-13,23,-16,19,-16,16,-16,5,25,-16,27,-16
9040 DATA 27,-13,25,-13,25,-16,19,36,-9,33,-10,32,-11,34,-13,36,-12,39
9050 DATA -12,34,-16,30,-14,29,-11,32,-7,35,-6,36,-5,34,-3,32,-4,29,-4
9060 DATA 34,0,38,-1,39,-5,36,-9,0
9070 DATA 53,16,15,23,-13,23,-16,20,-16,16,-16,13,-16,13,-13,16,-13,16
9080 DATA -3,13,-3,13,0,23,0,23,-3,20,-3,20,-13,23,-13,18,53,-13,53,-16
9090 DATA 46,-16,43,-16,43,-13,43,-10,43,-6,43,-3,43,0,53,0,53,-3,46,-3
9100 DATA 46,-6,51,-6,51,-10,46,-10,46,-13,53,-13,11,10,-16,7,-16,3,-16
9110 DATA 0,-16,0,-13,3,-13,3,0,7,0,7,-13,10,-13,10,-16,14,37,-16,33,-9
9120 DATA 29,-16,26,-16,26,0,29,0,29,-10,32,-4,34,-4,37,-10,37,0,40,0,40
9130 DATA -16,37,-16,0
9140 DATA 52,8,5,0,0,0,-8,3,-4,5,-8,5,0,3,10,0,8,-8,6,0,2,7,-4,9,-4,4,11
9150 DATA 0,11,-8,15,0,15,-8,6,18,-8,16,-8,16,0,18,0,20,-4,18,-8,2,23,-4
9160 DATA 21,-4,4,25,-8,21,-8,21,0,25,0,3,31,0,26,0,26,-8,12,32,-4,35,-4
9170 DATA 36,-5,36,-7,35,-8,32,-8,32,0,35,0,35,0,36,-1,36,-3,35,-4,3,41
9180 DATA 0,39,-8,37,0,2,38,-4,40,-4,6,42,-8,42,-1,44,0,45,0,47,-1,47,-8
9190 DATA 5,48,0,48,-8,50,-4,52,-8,52,0,0
