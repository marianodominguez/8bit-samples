1 LET A$="  O  --|-- / \\  | | "
2 LET B$="  O  --|-- / \\ /___\\"
3 PAPER 8: INK 0: CLS
4 FOR I=0 TO 3
5 PRINT AT 0+5*I,5;A$(1 TO 5);
6 PRINT AT 1+5*I,5;A$(6 TO 10);
7 PRINT AT 2+5*I,5;A$(11 TO 15);
8 PRINT AT 3+5*I,5;A$(16 TO 20);
9 PRINT AT 0+5*I,10;B$(1 TO 5);
10 PRINT AT 1+5*I,10;B$(6 TO 10);
11 PRINT AT 2+5*I,10;B$(11 TO 15);
12 PRINT AT 3+5*I,10;B$(16 TO 20);
13 NEXT I
14 PRINT AT 10,20;"--------- "
15 PRINT AT 11,20;"|       | "
16 PRINT AT 12,20;"|  |    | "
17 PRINT AT 13,20;"| -+--  | "
18 PRINT AT 14,20;"|  |    | "
19 PRINT AT 15,20;"|       | "
20 PRINT AT 16,20;"--------- "

