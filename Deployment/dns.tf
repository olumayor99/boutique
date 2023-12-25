resource "aws_route53_zone" "ingress-nginx" {
  name = var.domain_name
}

resource "helm_release" "external-dns" {
  name       = "external-dns"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "external-dns"
  # namespace        = "external-dns"
  version = "6.28.6"
  # create_namespace = true
  force_update = true
  timeout      = 300

  set_list {
    name  = "domainFilters"
    value = [aws_route53_zone.ingress-nginx.name]
  }

  set {
    name  = "txtPrefix"
    value = aws_route53_zone.ingress-nginx.zone_id
  }

  set {
    name  = "aws.zoneType"
    value = "public"
  }

  set {
    name  = "provider"
    value = "aws"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.external-dns.metadata[0].name
  }
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name = aws_route53_zone.ingress-nginx.name
  zone_id     = aws_route53_zone.ingress-nginx.zone_id

  validation_method = "DNS"

  subject_alternative_names = [
    "*.${aws_route53_zone.ingress-nginx.name}",
  ]

  wait_for_validation = true

  tags = {
    Environment = "Dev"
  }
}