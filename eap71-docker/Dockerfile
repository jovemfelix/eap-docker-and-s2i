FROM registry.redhat.io/jboss-eap-7/eap71-openshift:latest

LABEL version="1.0" \
      description="Imagem base DEMO para deploy de aplicacoes JEE." \
      eap-version="eap71-openshift:1.1" \
      author="Arquitetura" \
      maintainer="rfelix@redhat.com"

ENV TZ=America/Sao_Paulo
ENV JAVA_OPTS_APPEND="-Duser.country=BR -Duser.language=pt -Dfile.encoding=UTF-8 -Duser.timezone=America/Sao_Paulo"

ADD custom/configuration/standalone-openshift.xml $JBOSS_HOME/standalone/configuration/standalone-openshift.xml
ADD custom/s2i/bin/datasource-common.sh           $JBOSS_HOME/bin/launch/datasource-common.sh
ADD custom/s2i/bin/tx-datasource.sh               $JBOSS_HOME/bin/launch/tx-datasource.sh
ADD custom/modules                                $JBOSS_HOME/modules/
