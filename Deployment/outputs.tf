output "load_balancer_hostname" {
  value = kubernetes_ingress_v1.frontend.status.0.load_balancer.0.ingress.0.hostname
}

output "oidc_issuer" {
  value = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

output "nameservers" {
  value = data.aws_route53_zone.ingress.name_servers
}