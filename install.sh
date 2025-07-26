#!/bin/bash

# inject .env file variables
source .env
source utils.sh

install_rhdh_operator

oc apply -f namespace.yaml

oc create secret generic secrets-rhdh \
  --from-literal=RBAC_ADMIN_USER="$RBAC_ADMIN_USER" \
  --from-literal=DOMAIN="$DOMAIN" \
  --from-literal=GITHUB_APP_APP_ID="$GITHUB_APP_APP_ID" \
  --from-literal=GITHUB_APP_CLIENT_ID="$GITHUB_APP_CLIENT_ID" \
  --from-literal=GITHUB_APP_CLIENT_SECRET="$GITHUB_APP_CLIENT_SECRET" \
  --from-literal=GITHUB_APP_WEBHOOK_URL="$GITHUB_APP_WEBHOOK_URL" \
  --from-literal=GITHUB_APP_WEBHOOK_SECRET="$GITHUB_APP_WEBHOOK_SECRET" \
  --from-file=GITHUB_APP_PRIVATE_KEY="$GITHUB_APP_PRIVATE_KEY" \
  --from-literal=AUTH_GITHUB_CLIENT_ID="$AUTH_GITHUB_CLIENT_ID" \
  --from-literal=AUTH_GITHUB_CLIENT_SECRET="$AUTH_GITHUB_CLIENT_SECRET" \
  --from-literal=GITHUB_TOKEN="$GITHUB_TOKEN" \
  -n rhdh \
  --dry-run=client -o yaml | oc apply -f -

oc apply -f app-config-rhdh.yaml -f dynamic-plugins-configmap.yaml

# Replace cluster url and apply custom resource Backstage to the cluster.
# Operator will install it.
CR="$(pwd)/backstage-cr.yaml"
echo "${CR}"
yq eval ".spec.deployment.patch.spec.template.spec.containers[0].image = \"${IMAGE}\"" "${CR}" \
| yq eval ".spec.deployment.patch.spec.template.spec.initContainers[0].image = \"${IMAGE}\"" \
| yq eval ".spec.deployment.patch.spec.template.spec.initContainers[1].image = \"${IMAGE}\"" \
| oc apply -f -
