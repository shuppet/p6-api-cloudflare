use v6;
use LWP::Simple;

role Authy {
  has $.key;
  has $.email;

  method headers() {
    return (
      X-Auth-Email => $!email,
      X-Auth-Key => $!key,
    )
  }
}

role CRUDy does Authy {
  has $.zone;

  method base-url () {...}

  method endpoint() { die }
  method create () {
  }
  method read($id?) {
    my $endpoint = self.endpoint;
    my %headers = self.headers;

    my $url = self.base-url ~ "/{$!zone}/{$endpoint}" ~ ("/$id" with $id);

    return LWP::Simple.get($url, %headers);
  }
  method update() {}
  method delete() {}
}

class Cloudflare {
  method base-url() {
    "https://api.cloudflare.com/client/v4/zones";
  }
}

class Cloudflare::DNSRecord is Cloudflare does CRUDy {
  method endpoint () { 'dns_records' }
}
