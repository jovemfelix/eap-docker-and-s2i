#!/bin/bash

injected_dir=$1
echo "Importando biblioteca"
source /usr/local/s2i/install-common.sh
echo "Instalando módulos"
install_modules ${injected_dir}/modules
echo "Configurando drivers"
configure_drivers ${injected_dir}/drivers.env
echo "removendo script de instalação"
rm -- "$0"