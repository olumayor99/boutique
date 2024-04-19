resource "helm_release" "new_relic" {
  name             = "new-relic"
  repository       = "https://helm-charts.newrelic.com"
  chart            = "nri-bundle"
  namespace        = "newrelic"
  version          = var.new_relic_version
  create_namespace = true

  set {
    name  = "global.licenseKey"
    value = var.global_license_key
  }

  set {
    name  = "global.cluster"
    value = data.aws_eks_cluster.cluster.name
  }

  set {
    name  = "newrelic-infrastructure.privileged"
    value = "true"
  }

  set {
    name  = "global.lowDataMode"
    value = "true"
  }

  set {
    name  = "kube-state-metrics.image.tag"
    value = "v2.10.0"
  }

  set {
    name  = "kube-state-metrics.enabled"
    value = "true"
  }

  set {
    name  = "kubeEvents.enabled"
    value = "true"
  }

  set {
    name  = "newrelic-prometheus-agent.enabled"
    value = "true"
  }

  set {
    name  = "newrelic-prometheus-agent.lowDataMode"
    value = "true"
  }

  set {
    name  = "newrelic-prometheus-agent.config.kubernetes.integrations_filter.enabled"
    value = "false"
  }

  set {
    name  = "logging.enabled"
    value = "true"
  }

  set {
    name  = "newrelic-logging.lowDataMode"
    value = "false"
  }

  set {
    name  = "newrelic-pixie.enabled"
    value = "true"
  }

  set {
    name  = "newrelic-pixie.apiKey"
    value = var.pixie_api_key
  }

  set {
    name  = "pixie-chart.enabled"
    value = "true"
  }

  set {
    name  = "pixie-chart.deployKey"
    value = var.pixie_deploy_key
  }

  set {
    name  = "pixie-chart.clusterName"
    value = data.aws_eks_cluster.cluster.name
  }
}