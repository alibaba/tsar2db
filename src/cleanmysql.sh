#/usr/bin
#rotate tables

time=` date +%Y%m%d%H `
database="tsar"
echo $time
for i in cpu tcpx apache udp tcp mem \`load\` partition swap pcsw switch traffic squid haproxy lvs io extend ts_cache
 do
  perl /etc/tsar2db/rotate_mrg.pl $database $i
  sleep 1
 done
