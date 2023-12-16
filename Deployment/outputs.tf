output "load_balancer_hostname" {
  value = kubernetes_ingress_v1.sre-task.status.0.load_balancer.0.ingress.0.hostname
}

output "oidc_issuer" {
  value = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}