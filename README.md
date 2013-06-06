linux-virtual-host
==================

Creation of virtual hosts on Linux for develop sites


La seguente guida consente di configurare un host virtuale su un sistema Linux, per i siti
contenuti nella cartella var/www di Apache.
Data una cartella di nome NOME_HOST, per accedervi in locale, bisogna digitare nel browser "localhost/NOME_SITO". 
Seguendo la guida, basterà digitare NOME_HOST per accedere direttamente al sito in locale.


Il tutto è stato testato e funzionante su Xubuntu 13.04


|--- Alias dei nomi usati ---|
NOME_EDITOR_DI_TESTO = Nome dell'editor di testo di sistema (su Xubuntu è "mousepad")
NOME_HOST = Nome della cartella del sito presente in /var/www
NOME_HOST_COMPLETO = Nome della cartella del sito con una stringa a proprio piacere
  	 a precederlo. Non è necessario aggiungere alcuna stringa, ma, per
			 ragioni di pulizia, è preferibile inserire una stringa come ad esempio
			 "dev." ad ogni sito, per cui, la mia NOME_HOST_COMPLETO in questo caso
			 equivale a dev.NOME_HOST
				 
		 
|--- Procedura ---|


- 1 -
Creare una cartella in /var/www di nome NOME_HOST che conterrà i file del sito
-----


- 2 -
Aprire un terminale e digitare:

	sudo NOME_EDITOR_DI_TESTO /etc/hosts

Nel file che si apre, aggiungere quanto segue sotto agli host già presenti

	127.0.0.1	NOME_HOST_COMPLETO 

Salvare il file e chiuderlo
-----


- 3 -
Digitare nel terminale:

	sudo EDITOR_DI_TESTO /etc/apache2/sites-available/NOME_HOST

Digitare quanto segue nel file che si apre:	

	<VirtualHost *:80>
	DocumentRoot /var/www/NOME_HOST
	ServerName NOME_HOST_COMPLETO
	ServerAlias NOME_HOST
	</VirtualHost>
										
Salvare il file e chiuderlo
---


- 4 -
Digitare nel terminale:

	sudo a2ensite NOME_HOST

e dare invio

dopodiché digitare

	sudo /etc/init.d/apache2 reload

e dare invio

- 5 -
Digitando ora, in qualsiasi browser, l'indirizzo NOME_HOST_COMPLETO, sarà
visibile la index del sito ospitato nella cartella suddetta	
---
