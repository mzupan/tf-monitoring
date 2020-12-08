fullnameOverride: kube-prometheus

alertmanager:
  enabled: false

grafana:
  adminPassword: "password"
  ingress:
    enabled: true
    hosts:
      - grafana.interview.zcentric.com
  sidecar:
    dashboards: 
      enabled: true


prometheus:
  ingress:
    enabled: true
    hosts:
      - prometheus.interview.zcentric.com
  prometheusSpec:
    storage:
      volumeClaimTemplate:
        spec:
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: 20Gi
    ruleSelector:
      matchExpressions:
        - key: app
          operator: In
          values:
            - prometheus
            - prometheus-operator
            - kube-prometheus-stack
    retention: 12h
    walCompression: true
    serviceMonitorSelector: {}
    serviceMonitorSelectorNilUsesHelmValues: false
