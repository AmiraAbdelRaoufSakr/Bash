#! /bin/bash
##This script to manage apache web server, install/unistall webserver

source checker.sh
##This function to install apache webserver
##Parameter: apache version --example: install 2:this will install apache2
##Returns: 0:installed successfully, 1:apache already exists or can't install

function install {
  local VERSION=${1}

##check if apache already exists or not
  isExisted ${VERSION}
  if [ ${?} -eq 1 ]
  then

    sudo apt update
    sudo apt install apache${VERSION}
    return 0;

  else
    return 1;
  fi
}
##---------------------------------------------------------------------------
##This function to uninstall apache webserver
##Parameter:apache version --example: uninstall 2: this will uninstall apache2
##Returns: 0:uninstalled successfully, 1:unistallation failed

function uninstall {
  local VERSION=${1}

  sudo service apache${VERSION} stop
  sudo apt-get purge apache${VERSION}
  sudo apt-get autoremove 

##check if apache still exists on the machine or not
  isExisted ${VERSION}

  if [ ${?} -eq 0 ]

   then

     return 1;

  else

    return 0;

  fi
} 

