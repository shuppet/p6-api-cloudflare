use v6;
use API::Cloudflare;

class API::Cloudflare::DNSRecordSet does ResourceSet {
  method resource-type { API::Cloudflare::DNSRecord }
  method endpoint () { 'dns_records' }
}

class API::Cloudflare::DNSRecord does Resource {
  has $.type;

  method serialise() {
    return {}
  }

}

class API::Cloudflare::DNSRecord::A is API::Cloudflare::DNSRecord {
}
