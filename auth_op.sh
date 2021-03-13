#! /bin/bash
##This script to configure authentication for eacch virtualhost in .htaccess

source checker.sh
source file_op.sh

##This function to enable auth for a certain virtualhost in the .htaccess file of exists, if not exists create .htaccess file
##Parameters: virtualhost name
##Returns: 0:enable authentication successfully
##         1:virtualhost doesnot exist
##         2:virtualhost already has authentication
function enableAuthentication {
       local HOST_NAME=${1}
        doesDirectoryExist /var/www/${HOST_NAME}
        if [ ${?} -eq 1 ]
        then
                echo  " VirtualHost doesn't exist"
                return 1
        else
                checkAuthentication ${HOST_NAME}
               local AUTH=${?}
                if [ ${AUTH} -eq 1 ]
                then
                        echo  "This VirtualHost already has authentication"
                        return 2
                fi
                   if [ ${AUTH} -eq 2 ]
                   then
                        create_htaccess ${HOST_NAME}
                        echo  "File /var/www/${HOST_NAME}/.htaccess was created successfully"
                   fi

        fi

        does_htpasswdExist
      local FILE_PATH="/var/www/${HOST_NAME}/.htaccess"

         USER_FLAG=0
         while [ ${USER_FLAG} -eq 0 ]
           do
             local USER
             read -p "Please choose a username: " USER
             doesUserExist ${USER}
             if [ ${?} -eq 0 ]
             then
                 local UPDATEUSER
                 read -p "User already exist, would you like to update his password (y/n)? " UPDATEUSER
                 if [ ${UPDATEUSER} == "y" ]
                 then
                     sudo htpasswd /etc/apache2/.htpasswd ${USER}
                     USER_FLAG=1
                  fi
              else
                 sudo htpasswd /etc/apache2/.htpasswd ${USER}
                 USER_FLAG=1
               fi
            done


        ### Adding the directive to .htaccess
        sudo bash -c "echo 'Require valid-user' >> ${FILE_PATH}"
        echo  "Authentication enabled successfully"
        return 0
}

#-------------------------------------------------------------------------------------------------------------------------------------
##This function to disable the authentication from a VirtualHost
##Parameters:virtualhost name  -- example: disableAuthentication mysite
##Returns:0: VirtualHost authentication disabled successfully
##        1:VirtualHost doesn't have authentication
function disableAuthentication {
        local HOST_NAME=${1}
        doesDirectoryExist /var/www/${HOST_NAME}
        if [ ${?} -eq 1 ]
        then
                echo  "VirtualHost doesn't exist"
                return 1
        else
                checkAuthentication ${HOST_NAME}
               local AUTH=${?}
                if [ ${AUTH} -eq 0 ] || [ ${AUTH} -eq 2 ]
                then
                        echo  "This VirtualHost already has authentication disabled"
                        return 1
                else
                        sudo bash -c "sudo sed -i '/Require valid-user/d' /var/www/${HOST_NAME}/.htaccess"
                        echo "Authentication disabled successfully"
                        return 0
                fi
        fi
}

 
