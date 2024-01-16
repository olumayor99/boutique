data "aws_route53_zone" "ingress" {
  name = var.domain_name
}

resource "helm_release" "external-dns" {
  name         = "external-dns"
  repository   = "oci://registry-1.docker.io/bitnamicharts"
  chart        = "external-dns"
  version      = "6.28.6"
  force_update = true
  timeout      = 300

  set_list {
    name  = "domainFilters"
    value = [data.aws_route53_zone.ingress.name]
  }

  set {
    name  = "txtPrefix"
    value = data.aws_route53_zone.ingress.id
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