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

if [ -r "${DB}" ]
then
	cd ${DB}
else
	mkdir ${DB}
	cd ${DB}
fi

# parte en la que creo un listado ejecutable con todos los dbschemas que hay que tirar...
dbschema -q -ss -d $DB $DB.sql
grep 'create table' $DB.sql |sed '1,$s/^.*\.//' |sed '1,$s/ //g' > temporal
#dbschema -q -ss -d $DB |grep 'create table' |sed '1,$s/^.*\.//' |sed '1,$s/ //g' > temporal
#paste temporal temporal > temporal2
#sed '1,$s/^/dbschema -q -ss -d '${DB}' -t /' temporal2 |sed '1,$s/	/ /' |sed '1,$s/$/.sql/' > temporal3
#
## parte en la que ejecuto el listado
#chmod +x temporal3
#./temporal3

sed '1,$s/^/\.\.\/bajo.sh '${DB}' /' temporal |sed '1,$s/$/ S/' > temporal2
#exit
chmod +x temporal2

./temporal2


cd ../

tar cvf ${DB}.tar ${DB} && rm -rf ${DB} 
