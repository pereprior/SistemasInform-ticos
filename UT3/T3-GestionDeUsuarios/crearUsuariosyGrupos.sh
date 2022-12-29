#!/bin/bash
#
#Autor: Pere Prior
#


#Menu principal
clear

echo "<1. Crear grupos> <2. Crear Usuarios> <3. Borrar Grupos> <4. Borrar Usuarios>"
read eleccion
case $eleccion in

#Crear grupos
1)

	echo "Introduce el nombre del fichero"
	read fichero

	while read line; do

		nombre=$(echo $line | cut -d ',' -f1)
		sudo addgroup $nombre

	done < $fichero

;;


#Crear usuarios
2)

	echo "Introduce el nombre del fichero"
	read fichero

	while read line; do

		cuenta=$(echo $line | cut -d ',' -f1)
		password=$(echo $line | cut -d ',' -f2)
		nombre=$(echo $line | cut -d ',' -f3)
		departamento=$(echo $line | cut -d ',' -f5)

		sudo useradd -s /bin/bash $cuenta
		mkdir /home/$cuenta
		sudo usermod -p $password -c $nombre -d /home/$cuenta -g $departamento
		tail -1 /etc/passwd

	done < $fichero
;;


#Borrar grupos
3)

	echo "Introduce el nombre del fichero"
	read fichero

	while read line; do

		nombre=$(echo $line | cut -d ',' -f1)
		sudo delgroup $nombre

	done < $fichero

;;


#Borrar usuarios
4)

	echo "Introduce el nombre del fichero"
	read fichero

	while read line; do

		nombre=$(echo $line | cut -d ',' -f1)
		sudo deluser --remove-home $nombre

	done < $fichero

;;

esac
