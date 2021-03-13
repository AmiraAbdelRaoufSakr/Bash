#! /bin/bash
##This script to create files

##This function creates index.html for a virtualhost
##Parameters:host name and creates index file in it's directory
##Returns:nothing
function createIndexFile {
        local HOST_NAME=${1}
	sudo touch /var/www/${HOST_NAME}/index.html
	sudo bash -c "echo '<h1>Welcome to ${HOST_NAME}</h1>' > /var/www/${HOST_NAME}/index.html"
}
#-------------------------------------------------------------------------------------------------
##This function to create .conf file for the host
##Parameters: Takes host name and creates .conf file
##Returns: nothing
function createConfFile {
        local HOST_NAME=${1}
        local FILE_PATH=/etc/apache2/sites-available/${HOST_NAME}.com.conf
	sudo touch ${FILE_PATH}
	sudo bash -c "echo '<VirtualHost *:80>' >> ${FILE_PATH}"
	sudo bash -c "echo 'DocumentRoot /var/www/${HOST_NAME}' >> ${FILE_PATH}"
	sudo bash -c "echo 'ServerName ${HOST_NAME}.com' >> ${FILE_PATH}"
	sudo bash -c "echo '</VirtualHost>' >> ${FILE_PATH}"
	sudo bash -c "echo '<Directory /var/www/${HOST_NAME}>' >> ${FILE_PATH}"
	sudo bash -c "echo 'Options ALL' >> ${FILE_PATH}"
	sudo bash -c "echo 'AllowOverride All' >> ${FILE_PATH}"
	sudo bash -c "echo '</Directory>' >> ${FILE_PATH}"
}
#------------------------------------------------------------------------------------------------
##This function to create .htaccess file
##Parameters: Takes the host name and creates the file -- example: create_htaccess mysite
##Returns:nothing
function create_htaccess {
        local HOST_NAME=${1}
        local FILE_PATH="/var/www/${HOST_NAME}"
        sudo touch ${FILE_PATH}/.htaccess
        sudo bash -c "echo 'AuthType Basic' >> ${FILE_PATH}/.htaccess"
        sudo bash -c "echo 'AuthName \"Private Area\"' >> ${FILE_PATH}/.htaccess"
        sudo bash -c "echo 'AuthUserFile /etc/apache2/.htpasswd' >> ${FILE_PATH}/.htaccess"
}


##This function to create .htpasswd file if it doesn't exist
function does_htpasswdExist {
       local RESULT=$(ls /etc/apache2/.htpasswd | wc -l)
	if [ ${?} -ne 0 ]
	then
	   sudo touch /etc/apache2/.htpasswd
	fi
}

