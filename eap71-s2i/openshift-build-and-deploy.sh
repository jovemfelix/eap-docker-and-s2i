#!/bin/bash

export USER_ID=$(oc whoami)
PROJETO_IMAGE_BASE=${USER_ID}-build-eap-s2i
KIND_IMAGE_BASE=s2i-eap71-openshift
BASE_VERSION=latest

NOME_APP=eap71-s2i
NOME_PROJETO_APP=openshift

echo "---------------------------------------------------------------------------------"
echo "- new-project-"
echo "---------------------------------------------------------------------------------"
oc new-project "${PROJETO_IMAGE_BASE}"

echo "---------------------------------------------------------------------------------"
echo "- delete bc-"
echo "---------------------------------------------------------------------------------"
oc -n ${NOME_PROJETO_APP} delete bc/${NOME_APP} --ignore-not-found=true

echo "---------------------------------------------------------------------------------"
echo "- new-build-" # eh como se criasse um Dockerfile automatico
echo "---------------------------------------------------------------------------------"
oc -n ${NOME_PROJETO_APP} new-build --name=${NOME_APP} \
  --image-stream=${PROJETO_IMAGE_BASE}/${KIND_IMAGE_BASE}:${BASE_VERSION} \
  --binary --labels="app=${NOME_APP}"

echo "---------------------------------------------------------------------------------"
echo "- start-build-" # eh como se fosse: docker build + docker push
echo "---------------------------------------------------------------------------------"
oc -n ${NOME_PROJETO_APP} start-build ${NOME_APP} --from-dir=. --wait

echo "---------------------------------------------------------------------------------"
echo "- get is-"
echo "---------------------------------------------------------------------------------"
oc -n ${NOME_PROJETO_APP} get is | grep ${NOME_APP}

echo "---------------------------------------------------------------------------------"
echo "- describe is-"
echo "---------------------------------------------------------------------------------"
oc -n ${NOME_PROJETO_APP} describe is | grep ${NOME_APP}

echo "---------------------------------------------------------------------------------"
echo "- new-app-"
echo "---------------------------------------------------------------------------------"
oc -n ${NOME_PROJETO_APP} new-app ${NOME_APP}

echo "---------------------------------------------------------------------------------"
echo "- expose svc-"
echo "---------------------------------------------------------------------------------"
oc -n ${NOME_PROJETO_APP} expose svc/${NOME_APP}
