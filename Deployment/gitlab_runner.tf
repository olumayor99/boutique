resource "helm_release" "gitlab_runner" {
  name             = "gitlab-runner"
  namespace        = kubernetes_namespace.gitlab.id
  repository       = "https://charts.gitlab.io"
  chart            = "gitlab-runner"
  version          = "0.58.2"
  create_namespace = false

  set {
    name  = "rbac.create"
    value = "true"
  }
  set {
    name  = "gitlabUrl"
    value = "https://gitlab.com"
  }
  set {
    name  = "runnerToken"
    value = "glrt-TestW9wo-ZubqLE51Ynp"
  }
  #   set {
  #     name  = "runners.secret"
  #     value = kubernetes_secret.gitlab_runner_secret.metadata[0].name
  #   }

  #   depends_on = [kubernetes_secret.gitlab_runner_secret]
}

# resource "kubernetes_secret" "gitlab_runner_secret" {
#   metadata {
#     name      = "gitlab-runner-secret"
#     namespace = kubernetes_namespace.gitlab.id
#   }

#   data = {
#     runner-token : "glrt-TestW9wo-ZubqLE51Ynp"
#   }

#   type = "Opaque"
# }