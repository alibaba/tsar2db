#!/bin/sh

export temppath=$1
cd $temppath/rpm
export appname=$2
TOP_DIR="/tmp/.rpm_create_"$appname"_"`whoami`

export version=$3
export release=$4

LANG=C
export LANG

usage()
{
  echo "Usage:"
  echo "build rpmdir packagename version release"
  exit 0
}

svn_path="Unknown_path"
svn_revision="Unknown_revision"
svn_info()
{
  str=`svn info .. 2>/dev/null |
  awk -F': ' '{if($1=="URL") print $2}'`

  if [ -z "$str" ]; then return; fi

  svn_path=$str
  str=`svn info $svn_path 2>/dev/null |
  awk -F': ' '{if($1=="Last Changed Rev") print $2}'`

  if [ -z "$str" ]; then
    echo "!! Please upgrade your subversion: sudo yum install subversion"
    return;
  fi

  svn_revision=$str
}
#version=$3
#release=$4
svn_info
if [ `cat /etc/redhat-release|cut -d " " -f 7|cut -d "." -f 1` = 4 ]
then
	release="$svn_revision".el4
elif [ `cat /etc/redhat-release|cut -d " " -f 7|cut -d "." -f 1` = 5 ]
then
	release="$svn_revision".el5
else
	release="$svn_revision".el6
fi


RPM_MACROS=$HOME/.rpmmacros
if [ -e $RPM_MACROS ]; then
  mv -f $RPM_MACROS $RPM_MACROS.bak
fi


echo "%_topdir $TOP_DIR" > $RPM_MACROS
echo "%packager " `whoami` >> $RPM_MACROS
echo "%vendor TaoBao Inc." >> $RPM_MACROS
echo "%_svn_path $svn_path" >> $RPM_MACROS
echo "%_svn_revision $svn_revision" >> $RPM_MACROS
echo "%_release $release" >> $RPM_MACROS
echo "%_name $appname" >> $RPM_MACROS
echo "%_version $version" >> $RPM_MACROS
echo "%_unpackaged_files_terminate_build 1" >> $RPM_MACROS
echo "%debug_package %{nil}" >> $RPM_MACROS


cd ..
rm -rf $TOP_DIR
mkdir -p $TOP_DIR/RPMS
mkdir -p $TOP_DIR/SRPMS
mkdir -p $TOP_DIR/BUILD
mkdir -p $TOP_DIR/SOURCES
mkdir -p $TOP_DIR/SPECS

rm -f $appname-$version.tar.gz
ln -s . $appname-$version
tar --exclude=$appname-$version/$appname-$version \
    --exclude=$appname-$version/.svn \
    --exclude=$appname-$version/*/.svn \
    --exclude=$appname-$version/$appname-$version.tar.gz \
    -cf - $appname-$version/* |gzip -c9 >$appname-$version.tar.gz
rm -f $appname-$version
cp $appname-$version.tar.gz $TOP_DIR/SOURCES

## create spec file from template
if [ `cat /etc/redhat-release|cut -d " " -f 7|cut -d "." -f 1` = 6 ]
then
 sed -e "s/_TCP_WRAPPERS_/tcp_wrappers-devel/g" < rpm/$appname.spec.in > $TOP_DIR/SPECS/$appname.spec
else
 sed -e "s/_TCP_WRAPPERS_/tcp_wrappers/g" < rpm/$appname.spec.in > $TOP_DIR/SPECS/$appname.spec
fi

rpmbuild -ba $TOP_DIR/SPECS/$appname.spec

find $TOP_DIR/RPMS -name "*.rpm"  -exec mv {} ./rpm \;

rm -rf $TOP_DIR $RPM_MACROS
if [ -e $RPM_MACROS.bak ]; then
  mv -f $RPM_MACROS.bak $RPM_MACROS
fi

cd -
svn revert $appname.spec.in


