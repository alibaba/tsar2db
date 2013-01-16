%define name tsar2db
%define version %{_version}
%define release %{_release}
Name:           %{name}
Version:        %{version}
Release:        %{release}
Summary:        %{name} 

Group:          Application/System
License:        GPL
URL:		http://svn.simba.taobao.com/svn/cdn/trunk/tsar2db/Revision_%{_svn_revision}
Source0:       	%{name}-%{version}.tar.gz

BuildRoot:     	%{_tmppath}/%{name}-buildroot

BuildRequires:  bash , grep , mysql, mysql-devel , perl
Requires: bash , grep , perl ,mysql-devel , mysql-server , perl-Net-SNMP ,httpd ,MySQL-python
BuildRequires: _TCP_WRAPPERS_

%description
Tsar to mysql

%prep
%setup -q

%pre
# if LSB standard /etc/init.d does not exist,
# create it as a symlink to the first match we find
if [ -d /etc/init.d -o -L /etc/init.d ]; then
  : # we're done
elif [ -d /etc/rc.d/init.d ]; then
  ln -s /etc/rc.d/init.d /etc/init.d
elif [ -d /usr/local/etc/rc.d ]; then
  ln -s  /usr/local/etc/rc.d /etc/init.d
elif [ -d /sbin/init.d ]; then
  ln -s /sbin/init.d /etc/init.d
fi

%post
#init db, creat db and tables;
service mysqld start > /dev/null 2>&1
mysql -u root -h localhost < /etc/tsar2db/init.sql > /dev/null 2>&1
mysql -u root -h localhost -D tsar < /etc/tsar2db/tsar.sql > /dev/null 2>&1
echo "0 2 1 */3 * root sh /etc/tsar2db/cleanmysql.sh >> /tmp/cleanmysql.log 2>& 1" > /etc/cron.d/tsar2db

%build
make

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/etc
mkdir -p %{buildroot}/etc/tsar2db
mkdir -p %{buildroot}/etc/init.d
mkdir -p %{buildroot}/home/a/share/cgi-bin
mkdir -p %{buildroot}/etc/httpd/conf/include

%{__install} -m0755 src/tsar_server %{buildroot}/etc/tsar2db/tsar_server
%{__install} -m0755 src/tsar_client %{buildroot}/etc/tsar2db/tsar_client
%{__install} -m0755 src/cleanmysql.sh %{buildroot}/etc/tsar2db/cleanmysql.sh
%{__install} -m0755 src/rotate_mrg.pl %{buildroot}/etc/tsar2db/rotate_mrg.pl
%{__install} -m0644 conf/tsar2db.cfg %{buildroot}/etc/tsar2db/tsar2db.cfg
%{__install} -m0644 db/init.sql %{buildroot}/etc/tsar2db/init.sql
%{__install} -m0644 db/tsar.sql %{buildroot}/etc/tsar2db/tsar.sql
%{__install} -m0644 tests/TSARTest.pm %{buildroot}/etc/tsar2db/TSARTest.pm
%{__install} -m0755 tests/test %{buildroot}/etc/tsar2db/test
%{__install} -m0755 src/tsar2db %{buildroot}/etc/init.d/tsar2db
%{__install} -m0755 src/query.cgi %{buildroot}/home/a/share/cgi-bin/query.cgi
%{__install} -m0644 conf/tsar2db.conf %{buildroot}/etc/httpd/conf/include/tsar2db.conf

%clean
rm -rf $RPM_BUILD_ROOT

%preun
/etc/init.d/tsar2db stop

%postun
if [ "$1" = "0" ]; then
 rm -rf /etc/cron.d/tsar2db
 rm -rf /etc/tsar2db/cleanmysql.sh
fi

%files
%defattr(-,root,root)
/home/a/share/cgi-bin/query.cgi
/etc/init.d/tsar2db
/etc/tsar2db/tsar_server
/etc/tsar2db/tsar_client
/etc/tsar2db/cleanmysql.sh
/etc/tsar2db/rotate_mrg.pl
/etc/tsar2db/TSARTest.pm
/etc/tsar2db/test
/etc/tsar2db/*.sql
/etc/httpd/conf/include/tsar2db.conf
%config(noreplace) /etc/tsar2db/*.cfg

%changelog
* Wed Dec  1 2010 Li Ke <kongjian@taobao.com>
- separate ecc_monior and store tsar data into db
* Mon Mar 26 2010 Li Ke <kongjian@taobao.com>
- first create tsar2db rpm package
