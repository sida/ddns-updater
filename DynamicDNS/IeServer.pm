package IeServer;

use strict;
use warnings;
use URI::Fetch;
use base qw(DynamicDNS);

sub new{
  my $class = shift;
  return bless {},$class;
}

sub get_ip{
  my $url = 'http://ieserver.net/ipcheck.shtml';
  my $res = URI::Fetch->fetch($url) or return;
  return $res->content;
}

sub update{
  my $self = shift;
  my ($myhost,$id,$pass) = @_;
  my $update = "http://ieserver.net/cgi-bin/dip.cgi?username=${id}&domain=${myhost}&password=${pass}&updatehost=1";
  return URI::Fetch->fetch($update);
}

1;
