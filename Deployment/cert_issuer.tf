resource "kubectl_manifest" "cert_issuer" {
   yaml_body = <<YAML
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: letsencrypt-prod
    spec:
      acme:
        email: oom.taiwo@gmail.com
        privateKeySecretRef:
          name: letsencrypt-prod-tls
        server: https://acme-v02.api.letsencrypt.org/directory
        solvers:
        - http01:
            ingress:
              class: nginx
    YAML
    depends_on = [module.eks_blueprints_addons]
}

