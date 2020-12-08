provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.eks.token
    load_config_file       = false
  }
}

data "template_file" "externaldns" {
  template = file("${path.module}/helm/externaldns/values.tpl")

  vars = {
    region  = data.aws_region.current.name
    id      = data.aws_route53_zone.public.zone_id
    rolearn = aws_iam_role.externaldns.arn
  }
}

resource "helm_release" "externaldns" {
  name       = "externaldns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  namespace  = "kube-system"
  version    = "4.0.0"
  values     = [data.template_file.externaldns.rendered]
}


resource "helm_release" "prometheus" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = "kube-system"
  version    = "12.4.0"

  values = [
    file("${path.module}/helm/prometheus/values.tpl")
  ]
}

data "template_file" "nginx" {
  template = file("${path.module}/helm/nginx-ingress/values.tpl")

  vars = {
    acm = aws_acm_certificate.cert.arn
  }
}

resource "helm_release" "nginx" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "kube-system"
  version    = "3.13.0"
  values     = [data.template_file.nginx.rendered]
}


resource "helm_release" "hello" {
  name      = "hello"
  chart     = "${path.module}/helm/hello"
  namespace = "default"
}
