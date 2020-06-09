### MongoDB for cluster

#### deploy the MongoDB chart to the cluster:
we can take the Bitnami chart and make it available in the cluster then use it with a values file for customization
```shell script
helm repo add bitnami https://charts.bitnami.com/bitnami
helm upgrade --install --debug --wait -n <namespace> <deployment-name> bitnami/mongodb -f <path-to-mongodb-values-yaml>
```
this should deploy the mongodb to the cluster and run it

#### Setting up the database user
We want to create a custom user so that we don't have to use the root one. so we:

connect to the Mongodb:

```shell script
kubectl port-forward -n <namespace> svc/<mongo-servicename> 27017:27017
mongo --host localhost --authenticationDatabase admin -p <root-pw> --username root
```
And add the database user for reaction:
```
use admin
db.createUser({
    user:"<username>",
    pwd:"<password>",
    roles:[{
        role:"readWriteAnyDatabase",db:"admin"
    },{
        role:"clusterManager",db:"admin"
    },{
        role:"readWrite",db:"local"
    },{
        role:"readWrite", db:"<store-db>"
    }],
    mechanisms:["SCRAM-SHA-1"]
})
```
where username and password go into the connection string for the MongoDB, so it will look like this:

`mongodb://<username>:<password>@<mongo-service-name>.<namespace>:27017/<store-db>?authSource=admin&replicaSet=rs0`

for the oplog connection:

`mongodb://<username>:<password>@<mongo-service-name>.<namespace>:27017/local?authSource=admin&replicaSet=rs0`
