# RKE2 Management

## Usage

```sh
 ansible-playbook site.yaml -u REMOTE_USERNAME -i examples-inventory/inventory_file_or_location
```
### Example:

```sh
 ansible-playbook site.yaml -u devops -i examples-inventory/master-worker
```

## Inventory

### Variables

|        NAME      |                    DESCRIPTION                            |
| -----------------| --------------------------------------------------------- |
|rke2_method       |Type of installantion for RKE2: ```rpm``` or ```tar```|
|rke2_version      |Kubernetes RKE2 major version to be installed: ```v1.24.8+rke2r1``` [https://github.com/rancher/rke2/releases]|
|cluster_api_fqdn  |FQDN for Cluster API LB. If LB is not used, could be the first bootstrap FQDN.|
|master_api_fqdn   |FQDN for Master API LB. If LB is not used, could be the first bootstrap FQDN.|
|master_taint      |Prevent user workload to be executed on the control plane: ```true``` or ```false``` |
|cluster_cidr      |Network to be used for pods, if not specified default will be used.|
|service_cidr      |Network to be used for services, if not specified default will be used.|
|cis               |Install a Kubernetes cluster that comply with CIS 1.6: ```true``` or ```false```|
|rke2_node_type    |Type of node to be installed: ```server``` or ```agent```. This must be defined as a group variable.|
|disconnected      |Install a Kubernetes cluster that comply with CIS 1.6: ```true``` or ```false```|

### Example Inventory:
```
[all:vars]
rke2_method=rpm
rke2_version=v1.24.8+rke2r1
cluster_api_fqdn=student-2-aio.c.rancher-training-342718.internal
master_api_fqdn=student-2-aio.c.rancher-training-342718.internal
master_taint=false 
#cluster_cidr=10.211.0.0/16
#service_cidr=172.211.0.0/16
cis=false

[masters:vars]
rke2_node_type=server

[workers:vars]
rke2_node_type=agent

[ingress:vars]


[masters]
student-2-aio ansible_host=34.105.49.88
[workers]
student-5-aio ansible_host=34.105.36.147

[lb]
[bootstrap]
student-2-aio
[ingress]
student-2-aio
```

Local backup on demand
```
rke2 etcd-snapshot
```

Remote backup on demand
```
rke2 etcd-snapshot --s3 --s3-bucket="BUCKET NAME" --s3-access-key="ACCESS KEY" --s3-secret-key="SECRET KEY" --s3-insecure --s3-endpoint IP:9000
```

List backups
```
rke2 etcd-snapshot ls
```

Restore
```
rke2 server --cluster-reset-restore-path /var/lib/rancher/rke2/server/db/snapshots/ETCD-SNAPSHOT-NAME --cluster-reset
```
