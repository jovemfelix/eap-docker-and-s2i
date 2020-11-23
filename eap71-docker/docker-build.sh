#!/bin/bash
set -e

echo "---------------------------------------------------------------------------------"
echo "- helpers-"
echo "---------------------------------------------------------------------------------"
export KUBECONFIG=$PWD/kubeconfig-admin
export USER_ID=$(oc whoami)

OCP_REGISTRY=$(oc get route docker-registry -n default -o 'jsonpath={.spec.host}{"\n"}') || exit 1 # url do registry docker do openshift

systemctl status docker.service

PROJETO_IMAGE_BASE=${USER_ID}-build-eap-docker

echo "---------------------------------------------------------------------------------"
echo "- new-project- ${PROJETO_IMAGE_BASE}"
echo "---------------------------------------------------------------------------------"
oc new-project "${PROJETO_IMAGE_BASE}"

echo "---------------------------------------------------------------------------------"
echo "- docker login- OCP_REGISTRY = ${OCP_REGISTRY}"
echo "---------------------------------------------------------------------------------"
docker login -u $(oc whoami) -p $(oc whoami -t) ${OCP_REGISTRY}

export TARGET_OCP_PROJECT=$(oc project -q)  # Projeto onde a imagem será criada. Se colocar no projeto openshift todos os usuários vão poder ver.
export KIND_IMAGE_BASE=demo-eap71-openshift # nome da imagem a ser gerada
export BASE_VERSION=latest                  # versão da imagem a ser gerada

echo "---------------------------------------------------------------------------------"
echo "- docker build- IMAGE = $OCP_REGISTRY/$TARGET_OCP_PROJECT/$KIND_IMAGE_BASE:$BASE_VERSION"
echo "---------------------------------------------------------------------------------"
docker build --no-cache -t $OCP_REGISTRY/$TARGET_OCP_PROJECT/$KIND_IMAGE_BASE:$BASE_VERSION . # gera a imagem baseada no Dockerfile corrente

echo "---------------------------------------------------------------------------------"
echo "- docker images-" # Apenas para exibir que a imagem ainda está local
echo "---------------------------------------------------------------------------------"
docker images | grep $KIND_IMAGE_BASE

echo "---------------------------------------------------------------------------------"
echo "- docker push- $OCP_REGISTRY/$TARGET_OCP_PROJECT/$KIND_IMAGE_BASE:$BASE_VERSION" # envia a imagem para o docker registry do openshift
echo "---------------------------------------------------------------------------------"
docker push $OCP_REGISTRY/$TARGET_OCP_PROJECT/$KIND_IMAGE_BASE:$BASE_VERSION

echo "---------------------------------------------------------------------------------"
echo "- oc get is- " # visualizar no openshift
echo "---------------------------------------------------------------------------------"
oc get is -n $TARGET_OCP_PROJECT | grep $KIND_IMAGE_BASE

echo "---------------------------------------------------------------------------------"
echo "- oc describe is- " # detalhar a imagem
echo "---------------------------------------------------------------------------------"
oc describe is -n $TARGET_OCP_PROJECT $KIND_IMAGE_BASE
