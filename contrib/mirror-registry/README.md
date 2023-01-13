

Download:

https://github.com/rancher/rke2/releases/download/v1.24.8+rke2r1/rke2-images-all.linux-amd64.txt

Install Skopeo

Example CA for registry

openssl genrsa  -out myCA.key 4096
openssl req -x509 -new -nodes -key myCA.key -sha256 -days 1825 -out myCA.pem

Example Cert for registry

openssl genrsa -out registry.key 4096

openssl req -new -key registry.key -out registry.csr

alt.ext
```
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = rke2-registry.192-168-13-162.nip.io
DNS.2 = rke2-registry
```

```
openssl genrsa -out registry.key 4096
```
```
openssl req -new -key registry.key -out registry.csr
 openssl x509 -req -in registry.csr -CA myCA.pem -CAkey myCA.key -CAcreateserial -out registry.crt -days 825 -sha256 -extfile alt.ext
 ```

Sign CSR
```
openssl x509 -req -extfile alt.ext -in registry.csr -CA myCA.pem -CAkey myCA.key -CAcreateserial -out registry.crt -sha256
```

 
auth/htpasswd
 ```
 rke2:$2y$05$GgJguoCUZZ1iAiyG6iZCB.130/GxJf3Ma7qsB18YOiBJlvXF3tlxO
 ```

setenforce 0

mkdir -p /opt/registry/{auth,certs,data}
cp registry.crt  /opt/registry/certs/
cp registry.key  /opt/registry/certs/
```
 docker run -d -p 8443:5000 --name registry -v "$(pwd)"/data:/var/lib/registry -v "$(pwd)"/auth:/auth -e "REGISTRY_AUTH=htpasswd" -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd -v "$(pwd)"/certs:/certs -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry.crt -e REGISTRY_HTTP_TLS_KEY=/certs/registry.key registry:2
 ```
 
