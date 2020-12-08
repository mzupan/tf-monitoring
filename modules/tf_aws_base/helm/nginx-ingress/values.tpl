controller:
  replicaCount: 1
  ingressClass: nginx
  stats:
    enabled: true
  config:
    use-forwarded-headers: "true"
  publishService:
    enabled: true
  metrics:
    enabled: true
    serviceMonitor:
      enabled: true
      namespace: kube-system
      additionalLabels:
        release: prometheus-operator
      scrapeInterval: 5s
  service:
    targetPorts:
      http: http
      https: http
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout: "60"
      service.beta.kubernetes.io/aws-load-balancer-ssl-cert: ${acm}
      service.beta.kubernetes.io/aws-load-balancer-ssl-ports: https
      service.beta.kubernetes.io/aws-load-balancer-backend-protocol: "http"
  