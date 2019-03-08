#!/bin/bash

tcpser -d /dev/ttyUSB0 -s 19200 -l7 -i "&k0" -n l29=bbs.fozztexx.com:6502 \
-n veteran=bbs.sfhqbbs.org:3523 -n resist=broadway1.lorexddns.net:23 \
-n alcatraz=alcatrazbbs.ddns.net:9000 -n cth=cth.dtdns.net \
-n ptime=ptbbs.ddns.net:8000 -n darkforce=darkforce-bbs.dyndns.org:520 \
-n mouse=bbs-mousenet.dynip.online -n basement=basementbbs.ddns.net:9000 \
-n hawaii=atari-bbs.zapto.org:8888 -n boot=bfbbs.no-ip.com:8888 \
-n thecafe=thecafe.dtdns.net:8888 -n yyz=yyzbbs.no-ip.org:65 \
-n 8bg=8bitguild.no-ip.org:130 -n cyber=CYBERSERV.ORG:8005 \
-n irata=IRATA.ONLINE:8005 -n bates=thebrewingacademy.com:8888 \
-n starfleet=bbs.sfhqbbs.org:5983

