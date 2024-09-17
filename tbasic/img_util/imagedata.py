#!/bin/env python3

import sys
import math
imagefile="mex.bmp"
if len(sys.argv)>2: imagefile = sys.argv[1]

with open(imagefile, "rb") as f:
    header= f.read(40)
    offset=header[10]
    print(f"4998 REM header { ','.join( [str(byte) for byte in header]) }")
    p=1
    for i in range(1,3):
        p*=256
        offset+=header[10+i]*p
    print(f"4999 REM offset {offset}")
    f.seek(offset)
    chunk = f.read(64)
    line=5000
    while chunk:
        print(f"{line} DATA ", end="")
        print(','.join( [str(byte) for byte in chunk]) )
        chunk = f.read(51)
        line+=10

    f.close()