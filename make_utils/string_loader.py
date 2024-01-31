#!/usr/bin/env python3

#take a binary and generate an atari string

import argparse

parser = argparse.ArgumentParser(description='Generate an atari string loader listing.')


parser.add_argument('-b','--binary', dest='binfile',
                    required=True,
                    nargs="?",
                    help='Binary/executable file to parse')
parser.add_argument('-o','--output',
                    dest='outfile',
                    nargs="?",
                    default="out.txt",
                    help='atari file to generate, default out.txt')

args = parser.parse_args()
print(args.binfile)
print(args.outfile)

f=open(args.binfile, 'br')
#read header
header=f.read(6)
if (header[:2]!=b'\ff\ff'):
    print("invaild executable, using raw data")
    f.seek(0)

data=f.read()

for byte in data:
    if byte<32 or byte >126:
        print(f"\\{byte:02x}",end ="")
    else :
        print(chr(byte),end ="");


