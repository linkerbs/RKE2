#!/bin/bash -x
#FILENAME=rke2-images-all.linux-amd64.txt
SRC_REGISTRY=$1
DST_REGISTRY=$2
FILENAME=$3

if [ $# -eq 3 ]
then
  AUTH_ARG=''
elif [ $# -eq 4 ]
then
  AUTH_ARG="--authfile $4"
else
  echo "Invalid arguments"
  echo "Example: $0 docker.io myregistry.itm.gt:8443 /tmp/rke2-images-all.linux-amd64.txt [AUTHFILE]" 
  exit 1
fi


for image in $(cat ${FILENAME})
do
 dest=$(echo ${image}|sed "s/${SRC_REGISTRY}/${DST_REGISTRY}/g")
 echo "${image} to ${dest}"
 skopeo copy docker://${image} docker://${dest} ${AUTH_ARG}  --src-tls-verify=false --dest-tls-verify=false
done
