#!perl6
use v6;
use LWP::Simple;
use JSON::Tiny;
use API::Cloudflare::Resources;

sub MAIN (Str $action, Str $item?, Str :$zone, Str :$key, Str :$email) {
  die "Auth key not set" unless $key;
  die "Auth email not set" unless $email;
  die "Zone not set" unless $zone;

  my $api = API::Cloudflare.new(
    :key($key),
    :email($email),
  );

  my $res = $api.resource('DNSRecord')."$action"($item);
  #my $res = $dnsrecord."$action"($item);
  use Data::Dump;
  say Dump($res);
}
