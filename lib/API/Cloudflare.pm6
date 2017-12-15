use v6;
use Data::Dump;
use LWP::Simple;
use JSON::Tiny;

role Authy {
  has $.key;
  has $.email;

  method headers() {
    return %(
      X-Auth-Email => $!email,
      X-Auth-Key => $!key,
    )
  }
}

role CRUDy {
  method headers() { ... }
  method endpoint() { ... }

  method serialise() { ... }
  method deserialise($x) { from-json($x) }

  method create () {
#    my $endpoint = self.endpoint;
#
#    return LWP::Simple.post($url, self.headers, self.serialise);
  }

  method read($id?) {
  }

  method update() {}
  method delete() {}
}

role Resource {
  has $.zone;
}

role ResourceSet does CRUDy {
  has $!api;
  has $!zone;
  has Resource @.resources;
  has $.errors;
  has $.messages;

  method endpoint () {
    my $e = callsame;
    "{$!zone}/{$e}";
  }

  method resource-type { ... }
  method read($id?) { 
    my $res = self.deserialise($!api.read(self.endpoint, $id));
    $!errors = $res<errors>;
    $!messages = $res<messages>;
    
    my $type = self.resource-type;
    @!resources = map { $type.new($^a) }, |$res<result>;
  }
}

class API::Cloudflare does Authy {
  method base-url() {
    "https://api.cloudflare.com/client/v4/zones";
  }

  method resource(ResourceSet:U $resource-set, $zone) {
    $resource-set.new(:api(self), :zone($zone))
  }

  method read ($endpoint, $id?) {
    my $url = self.base-url ~ "/{$endpoint}" ~ ("/{$id}" with $id);
    LWP::Simple.get($url, self.headers);
  }
}
