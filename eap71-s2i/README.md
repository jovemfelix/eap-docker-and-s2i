## Passos s2i

Abaixo é mostrado comandos para criar uma imagem usando **s2i**

### 1) Escolher qual imagem EAP será a BASE

```shell
$ oc -n openshift get is | grep eap
```

### 2) Fazer new-build + start-build

O scritp `openshift-build.sh` passo a passo.

## Referência

- https://docs.openshift.com/container-platform/3.11/creating_images/s2i.html
- https://blog.openshift.com/create-s2i-builder-image/
- https://docs.openshift.com/container-platform/3.11/dev_guide/builds/basic_build_operations.html