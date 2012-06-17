#!/usr/bin/perl
=head1 SCRIPT NAME
updateddns.pl

=head1 DESCRIPTION
Dynamic DNSのIP更新を行う

=head1 USAGE
  updateddns.pl -s [PROVIDER] -h [HOST] -i [ID] -p [PASSWD] -c [FILE] -u -v

  -s PROVIDER ,--service=PROVIDER
　　サービス提供元。以下の３つをサポート。
     DynDNS ,IeServer ,NoIp

  -h HOST ,--host=HOST
　　ホスト名

  -i ID ,--id=ID
　　ID

  -p PASSWD ,--passwd=PASSWD
　　パスワード

  -c FILE
    テキストファイルを指定。内容と現在のIPが不一致の場合IPの更新を行う。
　　ただし-uオプションがない場合には更新は行わない。

  -u ,--update
    IPの更新を行う

  -v ,--verbose
=cut

use strict;
use warnings;
use Text::Trim;
use Module::Load;
use Getopt::Long;

my $service;
my $host;
my $id;
my $passwd;
my $ipfile;
my $do_update;
my $verbose;

GetOptions (
  'service=s' => \$service,
  'host=s' => \$host,
  'id=s' => \$id,
  'passwd=s' => \$passwd,
  'checkip=s' => \$ipfile,
  'update' => \$do_update,
  'verbose' => \$verbose,
);

unless ($service && $host && $id && $passwd){
  print "usage:...";
  exit(9);
}

my $module="DynamicDNS::${service}";
load $module;

my $ddns = $service->new();
my $ip = $ddns->get_ip();

unless (defined $ip){
  myprint ("err ip\n");
  exit(1);
}
myprint ("IP:$ip\n");

if ($ipfile){
  my $saved_ip = readlastip($ipfile);
  if ((defined $saved_ip) && ($ip eq $saved_ip)){
    myprint ("don't update same ip\n");
    exit(2); 
  }
  writelastip($ip,$ipfile);
}

if ($do_update){
  $ddns->update($host,$id,$passwd);
  myprint("update\n");
}

exit(0);

sub myprint{
  my $str = shift;
  if ($verbose){
    print $str;
  }
}

sub readlastip{
  my $ipfile = shift;
  open(my $fh,'<',$ipfile) or return;
  my $ip=<$fh>;
  close $fh;
  trim($ip);
  return $ip;
}

sub writelastip{
  my $ip = shift;
  my $ipfile = shift;
  open(my $fh,'>',$ipfile) or return;
  print $fh $ip;
  close $fh;
}

