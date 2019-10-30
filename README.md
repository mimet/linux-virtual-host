linux-virtual-host
==================

This script allow you to create multiple virtual hosts on a local *buntu system that work with Apache webserver; it also generate automatically an SSL certificate for the host.

-----

The script allows you to create multiple virtual hosts to suit your needs simply by invoking it from a terminal with root privileges and passing it the name of the host. 

##### It was created, tested and running on Ubuntu 19.04 - Disco Dingo

----- 

## Prerequisites
1. You need to have installed `apache2`, `openssl`
2. Enable `ssl` Apache module (`sudo a2enmod ssl`)

## How to use
1. Download and unzip in any folder (for example, in `home/YOUR_NAME/bin/linux-virtual-host`)
2. Open a terminal emulator and go to the folder where you extracted the script
3. **Only for the first time**: go into folder `ssl` and generate a Root Key (we need it for generating localhost SSL certificates after) giving these commands:
	-  `openssl req -x509 -nodes -new -sha256 -days 1024 -newkey rsa:2048 -keyout Root.key -out Root.pem -subj "/C=YOUR_COUNTRY/CN=root"`
	-  `openssl x509 -outform pem -in Root.pem -out Root.crt`
	- Authorize your Root Key in your browser; for example, for Google Chrome you need to: Open `Menu` > `Settings` > `Manage certificates` > `Authority` > `Import` and select the file in `home/YOUR_NAME/bin/linux-virtual-host/ssl/Root.crt`; check all flags and click `Ok`
		
4. **Only for the first time**: edit the file `linux-virtual-host.sh` to complete the following variables:
	- `_USER_CONFIGS[host_owner]`: this is your username in the system; it's **VERY IMPORTANT** to set the correct username because otherwise the script could give unexpected results
	
5. When you're in the same folder that contains the script, type the following code:

		sudo chmod +x linux-virtual-host.sh
		
6. Type the following code:

		sudo ./linux-virtual-host.sh HOST_NAME
		
where `HOST_NAME` is the name that you want to give to your new host/site. It can be any word. Please note that this will be also the name of the folder in `var/www`

7. During installation, a password is required: it is used to generate the certificate; since it will only be used locally, you can also put a simple one like `1234`
8. Open your browser and point it to address `https://HOST_NAME.local` for verify that it work.

### Example

Suppose you want to create a host named `myfantasticsite`; you have to type in terminal

		sudo ./linux-virtual-host.sh myfantasticsite
		
If you open a browser going to address

		https://myfantasticsite.local
		
you should be able to see a welcome page.

### Customizing

if you want, you can modify some variables in the array `_USER_CONFIGS` using values as you like; for example for `_USER_CONFIGS[host_suffix]` where you can put a custom extension like `.developing` or variables related to the SSL certificate generation, like `_USER_CONFIGS[country]` and so on.

Enjoy!
