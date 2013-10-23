#!/bin/bash

 # Bash script that allow you to create multiple virtual hosts on a local *buntu system
 #
 # @author  				Michele Meta <m.meta@hoob.it>
 # @link				http://hoob.it
 # @version				0.2
 # @operative system 			*buntu family
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # THIS SOFTWARE AND DOCUMENTATION IS PROVIDED "AS IS," AND COPYRIGHT
 # HOLDERS MAKE NO REPRESENTATIONS OR WARRANTIES, EXPRESS OR IMPLIED,
 # INCLUDING BUT NOT LIMITED TO, WARRANTIES OF MERCHANTABILITY OR
 # FITNESS FOR ANY PARTICULAR PURPOSE OR THAT THE USE OF THE SOFTWARE
 # OR DOCUMENTATION WILL NOT INFRINGE ANY THIRD PARTY PATENTS,
 # COPYRIGHTS, TRADEMARKS OR OTHER RIGHTS.COPYRIGHT HOLDERS WILL NOT
 # BE LIABLE FOR ANY DIRECT, INDIRECT, SPECIAL OR CONSEQUENTIAL
 # DAMAGES ARISING OUT OF ANY USE OF THE SOFTWARE OR DOCUMENTATION.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program. If not, see <http://gnu.org/licenses/>.


#-----------#
# FUNCTIONS #
#-----------#

function create_host {
	HOST=$1
	DIR="/var/www/"$HOST
	
	#Make a new dir called as host's name
	mkdir $DIR
}

function set_hosts_file {
	COMPLETE_HOST=$1
	NEW_LINE="127.0.0.1 "$COMPLETE_HOST
	HOSTS="/etc/hosts"

	#Write a new line in hosts file for recognize the new host
	echo -e "\n"$NEW_LINE >> $HOSTS
}

function authorize_host {
	HOST=$1
	COMPLETE_HOST=$2
	TEXT="<VirtualHost *:80>\nDocumentRoot /var/www/"$HOST"\nServerName "$COMPLETE_HOST"\nServerAlias "$HOST"\n</VirtualHost>"
	FILE="/etc/apache2/sites-available/"$HOST".conf"

	#Write the necessary stuff thar permits host to work
	echo -e $TEXT >> $FILE
}

#Apply all the changes, reboot server, give new permissions and change owner of host from root to user (if is possible)
function apply {

	HOST=$1
	USER_NAME=$2

	#Enables the host to be used
	a2ensite $HOST

	#Reboot Apache
	/etc/init.d/apache2 reload

	DIR="/var/www/"$HOST
	
	#Set write permission to the new host dir
	chmod a+w $DIR
	
	#Change owner of new host dir
	chown -R $USER_NAME $DIR

}



#-----------#
#   MAIN    #
#-----------#

#Check that script has root privileges
if [[ $EUID -ne 0 ]]; then

	echo "This script must be run as root"
	exit 1

fi

#Setting variables
HOST=$1
PRE_HOST=$2
USER_NAME=$3

#Check that the name of host was send
if [ -z $HOST ]; then 

	echo "You have to send at least one argument (name of host)"
	exit 1

fi

#Check that the string pre-host was send; if not, set it to "dev."
if [ -z $PRE_HOST ]; then 

	PRE_HOST="dev."
	USER_NAME="root"

fi

#Check that user name was send; if not, set it to root
if [ -z $USER_NAME ]; then 

	USER_NAME="root"

fi

COMPLETE_HOST=$PRE_HOST$HOST

echo -e "\n\nCreating host "$HOST" ..."
create_host $HOST
echo -e "Done.\n\n"

echo -e "Setting hosts file for "$COMPLETE_HOST" ..."
set_hosts_file $COMPLETE_HOST
echo -e "Done.\n\n"

echo -e "Authorizing new created host "$HOST" ..."
authorize_host $HOST $COMPLETE_HOST
echo -e "Done.\n\n"

echo -e "Applying changes...\n"
apply $HOST $USER_NAME
echo -e "\n\nAll done, enjoy!\n\n"

exit 0
