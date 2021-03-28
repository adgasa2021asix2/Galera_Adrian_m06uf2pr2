#!/bin/bash
clear

if (( EUID != 0 ))
then
  echo "S'ha d'executar com a root"
  exit 9 
fi

declare -r UID_INIC=3001   	# Ho diu l'ennunciat
declare -r GROUP=users		# Ho diu l'ennunciat  
declare -r SHELL=/bin/bash	#Al meu criteri

wget http://www.collados.org/asix2/m06/uf2/pr1/usuaris.ods

libreoffice --headless --convert-to csv usuaris.ods 

uid=$UID_INIC
for nom in $(cut -d ',' -f 2 usuaris.csv)
do
    dir=/home/$nom

    ctrsnya=$(mkpasswd " ")

    useradd $nom -u $uid -g $GROUP -d $dir -m -s $SHELL -p $(mkpasswd $ctrsnya)

    echo $nom $ctrsnya >> passwords.csv    

    uid=$(( uid + 1 ))

done

rm usuaris.csv usuaris.ods

exit 0
