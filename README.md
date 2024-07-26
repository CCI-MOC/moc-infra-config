This repository manages ArgoCD applications deployed on the MOC managed [moc-infra][] openshift cluster.

[moc-infra]: https://console-openshift-console.apps.moc-infra.massopen.cloud/dashboards

## How to access the cluster

The cluster is on a private network (172.16.0.0/19) that can be reached via our ipmi gateway.

You could use sshuttle to forward your traffic like:

```
sshuttle -r kzn-ipmi-gw.infra.massopen.cloud 172.16.0.0/19
```

## Deploying Secrets

Secrets are stored in AWS Secret Manager and accessed on the cluser via
an `ExternalSecret`. AWS credentials can be found in BitWarden.

The name of the secret must start with `cluster/moc-infra/`. The secret will not be accessible
otherwise. See [example][]

[example]: https://github.com/CCI-MOC/moc-infra-config/blob/f6e71d3cf21ae9166337aaf48de3fd9eb9790ee9/cluster-scope/overlays/moc-infra/externalsecrets/github-secret.yaml
