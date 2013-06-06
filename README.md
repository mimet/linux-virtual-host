linux-virtual-host
==================

Bash script that allow you to create multiple virtual hosts on a local *buntu system

-----

The script allows you to create multiple virtual hosts to suit your needs simply by invoking it from a terminal with root privileges and passing it the name of the host. 

#####It was created, tested and running on Xubuntu 13.04 - Raring Ringtail

----- 


##How to use
1. Download and unzip in any folder
2. Open a terminal emulator and change to the folder where you extracted the script
3. When you're in the same folder that contains the script, type the following code:

		sudo chmod a+rwx linux-virtual-host.sh
		
4. Now, type the following code:

		sudo ./linux-virtual-host.sh HOST_NAME PRE_HOST OWNER_OF_HOST
where 

- `HOST_NAME` is the name that you want to give to your new host/site. It can be any word. Please note that this will be also the name of the folder in `var/www`
- `PRE_HOST` is a string that you can prepend to the name of host for greater order. If you don't type anything, for default it will be `dev.` Please also note that if you don't choose a `PRE_HOST` string, the `OWNER_NAME` of `HOST` will be set to `root`. If you like `dev.` as `PRE_HOST`, type it! 
- `HOST_NAME` is the name of the owner of the folder `HOST` in `var/www`. If you don't choose an owner, it will be automatically `root` and then you have to change manually the permission to `HOST` folder in `var/www`

###Example

Suppose you want to create a host named `pluto` that have ad `PRE_HOST` the string `is_dog`. After the first 3 points, you have to type in terminal

		sudo ./linux-virtual-host.sh pluto is_dog  


####Modifica file hosts

Aprire un terminale e digitare:

	sudo NOME_EDITOR_DI_TESTO /etc/hosts

Nel file che si apre, aggiungere quanto segue sotto agli host già presenti

	127.0.0.1	NOME_HOST_COMPLETO 

Salvare il file e chiuderlo



####Abilitare l'uso dell'host

Digitare nel terminale:

	sudo EDITOR_DI_TESTO /etc/apache2/sites-available/NOME_HOST

Digitare quanto segue nel file che si apre:	

	<VirtualHost *:80>
	DocumentRoot /var/www/NOME_HOST
	ServerName NOME_HOST_COMPLETO
	ServerAlias NOME_HOST
	</VirtualHost>
										
Salvare il file e chiuderlo




####Applicare le modifiche
Digitare nel terminale:

	sudo a2ensite NOME_HOST

e dare invio, dopodiché digitare

	sudo /etc/init.d/apache2 reload

e dare invio

####
Digitando ora, in qualsiasi browser, l'indirizzo NOME_HOST_COMPLETO, sarà visibile la index del sito ospitato nella cartella suddetta
