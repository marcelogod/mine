#!/bin/bash

sudo timedatectl set-timezone America/Sao_Paulo

echo "Preparando sua máquina..."
wait
echo "25% concluidos.."
sudo apt -y update
echo "50% concluidos.."
wait
echo "75% concluidos.."
sudo apt -y upgrade
echo "100% concluidos.."
sleep 3

echo "                   _                          "
echo "  _ __   __ _  ___| | ____ _  __ _  ___  ___  "
echo " | '_ \ / _\` |/ __| |/ / _\` |/ _\` |/ _ \/| "
echo " | |_) | (_| | (__|   < (_| | (_| |  __/\__ \ "
echo " | .__/ \__,_|\___|_|\_\__,_|\__, |\___||___/ "
echo " |_|                         |___/            "
echo "                                              "
sudo apt install git -y
sudo apt install screen -y
sudo apt install epel-release -y
sudo apt install wget -y
sudo apt install htop -y

sudo apt install java-1.8.0-openjdk-headless -y

wget https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
chmod +x mariadb_repo_setup
sudo ./mariadb_repo_setup

sudo apt install MariaDB-server -y
sudo systemctl start mariadb.service
sudo systemctl enable mariadb.service

sudo mariadb-secure-installation

echo "Instalação finalizada!"