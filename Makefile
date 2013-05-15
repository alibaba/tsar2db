###############################
# Makefile for Tsar 
#
# Last Modified: 4-15-2010
###############################


# Source code directories
SRC_BASE=./src/
SRC_INCLUDE=./include/

all:	
	cd $(SRC_BASE); $(MAKE) $@ ; cd ..

	@echo ""
	@echo "*** Compile finished ***"
	@echo ""
	@echo "If the compile finished without any errors, you should"
	@echo "find client and server binaries in the src/ subdirectory."
	@echo ""

nsca:
	cd $(SRC_BASE); $(MAKE) $@ ; cd ..

send_nsca:
	cd $(SRC_BASE); $(MAKE) $@ ; cd ..

install:
	mkdir -p /etc/tsar2db
	@echo ""
	@echo "copy tsar2db file to system"
	cp src/tsar_server /etc/tsar2db/
	cp src/tsar_client /etc/tsar2db/
	cp src/cleanmysql.sh /etc/tsar2db/
	cp src/rotate_mrg.pl /etc/tsar2db/
	cp src/tsar2db /etc/init.d/
	cp conf/tsar2db.cfg /etc/tsar2db/
	cp conf/tsar2db.conf /etc/httpd/conf/include/tsar2db.conf
	cp db/init.sql /etc/tsar2db/
	cp db/tsar.sql /etc/tsar2db/
	cp tests/test /etc/tsar2db/
	cp tests/TSARTest.pm /etc/tsar2db/
	cp src/query.cgi /home/a/share/cgi-bin/query.cgi
	@echo ""
	@echo "init mysql and import table"
	service mysqld start > /dev/null 2>&1
	mysql -u root -h localhost < /etc/tsar2db/init.sql > /dev/null 2>&1
	mysql -u root -h localhost -D tsar < /etc/tsar2db/tsar.sql > /dev/null 2>&1
	echo "0 2 1 */3 * root sh /etc/tsar2db/cleanmysql.sh >> /tmp/cleanmysql.log 2>& 1" > /etc/cron.d/tsar2db


uninstall:
	@echo ""
	@echo "backup tsar2db config"
	cp /etc/tsar2db/tsar2db.cfg /etc/tsar2db/tsar2db.cfg.rpmsave
	@echo ""
	@echo "remove tsar2db config"
	rm -f /etc/tsar2db/tsar_server
	rm -f /etc/tsar2db/tsar_client
	rm -f /etc/tsar2db/cleanmysql.sh
	rm -f /etc/tsar2db/rotate_mrg.pl
	rm -f /etc/init.d/tsar2db
	rm -f /etc/tsar2db/tsar2db.cfg
	rm -f /etc/tsar2db/*,sql
	rm -f /etc/tsar2db/test
	rm -f /etc/tsar2db/TSARTest.pm
	rm -f /home/a/share/cgi-bin/query.cgi
	rm -f /etc/cron.d/tsar2db

clean:
	cd $(SRC_BASE); $(MAKE) $@ ; cd ..
	rm -f core
	rm -f *~ */*~

