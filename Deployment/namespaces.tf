resource "kubernetes_namespace" "prometheus" {
  metadata {
    name = "prometheus"
  }
}

resource "kubernetes_namespace" "dev" {
  metadata {
    name = "dev"
  }
}

resource "kubernetes_namespace" "argo" {
  metadata {
    name = "argo-cd"
  }
}

resource "kubernetes_namespace" "gitlab" {
  metadata {
    name = "gitlab"
  }
}