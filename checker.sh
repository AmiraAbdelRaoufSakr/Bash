#! /bin/bash
##This is a checker script

##function to check if apache exists on the machine or not
##Parameter: version of apache webserver --example:isExisted apache2, will check on apache2
##Returns: 0:if apache exists
##         1:if not exists

function isExisted {
   local VERSION=${1}
   local RESULT=$(which apache${VERSION} | wc -l)
    if [ ${RESULT} -eq 1 ]
    then
       return 0
    else
      return 1;
    fi
}
#-------------------------------------------------------------
##This function to check if directory exists or not
##parameter: directory path --example: doesDirectoryExist /var/www
##Returns: 0:if directory exists
##         1:if directory doesnot exist
function doesDirectoryExist {
       local  DIRECTORY_PATH=${1}
	[ ! -d ${DIRECTORY_PATH} ] && return 1
	return 0
}
#------------------------------------------------------------------------
##This function to check if file exists or not
##parameter: file path --example: doesFileExist /var/filename
##Returns: 0:if file exists
##         1:if file doesnot exist
function doesFileExist {
       local  FILE_PATH=${1}
        [ ! -f ${FILE_PATH} ] && return 1
        return 0
}
#---------------------------------------------------------------------------
##This function to check if user exists in .htaccess file or not
##Parameters:user name --example: doesUserExist amira
##Returns: 0:user exists
##         1:user doensot exist
function doesUserExist {
	local USER=${1}
        local RESULTS=$(cat /etc/apache2/.htpasswd | cut -d ":" -f 1 | grep "^${USER}$" | wc -l)
	if [ ${RESULTS} == 1 ]
	then
		return 0
	else
		return 1
	fi
}
#--------------------------------------------------------------------------------------------
##This function to check if virtualhost has authentication or not
##Parameters:virtualhost name --example:checkAuthentication mysite
##Returns:0:No authentication found on the host
###	  1:Authentication found on the host
###	  2:.htaccess doesn't exist
function checkAuthentication {
        local  HOST_NAME=${1}
        doesFileExist /var/www/${HOST_NAME}/.htaccess
        if [ ${?} -eq 1 ]
        then
            return 2
        else
           local RESULT=$(cat /var/www/${HOST_NAME}/.htaccess | grep "^Require valid-user$" | wc -l)
	    if [ ${RESULT} -eq 0 ]
	    then
	       return 0
	    else
	       return 1
	    fi
        fi
}


