resource "kubernetes_service_v1" "emailservice" {
  metadata {
    name      = "emailservice"
    namespace = kubernetes_namespace.dev.id
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.emailservice.spec.0.template.0.metadata.0.labels.app
    }
    port {
      name        = "grpc"
      port        = 5000
      target_port = 8080
      protocol    = "TCP"
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_service_v1" "checkoutservice" {
  metadata {
    name      = "checkoutservice"
    namespace = kubernetes_namespace.dev.id
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.checkoutservice.spec.0.template.0.metadata.0.labels.app
    }
    port {
      name        = "grpc"
      port        = 5050
      target_port = 5050
      protocol    = "TCP"
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_service_v1" "recommendationservice" {
  metadata {
    name      = "recommendationservice"
    namespace = kubernetes_namespace.dev.id
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.recommendationservice.spec.0.template.0.metadata.0.labels.app
    }
    port {
      name        = "grpc"
      port        = 8080
      target_port = 8080
      protocol    = "TCP"
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_service_v1" "frontend" {
  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace.dev.id
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.frontend.spec.0.template.0.metadata.0.labels.app
    }
    port {
      name        = "grpc"
      port        = 80
      target_port = 8080
      protocol    = "TCP"
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_service_v1" "paymentservice" {
  metadata {
    name      = "paymentservice"
    namespace = kubernetes_namespace.dev.id
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.paymentservice.spec.0.template.0.metadata.0.labels.app
    }
    port {
      name        = "grpc"
      port        = 50051
      target_port = 50051
      protocol    = "TCP"
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_service_v1" "productcatalogservice" {
  metadata {
    name      = "productcatalogservice"
    namespace = kubernetes_namespace.dev.id
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.productcatalogservice.spec.0.template.0.metadata.0.labels.app
    }
    port {
      name        = "grpc"
      port        = 3550
      target_port = 3550
      protocol    = "TCP"
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_service_v1" "cartservice" {
  metadata {
    name      = "cartservice"
    namespace = kubernetes_namespace.dev.id
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.cartservice.spec.0.template.0.metadata.0.labels.app
    }
    port {
      name        = "grpc"
      port        = 7070
      target_port = 7070
      protocol    = "TCP"
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_service_v1" "currencyservice" {
  metadata {
    name      = "currencyservice"
    namespace = kubernetes_namespace.dev.id
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.currencyservice.spec.0.template.0.metadata.0.labels.app
    }
    port {
      name        = "grpc"
      port        = 7000
      target_port = 7000
      protocol    = "TCP"
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_service_v1" "shippingservice" {
  metadata {
    name      = "shippingservice"
    namespace = kubernetes_namespace.dev.id
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.shippingservice.spec.0.template.0.metadata.0.labels.app
    }
    port {
      name        = "grpc"
      port        = 50051
      target_port = 50051
      protocol    = "TCP"
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_service_v1" "redis-cart" {
  metadata {
    name      = "redis-cart"
    namespace = kubernetes_namespace.dev.id
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.redis_cart.spec.0.template.0.metadata.0.labels.app
    }
    port {
      name        = "tcp-redis"
      port        = 6379
      target_port = 6379
      protocol    = "TCP"
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_service_v1" "adservice" {
  metadata {
    name      = "adservice"
    namespace = kubernetes_namespace.dev.id
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.adservice.spec.0.template.0.metadata.0.labels.app
    }
    port {
      name        = "grpc"
      port        = 9555
      target_port = 9555
      protocol    = "TCP"
    }
    type = "ClusterIP"
  }
}