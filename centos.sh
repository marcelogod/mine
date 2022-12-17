#!/bin/bash

sudo timedatectl set-timezone America/Sao_Paulo

echo "Preparando sua máquina..."
wait
echo "25% concluidos.."
sudo dnf -y update
echo "50% concluidos.."
wait
echo "75% concluidos.."
sudo dnf -y upgrade
echo "100% concluidos.."
sleep 3

echo "                   _                          "
echo "  _ __   __ _  ___| | ____ _  __ _  ___  ___  "
echo " | '_ \ / _\` |/ __| |/ / _\` |/ _\` |/ _ \/| "
echo " | |_) | (_| | (__|   < (_| | (_| |  __/\__ \ "
echo " | .__/ \__,_|\___|_|\_\__,_|\__, |\___||___/ "
echo " |_|                         |___/            "
echo "                                              "

sudo dnf install git -y
sudo dnf group install "Development Tools" -y
sudo dnf install epel-release screen wget htop -y

sudo dnf install java-1.8.0-openjdk-headless -y

wget https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
chmod +x mariadb_repo_setup
sudo ./mariadb_repo_setup

sudo dnf install MariaDB-server -y
sudo systemctl start mariadb.service
sudo systemctl enable mariadb.service

sudo mariadb-secure-installation

echo "Instalação finalizada!"