# Prerequisites

Openshift cluster with installed RHDH operator. Installed yq, oc.

yq - (https://github.com/mikefarah/yq) can be installed with help of Python package manager: 

```
pip install yq
```

# How to use

1. Login to the cluster.

2. Create env file

```
mkdir -p .env
```

3. Specify env variables:

```
DOMAIN=
IMAGE=
RBAC_ADMIN_USER=

AUTH_GITHUB_CLIENT_ID=
AUTH_GITHUB_CLIENT_SECRET=

GITHUB_APP_APP_ID=
GITHUB_APP_CLIENT_ID=
GITHUB_APP_CLIENT_SECRET=
GITHUB_APP_WEBHOOK_URL=
GITHUB_APP_WEBHOOK_SECRET=
GITHUB_APP_PRIVATE_KEY=
```

4. Change/specify catalog links in the [text](app-config-rhdh.yaml) if needed.

5. Execute install.sh:

```
./install.sh
```

6. Don't forget to check urls in the github OAuth and github application configurations to make working login and import from catalogs.
