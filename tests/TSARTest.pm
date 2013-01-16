#
# DESCRIPTION:
#	Helper object class for Tsar testing
#

package TSARTest;

use strict;
use Class::Struct;
use IO::File;

struct TSARTest => {
	config => '$',
	pid => '$',
	};

$| = 1;	# Autoflush on

sub start {
	my ($self) = @_;
	printf "Starting tsar_server\n";
	system("/etc/tsar2db/tsar_server");
	sleep 1;	# Let daemon start
	open F, "/var/run/tsar2db.pid" or die "No pid file found";
	chop(my $pid = <F>);
	close F;
	$self->pid($pid);
	return $pid;
}

sub stop {
	my $self = shift;
	open F, "/var/run/tsar2db.pid" or die "No pid file found";
	chop(my $pid = <F>);
	close F;
	$self->pid($pid);
	print "Stopping tsar_server: ".$self->pid.$/;
	kill "TERM", $self->pid;
	$self->pid(undef);
	#unlink "var/nagios.cmd", "var/tsar.dump";
	sleep 1;	# Let daemon die
}

sub send {
	my ($self, $data) = @_;
	my @output = map { join("\t", @$_)."\n" } @$data;
	open SEND, "| ".$self->send_cmd;
	print SEND @output;
	close SEND;
}

sub send_cmd {
	my ($self) = @_;
	return "/etc/tsar2db/tsar_client localhost 56677";
}

1;
