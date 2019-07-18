
export LC_CTYPE=C

tr '\233\177' '\12\11' < atascii.txt > ascii.txt
tr '\12\11' '\233\177' < ascii.txt > atascii.txt
