#!/bin/env python3

import sys
imagefile="mex.bmp"
# imagefile = sys.argv[1]
# if imagefile=="":

with open(imagefile, "rb") as f:
    chunk = f.read(51)
    line=5000
    while chunk:
        print(f"{line} DATA ", end="")
        for byte in chunk:
            print(f"{byte}," , end="")
        print("")
        chunk = f.read(51)
        line+=10

    f.close()