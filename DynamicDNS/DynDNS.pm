package DynDNS;
use strict;
use warnings;
use URI::Fetch;
use base qw(DynamicDNS);

sub new{
  my $class = shift;
  return bless {},$class;
}

sub parse_ip{
  my $txt = shift;
  $txt =~ m/^.* ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}).*/;
  $1;
}

sub get_ip{
  my $url = 'http://checkip.dyndns.com/';
  my $res = URI::Fetch->fetch($url) or return;
  return parse_ip($res->content);
}

sub update{
  my $self = shift;
  my ($myhost,$id,$pass) = @_;
  my $update = "http://${id}:${pass}\@members.dyndns.org/nic/update?hostname=${myhost}";
  return URI::Fetch->fetch($update);
}

1;
