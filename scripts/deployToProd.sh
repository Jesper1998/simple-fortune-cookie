#!/bin/bash

if [ -z "$(sudo -u ubuntu kubectl get deployment | grep deployment-backend)" ]; then
    sudo -u ubuntu kubectl create -f manifest/deployment-backend.yaml
else
    [[ -z "${docker_tag}" ]] && echo "docker_tag: ${docker_tag}"  && exit 1
    [[ -z "${docker_id}" ]] && echo "docker_id: ${docker_id}" && exit 1

    sudo -u ubuntu kubectl set image deployments/deployment-backend ${docker_id}/go_backend:${docker_tag}
fi
[[ "$?" != "0" ]] && exit 1

sudo -u ubuntu kubectl apply -f manifest/service-backend.yaml
[[ "$?" != "0" ]] && exit 1

if [ -z "$(sudo -u ubuntu kubectl get deployment | grep deployment-frontend)" ]; then
    sudo -u ubuntu kubectl create -f manifest/deployment-frontend.yaml
else
    [[ -z "${docker_tag}" ]] && echo "docker_tag: ${docker_tag}"  && exit 1
    [[ -z "${docker_id}" ]] && echo "docker_id: ${docker_id}" && exit 1

    sudo -u ubuntu kubectl image deployments/deployment-frontend ${docker_id}/frontend:${docker_tag}
fi
[[ "$?" != "0" ]] && exit 1

sudo -u ubuntu kubectl apply -f manifest/service-frontend.yaml
exit $?