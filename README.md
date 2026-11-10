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
an `ExternalSecret`.

The name of the secret must start with `cluster/moc-infra/`. The secret will not be accessible
otherwise. See [example][]

[example]: https://github.com/CCI-MOC/moc-infra-config/blob/f6e71d3cf21ae9166337aaf48de3fd9eb9790ee9/cluster-scope/overlays/moc-infra/externalsecrets/github-secret.yaml

## AWS access (OIDC)

The cluster authenticates to AWS with its own ServiceAccount tokens; there are no
static AWS credentials. The cluster's `serviceAccountIssuer` is set to
`https://oac-clusters-oidc.s3.us-east-1.amazonaws.com/moc-infra`, where its OIDC
discovery documents are published. The IAM OIDC provider and roles are managed by
the `openshift-oidc` module in [moc-aws][]:

| Role                     | Assumed by ServiceAccount              | Used for                      |
| ------------------------ | -------------------------------------- | ----------------------------- |
| `eso-moc-infra`          | `external-secrets/external-secrets-sa` | Reading `cluster/moc-infra/*` |
| `cert-manager-moc-infra` | `cert-manager/cert-manager`            | Route53 DNS-01 challenges     |

If the cluster's service account signing keys rotate, re-publish the discovery
documents with `CLUSTER_NAME=moc-infra bootstrap/setup-oidc.sh -f -n` from
[oac-apps][].

[moc-aws]: https://github.com/CCI-MOC/moc-aws
[oac-apps]: https://github.com/CCI-MOC/oac-apps
