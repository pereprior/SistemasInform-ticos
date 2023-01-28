#!/bin/bash
#Script con los comandos utilizados por: Pere Prior

#Creacion de usuarios y grupos
sudo useradd usu_sinformacion
sudo passwd usu_sinformacion
sudo useradd usu_desarrollo
sudo passwd usu_desarrollo
sudo useradd usu_explotacion
sudo passwd usu_explotacion

sudo groupadd SistemasInformacion
sudo usermod -aG SistemasInformacion usu_sinformacion
sudo groupadd DesarrolloSoftware
sudo usermod -aG DesarrolloSoftware usu_desarrollo
sudo groupadd ExplotacionSoftware
sudo usermod -aG ExplotacionSoftware usu_explotacion

sudo chsh -s /bin/bash usu_sinformacion
sudo chsh -s /bin/bash usu_desarrollo
sudo chsh -s /bin/bash usu_explotacion

#Permisos por defecto en toda la estructura
mkdir proyectos
setfacl -m d:o:0 proyectos/
setfacl -m o:0 proyectos/
setfacl -m d:g:SistemasInformacion:7 proyectos/
setfacl -m g:SistemasInformacion:7 proyectos/
setfacl -m d:g:DesarrolloSoftware:1 proyectos/
setfacl -m g:DesarrolloSoftware:1 proyectos/
setfacl -m d:g:ExplotacionSoftware:1 proyectos/
setfacl -m g:ExplotacionSoftware:1 proyectos/
getfacl proyectos/

#Permisos especificos de cada carpeta
#src
mkdir -p proyectos/pruebas proyectos/src
setfacl -m d:g:DesarrolloSoftware:7 proyectos/src
setfacl -m g:DesarrolloSoftware:7 proyectos/src
setfacl -m d:g:ExplotacionSoftware:5 proyectos/src
setfacl -m g:ExplotacionSoftware:5 proyectos/src
getfacl proyectos/src/
#pruebas
setfacl -m d:g:ExplotacionSoftware:7 proyectos/pruebas
setfacl -m g:ExplotacionSoftware:7 proyectos/pruebas
getfacl proyectos/pruebas/

touch proyectos/Proyecto1.pdf proyectos/Proyecto2.pdf proyectos/pruebas/prueba1.pdf proyectos/pruebas/prueba2.pdf proyectos/src/app1.sh proyectos/src/app2.sh
tree proyectos/
