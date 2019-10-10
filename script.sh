#!/bin/bash

echo -e "\e[92m \e[1m Bienvenue sur script.sh !\e[0m "

echo -e "Nous allons vérifier si \e[1mVirtualBox\e[0m et \e[1mVagrant\e[0m  sont correctement installés :"

# Vérification de l'installation de VirtualBox

dpkg -s VirtualBox &> /dev/null  

if [[ VirtualBox -ne 0 ]]
    then
        echo -e "\e[91mVirtualbox n'est pas installé, nous allons procéder à son installation\e[0m"  
        sudo apt-get update
        sudo apt-get install VirtualBox

    else
        echo -e "\e[32mVirtualbox est correctement installé\e[0m"
fi

# Vérification de l'installation de Vagrant

dpkg -s Vagrant &> /dev/null  

if [[ Vagrant -ne 0 ]]
    then
        echo -e "\e[91mVagrant n'est pas installé, nous allons procéder à son installation\e[0m"  
        sudo apt-get update
        sudo apt-get install Vagrant

    else
        echo -e "\e[32mVagrant est correctement installé\e[0m"
fi

echo -e "Nous allons procéder à la création d'un fichier \e[1mVagrantFile\e[0m"

echo "Vagrant.configure("\"2"\") do |config|" > Vagrantfile

# Personnalisation le nom du dossier synchronisé local
echo "Voulez-vous modifier le nom du dossier synchronisé local ? 
        1) Oui
        2) Non " 
read choice
case $choice in
    1)
        read -p "Merci d'entrer le nouveau nom du dossier : " folderName
        mkdir $folderName
        echo "config.vm.synced_folder "\"./$folderName"\", "\"/var/www/html"\"" >> Vagrantfile
        echo -e "\e[32mLe dossier $folderName a bien été créé\e[0m"
    ;;

    2)
        echo -e "\e[32mTrès bien. Le nom du dossier par défaut sera donc 'data.'\e[0m"
        mkdir data
        echo "config.vm.synced_folder "\"./data"\", "\"/var/www/html"\"" >> Vagrantfile
    ;;
    esac

# Personnalisation du nom de la box
echo "Merci de choisir parmis ces deux boxes :
     1) ubuntu/trusty64
     2) ubuntu/xenial64
     3) ubuntu/bionic64
    "
read boxChoice
case $boxChoice in
    1) 
        echo -e "\e[32mBox trusty choisie.\e[0m"
        echo "config.vm.box = "\"ubuntu/trusty64"\"" >> Vagrantfile
    ;;
    2) 
        echo -e "\e[32mBox xenial choisie.\e[0m"
        echo "config.vm.box = "\"ubuntu/xenial64"\"" >> Vagrantfile
    ;;
    3)
        echo -e "\e[32mBox bionic choisie.\e[0m"
        echo "config.vm.box = "\"ubuntu/bionic64"\"" >> Vagrantfile
    ;;
    *) 
        echo -e "\e[32mBox par défaut (xenial) chosie.\e[0m"
        echo "config.vm.box = "\"ubuntu/xenial64"\"" >> Vagrantfile
    ;;
esac

# Personnalisation de l'adresse IP

echo "Assignation par défaut de l'IP suivante : 192.168.33.10"
echo "Souhaitez-vous modifier les deux derniers chiffres de l'adresse IP ? 
        1) Oui
        2) Non" 
read ipNumbers

case $ipNumbers in 
    1)
        echo "Veuillez taper les deux derniers chiffres de votre adresse IP" 
        read ipNumbersChoice
        echo "config.vm.network "\"private_network"\", ip: "\"192.168.33.$ipNumbersChoice"\"" >> Vagrantfile
        echo -e "\e[32mVotre adresse IP sera donc 192.168.33.$ipNumbersChoice\e[0m"
    ;;
    2)
        echo "config.vm.network "\"private_network"\", ip: "\"192.168.33.10"\"" >> Vagrantfile
    ;;
esac

echo "end" >> Vagrantfile

echo -e "\e[32mLancement de la Vagrant\e[0m"
vagrant up

echo -e "\e[32mNous allons afficher toutes les Vagrant en cours d'utilisation sur le système.\e[0m"
vagrant status

# Choix et affichage de statuts des Vagrant

while [[ $vagrantChoice != "STOP" ]]
do

echo -e "\e[92mPour quitter cet écran, tapez STOP\e[0m"
echo "Choisissez une action :
        1) Démarrer une vagrant
        2) Eteindre une vagrant" 
read vagrantChoice

case $vagrantChoice in
    1)
        read -p "Quelle vagrant souhaitez vous démarrer ?" vagrantLaunch
        vagrant up $vagrantLaunch
        echo -e "\e[32m$vagrantLaunch a bien été démarrée\e[0m"
    ;;

    2)
        read -p "Quelle vagrant souhaitez vous éteindre ?" vagrantLaunch
        vagrant halt $vagrantLaunch
        echo -e "\e[32m$vagrantLaunch a bien été éteinte\e[0m"
    ;;

esac

done

# Installation d'Apache2, MYSQL et PHP7.0

echo "Souhaitez-vous installer Apache2, MySQL et PHP7.0 ?
    1) Oui
    2) Non"
read ampChoice

case $ampChoice in

    1)
        apt install apache2
        apt install mysql-server
        sudo mysql -u root -e "SET PASSWORD FOR root@localhost = PASSWORD('mypassword')";
        apt install php7.0
        echo -e "\e[32mApache2 MySQL et PHP7.0 ont bien été installés\e[0m"
        echo -e "\e[32mVotre mot de passe MySQL sera 0000\e[0m"
    ;;

    2)
        exit
    ;;

esac