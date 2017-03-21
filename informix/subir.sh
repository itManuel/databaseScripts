#!/bin/sh
# bajar.sh: parecido a dbexport, pero no lockea la base. genera un directorio con dbschemas de c/tabla y unloads de c/tabla.
#
# bajar.sh: like dbexport, but this don't lock the database. It make a directory with dbschemas and data of one to one table.
#
# (c)2009 manuel fernando aller manuel.aller@gmail.com
# CHANGELOG:
# 20090511 v.0.01: inicio, funcionalidades basicas
#                  initial release, basic functionalities
#

DB=$1
until [ $DB ]
do
	echo -n "Base de Datos: "
	read DB
done

until [ $DBSPACE ]
do
	echo -n "Dbspace: "
	read DBSPACE
done

if [ -r "${DB}.tar" ]
then
	tar xvf ${DB}.tar
else
	echo "no existe el archivo ${DB}.tar ni el directorio ${DB}"
	exit
fi

if [ -r "${DB}" ]
then
	cd ${DB}
else
	echo "no existe el directorio ${DB}"
	exit
fi

dbaccess sysmaster 2>/dev/null << EOSQL
create database ${DB} in ${DBSPACE}
EOSQL

if [ -r "${DB}.sql" ]
then
	dbaccess ${DB} ${DB}.sql
else
	echo "el archivo descriptivo de la base ${DB}.sql no existe"
	exit
fi

if [ $? != 0 ]
then
	echo "no se puede crear el esquema, puede que dependa de otras bases..."
	exit
fi

# parte en la que creo un listado ejecutable con todos los loads que hay que tirar...

grep 'create table' $DB.sql |sed '1,$s/^.*\.//' |sed '1,$s/ //g' > temporal

sed '1,$s/^/\.\.\/subo.sh '${DB}' /' temporal |sed '1,$s/$/ S/' > temporal2
#exit
chmod +x temporal2

#./temporal2


#cd ../

#tar cvf ${DB}.tar ${DB} && rm -rf ${DB} 
