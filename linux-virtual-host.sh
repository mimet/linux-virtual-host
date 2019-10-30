#!/bin/bash

 # Bash script that allow you to create multiple virtual hosts on a local *buntu system
 #
 # @author  			Michele Meta <info@me.ta.it>
 # @link				http://me.ta.it
 # @version				1.0
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
#  CONFIGS  #
#-----------#
declare -A _SYSTEM_CONFIGS
_SYSTEM_CONFIGS[hosts_file]="/etc/hosts"
_SYSTEM_CONFIGS[www_path]="/var/www/"
_SYSTEM_CONFIGS[ssl_path]="/var/www/ssl"
_SYSTEM_CONFIGS[logs_folder]="/logs/"
_SYSTEM_CONFIGS[public_html_folder]="/public_html"
_SYSTEM_CONFIGS[error_log_file]="error.log"
_SYSTEM_CONFIGS[access_log_file]="access.log"
_SYSTEM_CONFIGS[sites_available_path]="/etc/apache2/sites-available/"
_SYSTEM_CONFIGS[domains_list]="domains_list.ext"
_SYSTEM_CONFIGS[ssl_crt]="/var/www/ssl/localhost.crt"
_SYSTEM_CONFIGS[ssl_key]="/var/www/ssl/localhost.key"
_SYSTEM_CONFIGS[ssl_csr]="/var/www/ssl/localhost.csr"
_SYSTEM_CONFIGS[ssl_pfx]="/var/www/ssl/localhost.pfx"
_SYSTEM_CONFIGS[complete_host]=""

declare -A _USER_CONFIGS
_USER_CONFIGS[host_owner]="www-data"
_USER_CONFIGS[user_fullname]="John Doe"
_USER_CONFIGS[email]="john@doe.ext"
_USER_CONFIGS[country]="XX"
_USER_CONFIGS[state]="XX"
_USER_CONFIGS[city]="YOUR_CITY"
_USER_CONFIGS[organization]="YOUR_ORGANIZATION"
_USER_CONFIGS[host_prefix]=""
_USER_CONFIGS[host_suffix]=".local"

#-----------#
# FUNCTIONS #
#-----------#

function create_host {
	DIR=${_SYSTEM_CONFIGS[www_path]}${_SYSTEM_CONFIGS[complete_host]}
	
	# Make a new dir called as host's name
	mkdir -p ${DIR}
	mkdir -p ${_SYSTEM_CONFIGS[ssl_path]}
	mkdir -p ${DIR}${_SYSTEM_CONFIGS[public_html_folder]}
	mkdir -p ${DIR}${_SYSTEM_CONFIGS[logs_folder]}

	# Create an index.html file in the host just created
	echo -e "<h1>Hi, i'm the index.html file in the host https://"${_SYSTEM_CONFIGS[complete_host]}"</h1><h2>Enjoy!</h2>" >> ${DIR}${_SYSTEM_CONFIGS[public_html_folder]}"/index.html"
}

function set_hosts_file {
	NEW_LINE="127.0.0.1 "${_SYSTEM_CONFIGS[complete_host]}

	# Write a new line in hosts file for recognize the new host
	echo -e "\n"${NEW_LINE} >> ${_SYSTEM_CONFIGS[hosts_file]}
}

function authorize_host {
	TEXT="<VirtualHost *:443>\n
        	\t\tServerAdmin "${_USER_CONFIGS[email]}"\n
        	\t\tServerName "${_SYSTEM_CONFIGS[complete_host]}"\n
        	\t\tServerAlias www."${_SYSTEM_CONFIGS[complete_host]}"\n
        	\t\tDocumentRoot "${_SYSTEM_CONFIGS[www_path]}${_SYSTEM_CONFIGS[complete_host]}${_SYSTEM_CONFIGS[public_html_folder]}"\n
        	\t\tLogLevel warn\n
        	\t\tErrorLog "${_SYSTEM_CONFIGS[www_path]}${_SYSTEM_CONFIGS[complete_host]}${_SYSTEM_CONFIGS[logs_folder]}${_SYSTEM_CONFIGS[error_log_file]}"\n
        	\t\tCustomLog "${_SYSTEM_CONFIGS[www_path]}${_SYSTEM_CONFIGS[complete_host]}${_SYSTEM_CONFIGS[logs_folder]}${_SYSTEM_CONFIGS[access_log_file]}" combined\n
			\t\tSSLEngine on\n
			\t\tSSLCertificateFile "${_SYSTEM_CONFIGS[ssl_crt]}"\n
			\t\tSSLCertificateKeyFile "${_SYSTEM_CONFIGS[ssl_key]}"\n
			</VirtualHost>\n\n
			<Directory "${_SYSTEM_CONFIGS[www_path]}${_SYSTEM_CONFIGS[complete_host]}${_SYSTEM_CONFIGS[public_html_folder]}">\n
			\t\tOptions Indexes FollowSymLinks MultiViews\n
			\t\tAllowOverride All\n
			\t\tRequire all granted\n
			</Directory>\n"
	FILE=${_SYSTEM_CONFIGS[sites_available_path]}${_SYSTEM_CONFIGS[complete_host]}".conf"

	# Write the necessary stuff thar permits host to work
	echo -e ${TEXT} >> $FILE
}

