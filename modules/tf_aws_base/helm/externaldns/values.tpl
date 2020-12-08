fullnameOverride: externaldns

provider: aws

aws:
  region: "${region}"

serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: ${rolearn}

txtOwnerId: eks-externaldns
publishInternalServices: true
logLevel: debug

zoneIdFilters:
  - ${id}

metrics:
  enabled: true
  serviceMonitor:
    enabled: true
    selector:
      release: prometheus-operator
