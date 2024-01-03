resource "helm_release" "argo_cd" {
  name             = "argo-cd"
  namespace        = kubernetes_namespace.argo.id
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.52.0"
  create_namespace = false

  set {
    name  = "server.insecure"
    value = "true"
  }
}