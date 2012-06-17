package NoIp;

use strict;
use warnings;
use HTML::TagParser;
use URI::Fetch;
use base qw(DynamicDNS);

sub new{
  my $class = shift;
  return bless {},$self;
}

sub parse_ip{
  my $txt = shift;
  $txt =~ m/^.* ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}).*/;
  $1;
}

sub get_ip{
  my $url = 'http://www.checkip.org/';
  my $html = HTML::TagParser->new($url) or return;
  my $elem = $html->getElementById('yourip');
  return parse_ip($elem->innerText());
}

sub update{
  my $self = shift;
  my ($myhost,$id,$pass) = @_;
  my $update = "http://${id}:${pass}\@dynupdate.no-ip.com/nic/update?hostname=${myhost}";
  return URI::Fetch->fetch($update);
}

1;

