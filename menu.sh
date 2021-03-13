#! /bin/bash
##This Script to view menu with all operations to user

source apache_op.sh
source virtualhost_op.sh
source auth_op.sh

##function to display menu with all operations
##has no parameters or return values
function displayMenu {
  
  echo "-------------Apache Web-Server Managing---------------"
  echo "1-Install Apache."
  echo "2-Uninstall Apache."
  echo "---------------------------------------------------------"
  echo "-------------Administarte Virtual hosts----------------"
  echo "3-List all Virtualhosts."
  echo "4-Add Virtualhos."
  echo "5-Delete Virtualhost."
  echo "6-Enable Virtualhost."
  echo "7-Disable Virtualhost."
  echo "---------------------------------------------------------"
  echo "--------------Configure Authentiation--------------------"
  echo "8-Enable authentication for a certain virtualhost."
  echo "9-disable authentication for a certain virtualhost."
   
}

##function to handle user's choice

function handleChoice {
   local FLAG=1
   while [ ${FLAG} -eq 1 ]
   do
      local CH
      read -p "Choose an operation: " CH
         
      case ${CH} in
          
          "1")
              local VERSION
              read -p "Which version would you like to install: " VERSION
              install ${VERSION}
              if [ ${?} -eq 0 ]
              then
               echo "Successfully Installed"
              else
                echo "Apache is already installed"
              fi
              ;;
             
             "2")
                 local VERSION
                 read -p "Please add the apache version you want to uninstall: " VERSION
                 uninstall ${VERSION}
                 if [ ${?} -eq 0 ]
                 then
                     echo "Apache uninstalled successfully"
                 else
                     echo "uninstallation failed"
                 fi
                 ;;

               "3")
                   doesDirectoryExist /etc/apache2/sites-available
		   if [ ${?} -eq 1 ]
		   then 
		      echo  "Directory /etc/apache2/sites-available doesn't exist"
		   else
		      echo "VirtualHosts available on this machine:"
		      echo "---------------------------------------"
                      displayAllHosts
                      if [ ${?} -eq 1 ]
		      then
			 echo "No VirtualHosts found on this machine"
		       fi
		    fi
                     ;;
                 "4")
		      local VH_NAME
		      read -p "Please enter the VirtualHost name: " VH_NAME
		      addVirtualHost ${VH_NAME}
	              ;;
		 "5")
		      read -p "Please enter the VirtualHost name that you wish to delete" VH_NAME
		      deleteVirtualHost ${VH_NAME}
		      ;;
		 "6")
		      read -p "Please enter the VirtualHost that you wish to enable: " VH_NAME
		      enableVirtualHost ${VH_NAME}
		      ;;
		 "7")
		      read -p "Please enter the VirtualHost that you wish to disable: " VH_NAME
		      disableVirtualHost ${VH_NAME}
		      ;;
		"8")
		      read -p "Please enter the VirtualHost that you wish to add authentication for: " VH_NAME
		      enableAuthentication ${VH_NAME}
		      ;;
		"9")
		     read -p "Please enter the VirtualHost that you wish to disable authentication from: " VH_NAME
		     disableAuthentication ${VH_NAME}
		     ;;
                "quit")
		      FLAG=0
		      echo "Bye!"
		esac
	if [ ${FLAG} -eq 1 ]
	then
		displayMenu
	fi
	done
}

displayMenu
handleChoice

