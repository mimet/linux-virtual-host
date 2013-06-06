linux-virtual-host
==================

Bash script that allow you to create multiple virtual hosts on a local *buntu system

-----

The script allows you to create multiple virtual hosts to suit your needs simply by invoking it from a terminal with root privileges and passing it the name of the host. 

#####It was created, tested and running on Xubuntu 13.04 - Raring Ringtail

#####This script will work only if you have LAMP installed!

----- 


##How to use
1. Download and unzip in any folder
2. Open a terminal emulator and change to the folder where you extracted the script
3. When you're in the same folder that contains the script, type the following code:

		sudo chmod a+rwx linux-virtual-host.sh
		
4. Type the following code:

		sudo ./linux-virtual-host.sh HOST_NAME PRE_HOST OWNER_NAME
where 

- `HOST_NAME` is the name that you want to give to your new host/site. It can be any word. Please note that this will be also the name of the folder in `var/www`
- `PRE_HOST` is a string that you can prepend to the name of host for greater order. If you don't type anything, for default it will be `dev.` Please also note that if you don't choose a `PRE_HOST` string, the `OWNER_NAME` of `HOST` will be set to `root`. If you like `dev.` as `PRE_HOST`, type it! 
- `HOST_NAME` is the name of the owner of the folder `HOST` in `var/www`. If you don't choose an owner, it will be automatically `root` and then you have to change manually the permission to `HOST` folder in `var/www`

5. Put and index.php in `var/www/HOST_NAME` writing in it
		
		<? echo 'Script works!; ?>

and go to address `PRE_HOST/HOST_NAME` for verify that it work.

###Example

Suppose you want to create a host named `pluto` that have as `PRE_HOST` the string `is_dog` and your name is `mickey`. After the first 3 points, you have to type in terminal

		sudo ./linux-virtual-host.sh pluto is_dog mickey
If you now follow the point 5 of guide and go to address

		is_dog.pluto
		
you You should be able to see `Script work!`

Enjoy!
