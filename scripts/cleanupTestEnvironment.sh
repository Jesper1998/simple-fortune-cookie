#!/bin/bash

name=${docker_image}-test-${docker_run_id}

echo "Docker image name: ${name}"

[[ -z "${docker_image}" ]] && echo "missing docker_image argument" && exit 1
[[ -z "${docker_run_id}" ]] && echo "missing docker_id argument" && exit 1

if [ ! -z "$(sudo -u ubuntu kubectl get service | grep ${name})" ]; then
    sudo -u ubuntu kubectl delete service ${name}
    [[ "$?" != "0" ]] && exit 1
fi

if [ ! -z "$(sudo -u ubuntu kubectl get deployment | grep ${name})" ]; then
    sudo -u ubuntu kubectl delete deployment ${name}
    exit $?
fi
exit 0