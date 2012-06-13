#!/usr/bin/perl

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

unless ($service && $host && $id && $passwd && $ipfile){
  print "usage:...";
  exit;
}

my $module="DynamicDNS::${service}";
load $module;

my $ddns = $service->new();
my $ip = $ddns->get_ip();

myprint ("IP:$ip\n");

if ($ipfile){
  my $saved_ip = readlastip($ipfile);
  if ((defined $saved_ip) && ($ip eq $saved_ip)){
    myprint ("don't update same ip\n");
    exit; 
  }
  writelastip($ip,$ipfile);
}

if ($do_update){
  $ddns->update($host,$id,$passwd);
  myprint("update\n");
}

exit;

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

