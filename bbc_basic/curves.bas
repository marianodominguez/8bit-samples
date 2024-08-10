
      W% = 512
      R% = 300
      VP% = 1024

      VDU 23,22,W%;W%;8,16,16,0 : OFF

      FOR I% = 0 TO 360
        X=R%*SIN(I%*PI/180)+VP%/2
        Y=R%*COS(I%*PI/180)+VP%/2
        X1=(R%*1.5)*SIN(I%*PI/180)+VP%/2
        Y1=(R%*1.5)*SIN(I%*PI/180)+VP%/2
        COLOUR 7, 0, 120, 255
        MOVE X1,Y1:DRAW X,Y
      NEXT

      REPEAT WAIT 10 : UNTIL FALSE
      END
