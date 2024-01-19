patches=[]
points=[]
f=open("teapot", 'r')
line=f.readline()
nvert=0
npatches=int(line)
for i in range(0,npatches):
    line=f.readline()
    patches.append([int(x) for x in line.split(',') if x!="\n"])
line=f.readline()
nvert=int(line)
line=f.readline()
while line!='' and line!="\n":
    #print(line)
    points.append( [int(float(x)*10000) for x in line.split(',') if x!="\n"])
    line=f.readline()

f.close()

f=open('teapot_int', 'w')
f.write(f"{npatches}\n")
for p in patches:
    f.write(",".join([str(x) for x in p]))
    f.write("\n")
f.write(f"{nvert}\n")    
for v in points:
    f.write(",".join( [str(x) for x in v]))
    f.write("\n")
f.close()