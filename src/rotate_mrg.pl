#!/usr/bin/perl
#rotate script
#usage:perl rotate_mrg.pl database table

use strict;
use warnings;

use DBI;
use DBD::mysql;

## ========================================================================

my $DB_HOST = 'localhost';
my $DB_NAME = $ARGV[0];
my $DB_USER = 'root';
my $DB_PASSWD = '';

my $dbh = DBI->connect("DBI:mysql:database=$DB_NAME;host=$DB_HOST;mysql_socket=/tmp/mysql.sock",
	         "$DB_USER", "$DB_PASSWD", { RaiseError => 1 });

my $sth;
my $sql;

## =========================================================================

my $base_table = $ARGV[1];

## =========================================================================

sub get_mrg_list {
	my $table = $_[0];
	my $create_table;
	my @list;

	$sql = "show create table $table";
	$sth = $dbh->prepare($sql);
	$sth -> execute();

	while (my $ref = $sth->fetchrow_hashref()) {
		$create_table = $ref->{'Create Table'};
	}
	$create_table =~ s/.*\n//g;
	$create_table =~ s/.*\(//g;
	$create_table =~ s/\).*//g;

	@list = split(/,/, $create_table);
	return \@list;
}

## =========================================================================

sub get_new_list {
	my $old_list = $_[0];
	my @new_list;
	my $last;
	
	$last = @{$old_list};
	push (@new_list, $old_list->[$last-1]);
	$dbh->do("flush table");
	$sql = "truncate table $old_list->[$last-2]";
	print "$sql\n";
	$dbh->do($sql);
	for (my $i = 0; $i < (@{$old_list}-1); $i++) {
		push (@new_list, $old_list->[$i]);
	}
	return \@new_list;
}

## =========================================================================

sub main {
	my $table_list;
	my $new_list;
	my $list_str;
	
	$table_list = &get_mrg_list($base_table);
	$new_list = &get_new_list($table_list);
	$list_str = join(',', @{$new_list});

	$sql = "alter table $base_table UNION=($list_str)";
	print "$sql\n";
	$dbh->do($sql);
}

## =========================================================================

&main;
