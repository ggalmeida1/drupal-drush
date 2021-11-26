#!/bin/bash

#####	NAME:				drupal-drush-install.sh
#####	VERSION:			1.0
#####	DESCRIPTION:		This script will install a Drupal site with default configuration as established in DCO - Drupal Competence Office at CIT. 			
#####	CREATION DATE:	    12/11/2021
#####   LAST UPDATE:        12/11/2021
#####	AUTHOR:		        Gabriel Almeida | Paulo C. Starling
#####	E-MAIL:				gabrielda@ciandt.com | paulocs@ciandt.com
#####	DISTRO:				Ubuntu 20.04
#####	LICENCE:			GPLv3 
#####	PROJECT:			DCO - Drupal Competence Office at CI&T

# prereq - to have ssh keys installed and working for CI&T gitlab
clear
sudo apt install git-all
sleep 3
clear
#dowload files from Paulo's repo
echo 'How do you want to call this new project workspace? Please type below: '

read NAME_DIR

mkdir $NAME_DIR

echo 'Cloning the repo... '
git clone git@github.com:ggalmeida1/drupal-config.git ./$NAME_DIR

cd $NAME_DIR

rm -rf .git/
rm .gitignore
clear
sleep 3
lando start

clear
sleep 3
PROJECT_NAME=${PWD##*/}
lando composer create-project drupal/recommended-project $PROJECT_NAME

cd $PROJECT_NAME

mv * ../
mv .editorconfig ../
mv .gitattributes ../
cd ..
rm -rf $PROJECT_NAME
clear

lando rebuild -y
clear
lando composer require drush/drush
clear

sleep 3

echo "\033[1mWhich version of Drupal do you want to install? \n\n\033[0;0m"
echo '\033[33m1 - Demo Umami\n\033[0;0m'
echo '\033[33m2 - Standard\n\033[0;0m'
echo '\033[33m3 - Minimal\n\033[0;0m'
read OPTION
i=0
case $OPTION in

    1) 
        lando drush site:install demo_umami --db-url=mysql://drupal9:drupal9@database/drupal9 --site-name=$PROJECT_NAME
        sleep 3
        exit
        ;;

    2) 
        lando drush site:install --db-url=mysql://drupal9:drupal9@database/drupal9 --site-name=$PROJECT_NAME
        sleep 3
        exit
        ;;

    3) 
        lando drush site:install minimal --db-url=mysql://drupal9:drupal9@database/drupal9 --site-name=$PROJECT_NAME
        sleep 3
        exit
        ;;
    *)
        echo "\033[1mPlease choose 1, 2 or 3 \033[0;0m"
        sleep 3
        clear
esac
echo "\033[1mYour app server urls: \n\n\033[0;0m"
lando info | grep http

#lando drush user-password admin user-password=admin

## END OF FILE ##
