resource "helm_release" "ingress-nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress"
  version          = "4.9.0"
  create_namespace = true
  timeout          = 300

  set {
    name  = "cluster.enabled"
    value = "true"
  }

  set {
    name  = "metrics.enabled"
    value = "true"
  }

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
  }
}


resource "kubernetes_ingress_v1" "frontend" {
  wait_for_load_balancer = true
  metadata {
    name      = "frontend-ingress"
    namespace = kubernetes_namespace.dev.id
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }
  spec {
    tls {
      hosts = [var.domain_name, "www.${var.domain_name}"]
    }
    rule {
      host = var.domain_name
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service_v1.frontend.metadata.0.name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
    rule {
      host = "www.${var.domain_name}"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service_v1.frontend.metadata.0.name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [helm_release.ingress-nginx]
}

resource "kubernetes_ingress_v1" "grafana" {
  wait_for_load_balancer = true
  metadata {
    name      = "grafana-ingress"
    namespace = "kube-prometheus-stack"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }
  spec {
    tls {
      hosts = ["grafana.${var.domain_name}"]
    }
    rule {
      host = "grafana.${var.domain_name}"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "kube-prometheus-stack-grafana"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [helm_release.ingress-nginx]
}
