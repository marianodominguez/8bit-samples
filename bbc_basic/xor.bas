
      W% = 512
      VDU 23,22,W%;W%;8,16,16,0 : OFF

      FOR X% = 0 TO W%-1
        FOR Y% = 0 TO W%-1
          B% = (X% EOR Y%) AND 255
          COLOUR 7, B%, B%>>1, 255-B%
          PLOT 2*X%, 2*Y%
        NEXT
      NEXT

      REPEAT WAIT 10 : UNTIL FALSE
      END
