#!/bin/bash
#@author: pprior
#@since: 04/02/2023

#Funcion para crear usuarios y grupos de forma masiva
fntFuncion1-Grupos() {

  echo "AVISO: Para crear los usuarios debes disponer de un fichero .csv para cada uno en la misma carpeta donde tengas almacenado el script."

  #Creación de grupos masiva
  read -p "Introduce el nombre del fichero que contiene los grupos: " ficheroG

  count=0
  if [ -f $ficheroG ]; then
    while read line;
    do
      nombre=$line
      groupadd $nombre
      count=$((count + 1))
    done < $ficheroG
  else
    echo "ERROR: No se ha encontrado un fichero con el nombre que has especificado. Revisa que el nombre esta bién escrito y vuelve a intentarlo."
    return
  fi
     tail -n $count /etc/group

}

fntFuncion1-Usuarios()  {

  #Creación de usuarios
  read -p "Introduce el nombre del fichero que contiene los usuarios: " ficheroU
  count=0

  if [ -f $ficheroU ]; then

    while read line;
    do

      password=$(echo $line | cut -d ',' -f2)
      pass=`openssl passwd -1 $password`
      cuenta=$(echo $line | cut -d ',' -f1)
      grupo=$(echo $line | cut -d ',' -f3)
      useradd -m -G $grupo -p $pass -s /bin/bash $cuenta

      if [[ $grupo =~ ESO$ ]]; then
        usermod -aG ESO $cuenta
        usermod -aG ALU $cuenta
      fi

      if [[ $grupos = ADMIN ]]; then
        usermod -aG adm $cuenta
        usermod -aG cdrom $cuenta
        usermod -aG sudo $cuenta
        usermod -aG dip $cuenta
        usermod -aG plugdev $cuenta
        usermod -aG lxd $cuenta
      fi

      if [[ $grupo =~ BACH$ ]]; then
        usermod -aG BACH $cuenta
        usermod -aG ALU $cuenta
      fi

      count=$((count + 1))

      chage -d0 $cuenta

    done < $ficheroU

    tail -n $count /etc/passwd

  else
    echo "ERROR: No se ha encontrado un fichero con el nombre que has especificado. Revisa que el nombre esta bién escrito y vuelve a intentarlo."
    return
  fi

}


#Funcion que crea la estructura de directorios y asigna los permisos a los grupos
fntFuncion2() {

  read -p "AVISO: Si no has creado los usuarios y grupos anteriormente, esta opción puede dar error. Quieres continuar? [s/n]" opcion
  if [ $opcion = "s" ]; then

    #Creación del directorio principal y asignación de permisos por defecto
    mkdir /Publico
    chown administrador:administrador /Publico
    setfacl -m g:ADMIN:7 /Publico
    setfacl -m d:g:ADMIN:7 /Publico
    setfacl -m g:PROF:5 /Publico
    setfacl -m d:g:PROF:5 /Publico
    setfacl -m g:ALU:5 /Publico
    setfacl -m o:0 /Publico
    setfacl -m d:o:0 /Publico
    setfacl -m mask:7 /Publico
    setfacl -m d:mask:7 /Publico

    #Creación de los directorios restantes
    mkdir /Publico/1ESO /Publico/2ESO /Publico/3ESO /Publico/4ESO /Publico/1BACH /Publico/2BACH /Publico/1DAM
    chown administrador:administrador /Publico/1ESO /Publico/2ESO /Publico/3ESO /Publico/4ESO /Publico/1BACH /Publico/2BACH /Publico/1DAM

    #Permisos de la ESO
    setfacl -m g:1ESO:7 /Publico/1ESO
    setfacl -m g:ESO:5 /Publico/1ESO
    setfacl -m d:g:ESO:5 /Publico/1ESO
    setfacl -m g:2ESO:7 /Publico/2ESO
    setfacl -m g:ESO:5 /Publico/2ESO
    setfacl -m d:g:ESO:5 /Publico/2ESO
    setfacl -m g:3ESO:7 /Publico/3ESO
    setfacl -m g:ESO:5 /Publico/3ESO
    setfacl -m d:g:ESO:5 /Publico/3ESO
    setfacl -m g:4ESO:7 /Publico/4ESO
    setfacl -m g:ESO:5 /Publico/4ESO
    setfacl -m d:g:ESO:5 /Publico/4ESO

    #Permisos de Bachiller
    setfacl -m g:1BACH:7 /Publico/1BACH
    setfacl -m g:BACH:5 /Publico/1BACH
    setfacl -m d:g:BACH:5 /Publico/1BACH
    setfacl -m g:2BACH:7 /Publico/2BACH
    setfacl -m g:BACH:5 /Publico/2BACH
    setfacl -m d:g:BACH:5 /Publico/2BACH

    echo "La estructura se ha creado sin problemas"

  else
    echo "Volviendo al menu principal..."
  fi

}

fntFuncion3() {

  read -p "AVISO: Todos los usuarios, grupos y directorios que se han creado se van a eliminar, estás seguro que quieres continuar [s/n]?" opcion
  if [ $opcion = "s" ]; then

    #Eliminar usuarios y sus directorios personales
    read -p "Introduce el nombre del fichero .csv que contiene los usuarios a eliminar: " ficheroU
    while read line;
    do

      cuenta=$(echo $line | cut -d ',' -f1)
      deluser --remove-home $cuenta

    done < $ficheroU

    #Eliminar grupos
    read -p "Introduce el nombre del fichero .csv que contiene los grupos a eliminar: " ficheroG
    while read line;
    do

      nombre=$(echo $line)
      delgroup $nombre

    done < $ficheroG

    #Eliminar directorios
    rm -r /Publico

    echo "La estructura completa se ha eliminado correctamente."

  else
    echo "Volviendo al menu principal..."
  fi


}


#Menu principal
while [ opcion != "" ]
do
  clear
  echo "     Bienvenido" $USER
  date -s "2023-2-11 8:15"
  echo
  echo "********************************************"
  echo "*   Usuarios Locales - Gestor Documental   *"
  echo "*           @author: Pere Prior            *"
  echo "********************************************"
  echo
  echo "Selecciona la opción deseada:"
  echo "- - - - - - - - - - - - - - - - - - - - - - -"
  echo "1.)" "Crear usuarios y grupos de forma masiva"
  echo "2.)" "Crear la estructura de directorios"
  echo "3.)" "Borrar gestor documental"
  echo "0.)" "SALIR"
  echo "- - - - - - - - - - - - - - - - - - - - - - -"
  echo
  read -p "Introduce una opcion [1-3]: " opcion

  case $opcion in
    1)
      fntFuncion1-Grupos
      fntFuncion1-Usuarios
      read -p "Presiona una tecla para continuar..."
    ;;

    2)
      fntFuncion2
      read -p "Presiona una tecla para continuar..."
    ;;

    3)
      fntFuncion3
      read -p "Presiona una tecla para continuar..."
    ;;

    0)
      echo "Saliendo..."
      exit 1
    ;;

    *)
      echo "ERROR: Porfavor, introduce una opción válida [1-4]!"
      read -p "Presiona una tecla para continuar..."
    ;;

  esac
done
