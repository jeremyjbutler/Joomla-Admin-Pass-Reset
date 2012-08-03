#!/bin/bash

#Joomla Password Reseter, resets admin password to 'secret'. Run from Docroot
#Pressing R and enter at the end will reset password to original, ctrl+c leaves it as 'secret'

##Get the database creds to reset the passs with
getbuser=$(cat configuration.php|grep user|cut -d\' -f2|sed '/^$/d')
getthedb=$(cat configuration.php|grep "var\ \$db\ \=\ "|cut -d\' -f2|sed '/^$/d')
getdbpassword=$(cat configuration.php|grep password|cut -d\' -f2)
getdbprefix=$(cat configuration.php|grep "prefix"|cut -d\' -f2|sed '/^$/d')
getdbhost=$(cat configuration.php|grep "\$host"|cut -d\' -f2|sed '/^$/d')

#Store current password in $oldpass
read oldpass <<<$(mysql -h"${getdbhost}" -u"${getbuser}" -p"${getdbpassword}" -D "$getthedb" -e "select password from "${getdbprefix}"users where id='62'"|tail -n 2|grep -v "\-\-\-"|grep -v password)


#Joomla admin Id is always 62 unless initial admin user was removed :\
#This hash works on every system also, its actually from the joomla docs :\
mysql -h"${getdbhost}" -u"${getbuser}" -p"${getdbpassword}" -D "$getthedb" -e "update "${getdbprefix}"users set password='5ebe2294ecd0e0f08eab7690d2a6ee69' where id='62';"

exitorrest=NULL;
#This changes password to 'secret'
echo "The password is changed to secret, press R and enter to reset to original or ctrl+c to exit"
read exitorrest;

if [ $exitorrest == "R" ] || [ $exitorrest == "r" ];
then
mysql -h"${getdbhost}" -u"${getbuser}" -p"${getdbpassword}" -D "$getthedb" -e "update "${getdbprefix}"users set password='"${oldpass}"' where id='62';"
fi

