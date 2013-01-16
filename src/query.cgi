#!/usr/bin/python
#query tsar data from tsar2db with tablename 
import cgi
import sys
import re
import datetime,time
import MySQLdb

table_name = ""
start_time = ""
end_time = ""
host_name = ""
time_interval = 60

ISOTIMEFORMAT = '%Y-%m-%d_%XX'
FORMAT = ur"\d\d\d\d-\d\d-\d\d_\d\d:\d\d:\d\d"
TIMESTAMPFORMAT = ur"^\d\d\d\d\d\d\d\d\d\d$"

print "Content-type: text/plain\n"
#deal parameter
form = cgi.FieldStorage()
if form.has_key("table") and form["table"].value != "":
    table_name = form["table"].value
else:
    print "Error:miss table name."
    print "Table:load mem cpu tcp squid haproxy lvs switch traffic udp tcpx apache partition swap io pcsw "
    print "Host:cache161.cn20 "
    print "Start/End:timestamp or stardtime, 1292472000 or 2010-12-16_12:00:00 "
    print "Sample as:query.cgi?table=load&start=1292472000&end=1292472060&host=mmdev2.corp.alimama.com "
    sys.exit(-1)
if form.has_key("start") and form["start"].value != "":
    if re.match(FORMAT,form["start"].value):
        start_time = time.mktime(time.strptime(form["start"].value, ISOTIMEFORMAT))
    if re.match(TIMESTAMPFORMAT,form["start"].value):
        start_time = form["start"].value
if form.has_key("end") and form["end"].value != "":
    if re.match(FORMAT,form["end"].value):
        end_time = time.mktime(time.strptime(form["end"].value, ISOTIMEFORMAT))
    if re.match(TIMESTAMPFORMAT,form["end"].value):
        end_time = form["end"].value
if form.has_key("host") and form["host"].value != "":
    host_name = form["host"].value

if start_time == "":
    if end_time == "":
        end_time = int(time.time())
        start_time = end_time - time_interval
    else:
        start_time = int(end_time) - time_interval
else:
    if end_time == "":
       end_time = int(start_time) + time_interval

#connect to DB
db_user = "tsaruser"
db_pw = "tsarpw"
db_name = "tsar"
try:
    db = MySQLdb.connect(host="localhost", unix_socket="/tmp/mysql.sock", user=db_user, passwd=db_pw, db=db_name)
    try:
        c = db.cursor()
    except Exception, e:
        c.close()
        db.close()
        msg = 'Fail to get cursor of db connection:' + str(e)
        print msg 
        sys.exit(-1)

except Exception, e:
    msg = "error:Fail to open mysql db " + db_name + ":" + str(e)
    print msg
    sys.exit(-1)
try:
    cmd = ''
    if host_name == "":
        cmd = 'select * from `' + table_name +'` where view_time > from_unixtime(' + str(start_time) + ') and view_time < from_unixtime(' + str(end_time) + ');'
    else:
        cmd = 'select * from `' + table_name +'` where view_time > from_unixtime(' + str(start_time) + ') and view_time < from_unixtime(' + str(end_time) + ') and host_name = "' + host_name + '";'
    c.execute(cmd)
    r = c.fetchall()
    if r == None or len(r) <= 0:
        msg = 'no data. time:' + str(start_time) + '-' + str(end_time) + ', hostname:' + host_name + ', table:' + table_name
        c.close()
        db.close()
        sys.exit(msg)
    else:
        for rr in r:
            msg = ""
            for rrr in rr:
                msg += str(rrr) + " "
            print msg

except Exception, e:
    msg = 'Error: '+ str(e)
    print msg
    sys.exit(-1)
c.close()
db.close()
sys.exit(0)