# Apply all the changes, reboot server, give new permissions and change owner of host from root to user (if is possible)
function apply {
	# Enables the host to be used
	a2ensite ${_SYSTEM_CONFIGS[complete_host]}

	# Reboot Apache
	/etc/init.d/apache2 reload

	DIR=${_SYSTEM_CONFIGS[www_path]}${_SYSTEM_CONFIGS[complete_host]}
	
	# Change owner of new host dir
	chown -R ${_USER_CONFIGS[host_owner]}:${_USER_CONFIGS[host_owner]} ${DIR}

	# Give all righ permissions to the host and his subfolder
	find ${DIR} -type f -exec chmod 644 '{}' \;
	find ${DIR} -type d -exec chmod 755 '{}' \;
}

# Generate SSL certificate for the host just created
function generate_ssl_certificate {
	# Calculate number of DNS to give to tne host just created
	LINES="$(cat ${_SYSTEM_CONFIGS[domains_list]} | wc -l)"
	DNS_NUMBER=$(($LINES-4))

	# Write a new line in the domains list
	TEXT="DNS."${DNS_NUMBER}" = "${_SYSTEM_CONFIGS[complete_host]}
	echo -e $TEXT >> ${_SYSTEM_CONFIGS[domains_list]}

	# Launch rhese commands for generating Root Key
	# openssl req -x509 -nodes -new -sha256 -days 1024 -newkey rsa:2048 -keyout Root.key -out Root.pem -subj "/C=YOUR_COUNTRY/CN=root"
	# openssl x509 -outform pem -in Root.pem -out Root.crt

	openssl req -new -nodes -newkey rsa:2048 -keyout ${_SYSTEM_CONFIGS[ssl_key]} -out ${_SYSTEM_CONFIGS[ssl_csr]} -subj "/C="${_USER_CONFIGS[country]}"/ST="${_USER_CONFIGS[state]}"/L="${_USER_CONFIGS[city]}"/O="${_USER_CONFIGS[organization]}"/CN=${_USER_CONFIGS[user_fullname]}"
	openssl x509 -req -sha256 -days 1024 -in ${_SYSTEM_CONFIGS[ssl_csr]} -CA ssl/Root.pem -CAkey ssl/Root.key -CAcreateserial -extfile ${_SYSTEM_CONFIGS[domains_list]} -out ${_SYSTEM_CONFIGS[ssl_crt]}
	openssl pkcs12 -export -out ${_SYSTEM_CONFIGS[ssl_pfx]} -inkey ${_SYSTEM_CONFIGS[ssl_key]} -in ${_SYSTEM_CONFIGS[ssl_crt]}

	# Change owner of files in SSL dir
	chown -R ${_USER_CONFIGS[host_owner]}:${_USER_CONFIGS[host_owner]} ${_SYSTEM_CONFIGS[ssl_path]}
}

#-----------#
#   MAIN    #
#-----------#

# Check that script has root privileges
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root"
	exit 1
fi

# Setting variables
HOST=$1

# Check that the name of host was send
if [ -z ${HOST} ]; then 
	echo "You have to send at least one argument (name of host)"
	exit 1
fi

_SYSTEM_CONFIGS[complete_host]=${_USER_CONFIGS[host_prefix]}${HOST}${_USER_CONFIGS[host_suffix]}

echo -e "\n\n ============= Creating host "${_SYSTEM_CONFIGS[complete_host]}" ..."
create_host
echo -e "##### Done.\n\n"

echo -e "============= Setting hosts file for "${_SYSTEM_CONFIGS[complete_host]}" ..."
set_hosts_file
echo -e "##### Done.\n\n"

echo -e "============= Authorizing new created host "${_SYSTEM_CONFIGS[complete_host]}" ..."
authorize_host
echo -e "##### Done.\n\n"

echo -e "============= Generating new SSL certificate..\n"
generate_ssl_certificate
echo -e "##### Done.\n\n"

echo -e "============= Applying changes...\n"
apply
echo -e "\n\n##### All done, enjoy!\n\n"

exit 0
