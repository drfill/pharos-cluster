#!/bin/bash

set -ue

if [[ $DRONE_COMMIT_MESSAGE != *"[cluster-e2e]"* ]]; then
    echo "Commit message does not contain [cluster-e2e], skipping."
    exit 0
fi

cd e2e/digitalocean
terraform init

until terraform apply -auto-approve -var "cluster_name=${DRONE_BUILD_NUMBER}-do" -var "image=$1"
do
  echo "Apply failed... trying again in 5s"
  sleep 5
done

terraform output -json > tf.json

if [ "$1" = "ubuntu-18-04-x64" ]; then
  jq ".worker_up.value.address[0]" tf.json | sed 's/"//g' > worker_up_address.txt
  jq ".pharos_hosts.value.masters[0].address[0]" tf.json | sed 's/"//g' > master_address.txt
fi

sleep 10
