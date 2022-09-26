resource "digitalocean_domain" "ndsq_domain" {
  name = "ndsquared.net"
}

resource "digitalocean_record" "www" {
  domain = digitalocean_domain.ndsq_domain.id
  type   = "CNAME"
  name   = "www"
  value  = "@"
}

resource "digitalocean_kubernetes_cluster" "ndsq_cluster" {
  name         = "ndsquared-prod-sfo3"
  region       = "sfo3"
  auto_upgrade = true
  # Retrieve the latest version slug from `doctl kubernetes options versions`
  version = "1.24.4-do.0"

  node_pool {
    name       = "default"
    size       = "s-1vcpu-2gb"
    node_count = 3
  }

  tags = ["ndsquared"]
}

resource "digitalocean_spaces_bucket" "ndsq_content" {
  name   = "ndsq-content"
  region = "sfo3"
  acl    = "public-read"
}

resource "digitalocean_certificate" "ndsq_content_cert" {
  name    = "ndsq-content-cert-17a8ba9"
  type    = "lets_encrypt"
  domains = ["static.ndsquared.net"]
}

resource "digitalocean_certificate" "ndsq_domain_cert" {
  name    = "ndsq-domain-cert"
  type    = "lets_encrypt"
  domains = ["ndsquared.net"]
}

resource "digitalocean_cdn" "ndsq_content_cdn" {
  origin           = digitalocean_spaces_bucket.ndsq_content.bucket_domain_name
  custom_domain    = "static.ndsquared.net"
  certificate_name = digitalocean_certificate.ndsq_content_cert.name
}

# Self-managed backend state bucket
resource "digitalocean_spaces_bucket" "tfstate" {
  name   = "ndsq-terraform-state"
  region = "sfo3"
  acl    = "private"
}
