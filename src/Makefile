# Source code directories
SRC_INCLUDE=../include
MYSQL_INCLUDE=-I/usr/include/mysql 

cpu_bit=$(shell getconf LONG_BIT)
ifeq ($(cpu_bit),64)
MYSQL_LIBS=-L/usr/lib64/mysql
else
MYSQL_LIBS=-L/usr/lib/mysql
endif

CC=gcc
CFLAGS=-g -O2 -DHAVE_CONFIG_H
LDFLAGS= 
MYSQLLIBS= -lmysqlclient
SOCKETLIBS= -lnsl
LIBWRAPLIBS= -lwrap

CP=@CP@


all: tsar_server tsar_client test_client

tsar_server: tsar_server.c netutils.c $(SRC_INCLUDE)/netutils.h $(SRC_INCLUDE)/config.h
	$(CC) $(CFLAGS) -o $@ tsar_server.c netutils.c $(MYSQL_INCLUDE) $(MYSQL_LIBS) $(LDFLAGS) $(MYSQLLIBS) $(SOCKETLIBS) $(LIBWRAPLIBS)

tsar_client: tsar_client.c netutils.c $(SRC_INCLUDE)/netutils.h $(SRC_INCLUDE)/config.h
	$(CC) $(CFLAGS) -o $@ tsar_client.c netutils.c $(LDFLAGS) $(SOCKETLIBS)
test_client: test_client.c
	$(CC) -o $@ test_client.c $(LDFLAGS)
clean:
	rm -f core tsar_server tsar_client test_client
	rm -f *~ */*~
