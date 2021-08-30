o: 
ld  a,(iy)
inc(iy)
jp p,n
neg
n:ld l,a
ld h,0
add hl,hl
add hl,-224
ld bc,hl
ld ix,-999
ld hl,0
ld d,23
k:ld e,31
add hl,bc
push hl
j:ld a,(iy)
add a,h
and 56
ld (ix),a
add hl,99
add hl,bc
inc ix
dec e
jp p,j
pop hl
dec d
jp p,k
halt
ld hl,-999
ld de,$5800
ld bc,768
ldir
jp o

