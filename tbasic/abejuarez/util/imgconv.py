#!/usr/bin/python3
import sys

input = sys.argv[1]
output = sys.argv[2]

f = open(input, "rb")
o = open(output, "wb")
#read header
header = f.read(40)
#print(header)
#read color table
f.read(154-32)

b=f.read(1)
while b!=b"":
    db=b[0]
    b=f.read(1)
    if b!=b"":
        nb=b[0]
        db=(db & 0xf0)<<2 | (db & 0x0f)<<4
        nb=(nb>>2) | (nb & 0x0f)
        #print(nb|db)
        o.write( (db | nb).to_bytes(1,byteorder='big') )
    b=f.read(1)
f.close()
o.close()
