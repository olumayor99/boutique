data "aws_caller_identity" "current" {}

module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.12.0" #ensure to update this to the latest/desired version

  cluster_name      = data.aws_eks_cluster.cluster.name
  cluster_endpoint  = data.aws_eks_cluster.cluster.endpoint
  cluster_version   = data.aws_eks_cluster.cluster.version
  oidc_provider_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")}"

  eks_addons = {
    aws-ebs-csi-driver = {
      most_recent = true
    }
    coredns = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
  }

  # enable_aws_load_balancer_controller   = false
  # enable_cluster_autoscaler = true
  # enable_karpenter                      = false
  # enable_external_dns                   = true
  enable_kube_prometheus_stack = true
  enable_metrics_server        = true
  enable_cert_manager                   = true
  cert_manager_route53_hosted_zone_arns = [aws_route53_zone.ingress-nginx.arn]

  tags = {
    Environment = "dev"
  }
}