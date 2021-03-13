#! /bin/bash
##This script to manipulate virtualhosts

source checker.sh
source file_op.sh
##This function to display all virtualhosts
##Parameters:no parameters
##Returns: 0:There are hosts and display their names
##         1:There are no hosts to display

function displayAllHosts {
        local NUM_FILES=$(ls /etc/apache2/sites-available | column -t | wc -l)
       	if [ ${NUM_FILES} -eq 0 ]
       	then
		return 1
      	else
		ls /etc/apache2/sites-available | column -t
		return 0
	fi

}





#---------------------------------------------------------------------------------
##This function to add new virtualhost
##Parameters:virtualhost name you want to add --example: addVirtualHost mysite
##Returns: 0:virtualhost added successfully, 1:virtualhost already exists

function addVirtualHost {
    local HOST_NAME=${1}
    doesDirectoryExist /var/www/${HOST_NAME}
	if [ ${?} -eq 0 ]
	then
		echo  "VirtualHost already exists"
		return 1
	else
		sudo mkdir /var/www/${HOST_NAME}
		createIndexFile ${HOST_NAME}
		echo  "Index file created successfully"
		# This creates .conf file in sites-available
		createConfFile ${HOST_NAME}
		# This adds site name to /etc/hosts file
		sudo bash -c "echo '127.0.0.1	${HOST_NAME}.com' >> /etc/hosts"
		echo  "Site added to hosts file successfully"
		enableHost ${HOST_NAME}
		sudo service apache2 start
                return 0
	
	fi
}
#-----------------------------------------------------------------------------------------
##This function to enable virtualhost
##Parameters:virtualhost name --example: enableVirtualHost mysite
##returns: 0:virtualhost enabled successfully
##         1:virtualhost doesnot exist
##         2:virtualhost already enabled
function enableVirtualHost {
        local HOST_NAME=${1}
	doesFileExist /etc/apache2/sites-available/${HOST_NAME}.com.conf
	if [ ${?} -eq 1 ]
	then
		echo "VirtualHost doesn't exist"
		return 1
	else
	       local RESULT=$(sudo a2ensite ${HOST_NAME}.com.conf | wc -l)
		if [ ${RESULT} -eq 1 ]
		then
			echo  "Site is already enabled"
			return 2
		else
			echo "Site enabled Succesfully"
			return 0
		fi
	fi
}
#---------------------------------------------------------------------------------------------
##This function to disable virtualhost
##Parameters:virtualhost name --example: disableVirtualHost mysite
##returns: 0:virtualhost disabled successfully
##         1:virtualhost doesnot exist
##         2:virtualhost already disabled
function disableVirtualHost {
        local HOST_NAME=${1}
        doesFileExist /etc/apache2/sites-available/${HOST_NAME}.com.conf
        if [ ${?} -eq 1 ]
        then
                echo "VirtualHost doesn't exist"
                return 1
        else
               local RESULT=$(sudo a2dissite ${HOST_NAME}.com.conf | wc -l)
                if [ ${RESULT} -eq 1 ]
                then
                        echo  "Site is already disabled"
                        return 2
                else
                        echo "Site disabled Succesfully"
                        return 0
                fi
        fi
}
#--------------------------------------------------------------------------------------------
##This function to delete virtualhost
##Paramters:virtualhost name  --example: deleteVirtualHost mysite
##Returns: 0:virtualhost deleted successfullly
##         1:virtualhost doesnot exist
function deleteVirtualHost {
       local HOST_NAME=${1}
	doesFileExist /etc/apache2/sites-available/${HOST_NAME}.com.conf
        if [ ${?} -eq 1 ]
        then
                echo  "VirtualHost doesn't exist"
                return 1
        else
                sudo a2dissite ${HOST_NAME}.com.conf 
                echo  "Site disabled successfully"
		sudo rm /etc/apache2/sites-available/${HOST_NAME}.com.conf
        	echo  "File removed from /etc/apache2/sites-available successfully"
		
		doesDirectoryExist /var/www/${HOST_NAME}
		if [ ${?} -eq 0 ]
		then
			sudo rm -r /var/www/${HOST_NAME}
			echo  "Folder removed from /var/www successfully"
		fi

		## removes data from /etc/hosts
		sudo bash -c "sudo sed -i '/${HOST_NAME}.com$/d' /etc/hosts"
		echo  "Host name removed successfully from /etc/hosts"
		return 0
        fi
}
