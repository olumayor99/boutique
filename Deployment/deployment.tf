resource "kubernetes_deployment_v1" "emailservice" {
  metadata {
    name      = "emailservice"
    namespace = kubernetes_namespace.dev.id
  }

  spec {
    selector {
      match_labels = {
        app = "emailservice"
      }
    }

    template {
      metadata {
        labels = {
          app = "emailservice"
        }
      }

      spec {
        service_account_name             = "default"
        termination_grace_period_seconds = 5

        security_context {
          fs_group        = 1000
          run_as_group    = 1000
          run_as_non_root = true
          run_as_user     = 1000
        }

        container {
          name = "server"

          security_context {
            allow_privilege_escalation = false
            capabilities {
              drop = ["ALL"]
            }
            privileged                = false
            read_only_root_filesystem = true
          }

          image = "gcr.io/google-samples/microservices-demo/emailservice:v0.8.1"

          port {
            container_port = 8080
          }

          env {
            name  = "PORT"
            value = "8080"
          }

          env {
            name  = "DISABLE_PROFILER"
            value = "1"
          }

          readiness_probe {
            period_seconds = 5
            grpc {
              port = 8080
            }
          }

          liveness_probe {
            period_seconds = 5
            grpc {
              port = 8080
            }
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "64Mi"
            }
            limits = {
              cpu    = "200m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment_v1" "checkoutservice" {
  metadata {
    name      = "checkoutservice"
    namespace = kubernetes_namespace.dev.id
  }

  spec {
    selector {
      match_labels = {
        app = "checkoutservice"
      }
    }

    template {
      metadata {
        labels = {
          app = "checkoutservice"
        }
      }

      spec {
        service_account_name = "default"

        security_context {
          fs_group        = 1000
          run_as_group    = 1000
          run_as_non_root = true
          run_as_user     = 1000
        }

        container {
          name = "server"

          security_context {
            allow_privilege_escalation = false
            capabilities {
              drop = ["ALL"]
            }
            privileged                = false
            read_only_root_filesystem = true
          }

          image = "gcr.io/google-samples/microservices-demo/checkoutservice:v0.8.1"

          port {
            container_port = 5050
          }

          readiness_probe {
            grpc {
              port = 5050
            }
          }

          liveness_probe {
            grpc {
              port = 5050
            }
          }

          env {
            name  = "PORT"
            value = "5050"
          }
          env {
            name  = "PRODUCT_CATALOG_SERVICE_ADDR"
            value = "productcatalogservice:3550"
          }
          env {
            name  = "SHIPPING_SERVICE_ADDR"
            value = "shippingservice:50051"
          }
          env {
            name  = "PAYMENT_SERVICE_ADDR"
            value = "paymentservice:50051"
          }
          env {
            name  = "EMAIL_SERVICE_ADDR"
            value = "emailservice:5000"
          }
          env {
            name  = "CURRENCY_SERVICE_ADDR"
            value = "currencyservice:7000"
          }
          env {
            name  = "CART_SERVICE_ADDR"
            value = "cartservice:7070"
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "64Mi"
            }
            limits = {
              cpu    = "200m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment_v1" "recommendationservice" {
  metadata {
    name      = "recommendationservice"
    namespace = kubernetes_namespace.dev.id
  }

  spec {
    selector {
      match_labels = {
        app = "recommendationservice"
      }
    }

    template {
      metadata {
        labels = {
          app = "recommendationservice"
        }
      }

      spec {
        service_account_name             = "default"
        termination_grace_period_seconds = 5

        security_context {
          fs_group        = 1000
          run_as_group    = 1000
          run_as_non_root = true
          run_as_user     = 1000
        }

        container {
          name = "server"

          security_context {
            allow_privilege_escalation = false

            capabilities {
              drop = ["ALL"]
            }

            privileged                = false
            read_only_root_filesystem = true
          }

          image = "gcr.io/google-samples/microservices-demo/recommendationservice:v0.8.1"

          port {
            container_port = 8080
          }

          readiness_probe {
            period_seconds = 5

            grpc {
              port = 8080
            }
          }

          liveness_probe {
            period_seconds = 5

            grpc {
              port = 8080
            }
          }

          env {
            name  = "PORT"
            value = "8080"
          }

          env {
            name  = "PRODUCT_CATALOG_SERVICE_ADDR"
            value = "productcatalogservice:3550"
          }

          env {
            name  = "DISABLE_PROFILER"
            value = "1"
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "220Mi"
            }

            limits = {
              cpu    = "200m"
              memory = "450Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment_v1" "frontend" {
  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace.dev.id
  }

  spec {
    selector {
      match_labels = {
        app = "frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "frontend"
        }
        annotations = {
          "sidecar.istio.io/rewriteAppHTTPProbers" = "true"
        }
      }

      spec {
        service_account_name = "default"

        security_context {
          fs_group        = 1000
          run_as_group    = 1000
          run_as_non_root = true
          run_as_user     = 1000
        }

        container {
          name = "server"

          security_context {
            allow_privilege_escalation = false
            capabilities {
              drop = ["ALL"]
            }
            privileged                = false
            read_only_root_filesystem = true
          }

          image = "gcr.io/google-samples/microservices-demo/frontend:v0.8.1"

          port {
            container_port = 8080
          }

          readiness_probe {
            initial_delay_seconds = 10

            http_get {
              path = "/_healthz"
              port = 8080

              http_header {
                name  = "Cookie"
                value = "shop_session-id=x-readiness-probe"
              }
            }
          }

          liveness_probe {
            initial_delay_seconds = 10

            http_get {
              path = "/_healthz"
              port = 8080

              http_header {
                name  = "Cookie"
                value = "shop_session-id=x-liveness-probe"
              }
            }
          }

          env {
            name  = "PORT"
            value = "8080"
          }
          env {
            name  = "PRODUCT_CATALOG_SERVICE_ADDR"
            value = "productcatalogservice:3550"
          }
          env {
            name  = "CURRENCY_SERVICE_ADDR"
            value = "currencyservice:7000"
          }
          env {
            name  = "CART_SERVICE_ADDR"
            value = "cartservice:7070"
          }
          env {
            name  = "RECOMMENDATION_SERVICE_ADDR"
            value = "recommendationservice:8080"
          }
          env {
            name  = "SHIPPING_SERVICE_ADDR"
            value = "shippingservice:50051"
          }
          env {
            name  = "CHECKOUT_SERVICE_ADDR"
            value = "checkoutservice:5050"
          }
          env {
            name  = "AD_SERVICE_ADDR"
            value = "adservice:9555"
          }
          env {
            name  = "ENV_PLATFORM" # ENV_PLATFORM: One of: local, gcp, aws, azure, onprem, alibaba. When not set, defaults to "local" unless running in GKE, otherwies auto-sets to gcp
            value = "aws"
          }
          env {
            name  = "ENABLE_PROFILER"
            value = "0"
          }
          env {
            name  = "CYMBAL_BRANDING"
            value = "true"
          }
          env {
            name  = "FRONTEND_MESSAGE"
            value = "Follow along on Doyenify.com."
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "64Mi"
            }
            limits = {
              cpu    = "200m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment_v1" "paymentservice" {
  metadata {
    name      = "paymentservice"
    namespace = kubernetes_namespace.dev.id
  }

  spec {
    selector {
      match_labels = {
        app = "paymentservice"
      }
    }

    template {
      metadata {
        labels = {
          app = "paymentservice"
        }
      }

      spec {
        service_account_name             = "default"
        termination_grace_period_seconds = 5

        security_context {
          fs_group        = 1000
          run_as_group    = 1000
          run_as_non_root = true
          run_as_user     = 1000
        }

        container {
          name = "server"

          security_context {
            allow_privilege_escalation = false
            capabilities {
              drop = ["ALL"]
            }
            privileged                = false
            read_only_root_filesystem = true
          }

          image = "gcr.io/google-samples/microservices-demo/paymentservice:v0.8.1"

          port {
            container_port = 50051
          }

          env {
            name  = "PORT"
            value = "50051"
          }

          env {
            name  = "DISABLE_PROFILER"
            value = "1"
          }

          readiness_probe {
            grpc {
              port = 50051
            }
          }

          liveness_probe {
            grpc {
              port = 50051
            }
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "64Mi"
            }
            limits = {
              cpu    = "200m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment_v1" "productcatalogservice" {
  metadata {
    name      = "productcatalogservice"
    namespace = kubernetes_namespace.dev.id
  }

  spec {
    selector {
      match_labels = {
        app = "productcatalogservice"
      }
    }

    template {
      metadata {
        labels = {
          app = "productcatalogservice"
        }
      }

      spec {
        service_account_name             = "default"
        termination_grace_period_seconds = 5

        security_context {
          fs_group        = 1000
          run_as_group    = 1000
          run_as_non_root = true
          run_as_user     = 1000
        }

        container {
          name = "server"

          security_context {
            allow_privilege_escalation = false

            capabilities {
              drop = ["ALL"]
            }

            privileged                = false
            read_only_root_filesystem = true
          }

          image = "gcr.io/google-samples/microservices-demo/productcatalogservice:v0.8.1"

          port {
            container_port = 3550
          }

          env {
            name  = "PORT"
            value = "3550"
          }

          env {
            name  = "DISABLE_PROFILER"
            value = "1"
          }

          readiness_probe {
            grpc {
              port = 3550
            }
          }

          liveness_probe {
            grpc {
              port = 3550
            }
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "64Mi"
            }

            limits = {
              cpu    = "200m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment_v1" "cartservice" {
  metadata {
    name      = "cartservice"
    namespace = kubernetes_namespace.dev.id
  }

  spec {
    selector {
      match_labels = {
        app = "cartservice"
      }
    }

    template {
      metadata {
        labels = {
          app = "cartservice"
        }
      }

      spec {
        service_account_name             = "default"
        termination_grace_period_seconds = 5

        security_context {
          fs_group        = 1000
          run_as_group    = 1000
          run_as_non_root = true
          run_as_user     = 1000
        }

        container {
          name = "server"

          security_context {
            allow_privilege_escalation = false

            capabilities {
              drop = ["ALL"]
            }

            privileged                = false
            read_only_root_filesystem = true
          }

          image = "gcr.io/google-samples/microservices-demo/cartservice:v0.8.1"

          port {
            container_port = 7070
          }

          env {
            name  = "REDIS_ADDR"
            value = "redis-cart:6379"
          }

          resources {
            requests = {
              cpu    = "200m"
              memory = "64Mi"
            }

            limits = {
              cpu    = "300m"
              memory = "128Mi"
            }
          }

          readiness_probe {
            initial_delay_seconds = 15

            grpc {
              port = 7070
            }
          }

          liveness_probe {
            initial_delay_seconds = 15
            period_seconds        = 10

            grpc {
              port = 7070
            }
          }
        }
      }
    }
  }
}

# resource "kubernetes_deployment_v1" "loadgenerator" {
#   metadata {
#     name      = "loadgenerator"
#     namespace = kubernetes_namespace.dev.id
#   }

#   spec {
#     selector {
#       match_labels = {
#         app = "loadgenerator"
#       }
#     }

#     replicas = 1

#     template {
#       metadata {
#         labels = {
#           app = "loadgenerator"
#         }
#         annotations = {
#           "sidecar.istio.io/rewriteAppHTTPProbers" = "true"
#         }
#       }

#       spec {
#         service_account_name             = "default"
#         termination_grace_period_seconds = 5
#         restart_policy                   = "Always"

#         security_context {
#           fs_group        = 1000
#           run_as_group    = 1000
#           run_as_non_root = true
#           run_as_user     = 1000
#         }

#         init_container {
#           name = "frontend-check"

#           security_context {
#             allow_privilege_escalation = false
#             capabilities {
#               drop = ["ALL"]
#             }
#             privileged                = false
#             read_only_root_filesystem = true
#           }

#           image = "busybox:latest"

#           env {
#             name  = "FRONTEND_ADDR"
#             value = "frontend:80"
#           }

#           command = [
#             "/bin/sh", "-exc", "echo 'Init container pinging frontend: ${FRONTEND_ADDR}...'; STATUSCODE=$(wget --server-response http://${FRONTEND_ADDR} 2>&1 | awk '/^  HTTP/{print $2}'); if test $STATUSCODE -ne 200; then echo 'Error: Could not reach frontend - Status code: ${STATUSCODE}'; exit 1; fi"
#           ]

#         }

#         container {
#           name = "main"

#           security_context {
#             allow_privilege_escalation = false
#             capabilities {
#               drop = ["ALL"]
#             }
#             privileged                = false
#             read_only_root_filesystem = true
#           }

#           image = "gcr.io/google-samples/microservices-demo/loadgenerator:v0.8.1"

#           env {
#             name  = "FRONTEND_ADDR"
#             value = "frontend:80"
#           }
#           env {
#             name  = "USERS"
#             value = "10"
#           }

#           resources {
#             requests = {
#               cpu    = "300m"
#               memory = "256Mi"
#             }
#             limits = {
#               cpu    = "500m"
#               memory = "512Mi"
#             }
#           }
#         }
#       }
#     }
#   }
# }

resource "kubernetes_deployment_v1" "currencyservice" {
  metadata {
    name      = "currencyservice"
    namespace = kubernetes_namespace.dev.id
  }

  spec {
    selector {
      match_labels = {
        app = "currencyservice"
      }
    }

    template {
      metadata {
        labels = {
          app = "currencyservice"
        }
      }

      spec {
        service_account_name             = "default"
        termination_grace_period_seconds = 5

        security_context {
          fs_group        = 1000
          run_as_group    = 1000
          run_as_non_root = true
          run_as_user     = 1000
        }

        container {
          name = "server"

          security_context {
            allow_privilege_escalation = false

            capabilities {
              drop = ["ALL"]
            }

            privileged                = false
            read_only_root_filesystem = true
          }

          image = "gcr.io/google-samples/microservices-demo/currencyservice:v0.8.1"

          port {
            name           = "grpc"
            container_port = 7000
          }

          env {
            name  = "PORT"
            value = "7000"
          }

          env {
            name  = "DISABLE_PROFILER"
            value = "1"
          }

          readiness_probe {
            grpc {
              port = 7000
            }
          }

          liveness_probe {
            grpc {
              port = 7000
            }
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "64Mi"
            }

            limits = {
              cpu    = "200m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment_v1" "shippingservice" {
  metadata {
    name      = "shippingservice"
    namespace = kubernetes_namespace.dev.id
  }

  spec {
    selector {
      match_labels = {
        app = "shippingservice"
      }
    }

    template {
      metadata {
        labels = {
          app = "shippingservice"
        }
      }

      spec {
        service_account_name = "default"

        security_context {
          fs_group        = 1000
          run_as_group    = 1000
          run_as_non_root = true
          run_as_user     = 1000
        }

        container {
          name = "server"

          security_context {
            allow_privilege_escalation = false
            capabilities {
              drop = ["ALL"]
            }
            privileged                = false
            read_only_root_filesystem = true
          }

          image = "gcr.io/google-samples/microservices-demo/shippingservice:v0.8.1"

          port {
            container_port = 50051
          }

          env {
            name  = "PORT"
            value = "50051"
          }

          env {
            name  = "DISABLE_PROFILER"
            value = "1"
          }

          readiness_probe {
            period_seconds = 5
            grpc {
              port = 50051
            }
          }

          liveness_probe {
            grpc {
              port = 50051
            }
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "64Mi"
            }
            limits = {
              cpu    = "200m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment_v1" "redis_cart" {
  metadata {
    name      = "redis-cart"
    namespace = kubernetes_namespace.dev.id
  }

  spec {
    selector {
      match_labels = {
        app = "redis-cart"
      }
    }

    template {
      metadata {
        labels = {
          app = "redis-cart"
        }
      }

      spec {
        security_context {
          fs_group        = 1000
          run_as_group    = 1000
          run_as_non_root = true
          run_as_user     = 1000
        }

        container {
          name = "redis"

          security_context {
            allow_privilege_escalation = false
            capabilities {
              drop = ["ALL"]
            }
            privileged                = false
            read_only_root_filesystem = true
          }

          image = "redis:alpine"

          port {
            container_port = 6379
          }

          readiness_probe {
            period_seconds = 5
            tcp_socket {
              port = 6379
            }
          }

          liveness_probe {
            period_seconds = 5
            tcp_socket {
              port = 6379
            }
          }

          volume_mount {
            mount_path = "/data"
            name       = "redis-data"
          }

          resources {
            limits = {
              memory = "256Mi"
              cpu    = "125m"
            }
            requests = {
              cpu    = "70m"
              memory = "200Mi"
            }
          }
        }

        volume {
          name = "redis-data"
          empty_dir {}
        }
      }
    }
  }
}

resource "kubernetes_deployment_v1" "adservice" {
  metadata {
    name      = "adservice"
    namespace = kubernetes_namespace.dev.id
  }

  spec {
    selector {
      match_labels = {
        app = "adservice"
      }
    }

    template {
      metadata {
        labels = {
          app = "adservice"
        }
      }

      spec {
        service_account_name             = "default"
        termination_grace_period_seconds = 5

        security_context {
          fs_group        = 1000
          run_as_group    = 1000
          run_as_non_root = true
          run_as_user     = 1000
        }

        container {
          name = "server"

          security_context {
            allow_privilege_escalation = false
            capabilities {
              drop = ["ALL"]
            }
            privileged                = false
            read_only_root_filesystem = true
          }

          image = "gcr.io/google-samples/microservices-demo/adservice:v0.8.1"

          port {
            container_port = 9555
          }

          env {
            name  = "PORT"
            value = "9555"
          }

          resources {
            requests = {
              cpu    = "200m"
              memory = "180Mi"
            }
            limits = {
              cpu    = "300m"
              memory = "300Mi"
            }
          }

          readiness_probe {
            initial_delay_seconds = 20
            period_seconds        = 15

            grpc {
              port = 9555
            }
          }

          liveness_probe {
            initial_delay_seconds = 20
            period_seconds        = 15

            grpc {
              port = 9555
            }
          }
        }
      }
    }
  }
}

