# Deploying PostgresSQL to cluster

make Bitnami charts available to cluster if they aren't already (also needed for mongodb)

```shell script
helm repo add bitnami https://charts.bitnami.com/bitnami
```

then deploy the chart.
```shell script
helm upgrade --install --debug --wait -n <namespace> <full-name> bitnami/postgresql -f <path-to-postgres-values-yaml>
```
The connection string for hydra will be the following:

`postgres://<user>:<user-password>@<postgress-service>.<namespace>/hydra?sslmode=disable`
## add the client ids to hydra

the hydra pod needs to be deployed/running for this
get the pod names with 
```shell script
kubectl get pods -n <namespace>
```
### storefront
```shell script
kubectl exec -it <hydra-pod> -n <namespace> hydra -- clients create /
    --callbacks "https://<storefront-url>/callback" /
    --grant-types authorization_code,refresh_token --id hyb-storefront /
    --secret <storefront-client-secret> --response-types token,code /
    --token-endpoint-auth-method client_secret_post /
    --config /etc/config/config.yaml /
    --endpoint http://<hydra-admin-service>.<namespace>:4445
```
### admin
```shell script
kubectl exec -it <hydra-pod> -n <namespace> hydra -- clients create /
    --callbacks "https://<admin-url>/authentication/callback","https://<admin-url>/authentication/silent_callback" /
    --grant-types authorization_code --id reaction-admin /
    --secret <admin-client-secret> --response-types code /
    --config /etc/config/config.yaml /
    --endpoint http://<hydra-admin-service>.<namespace>:4445
```
