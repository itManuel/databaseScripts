#!/bin/sh
# bajo.sh: baja a lo pavote data de una tabla, comprimiendo con gzip el unload generado
# acepta como parametros: DATABASE TABLE COMPRESS(S/Y/s/y)
#
# bajo.sh: unloads a table to an archive, and has the ability to compress the file generated.
# accepts parameters, or ask for them: DATABASE, TABLE and COMPRESS(Y/y) flag.
#
# (c)2009 manuel fernando aller manuel.aller@gmail.com
# CHANGELOG:
# 20090511 v.0.01: inicio, funcionalidades basicas
#                  initial release, basic functionalities
# 20090511 v.0.02: agregado el unload comun para tablas chicas
#                  added simple unload for small tables
#
#
#

DATABASE=$1
TABLE=$2
COMPRESS=$3

until [ ${DATABASE} ]
do
	echo -n "Base de Datos/Database: "
	read DATABASE
done
until [ ${TABLE} ]
do
	echo -n "Tabla/Table: "
	read TABLE
done
until [ ${COMPRESS} ]
do
	echo -n "Comprimir?/Compress?: "
	read COMPRESS
done
ARCHIVE=${TABLE}.unl

# hay maquinas viejas que NO TIENEN onpladm:
if [ -r "${INFORMIXDIR}/bin/onpladm" ]
then
#conectar con HPL para un unload lleva tiempo, solo tiene sentido si la tabla es GRANDE...
dbaccess $DATABASE >/dev/null 2>/dev/null << EOSQL
unload to /tmp/${DATABASE}-${TABLE}.count select count(*) as hay from $TABLE 
EOSQL

HAY=`cat /tmp/${DATABASE}-${TABLE}.count|sed '1,$s/\..*//'`
rm /tmp/${DATABASE}-${TABLE}.count

if [ ${HAY} -gt 10000 ]
then
	onpladm create project test
	onpladm create job ${DATABASE}-${TABLE} -D $DATABASE -t $TABLE -f u -d $ARCHIVE
	onpladm run job ${DATABASE}-${TABLE} -f u
	onpladm delete job ${DATABASE}-${TABLE} -f u
	onpladm delete project test
else
	dbaccess $DATABASE >/dev/null 2>/dev/null <<PEDRO
	unload to $ARCHIVE select * from $TABLE
PEDRO
	
fi

else
	dbaccess $DATABASE >/dev/null 2>/dev/null <<PEDRO
	unload to $ARCHIVE select * from $TABLE
PEDRO
fi
	



if [ ${COMPRESS} = 'S' ]
then
	gzip $ARCHIVE
else
	if [ ${COMPRESS} = 's' ]
	then
		gzip $ARCHIVE
	else
		if [ ${COMPRESS} = 'Y' ]
		then
			gzip $ARCHIVE
		else
			if [ ${COMPRESS} = 'y' ]
			then
				gzip $ARCHIVE
			fi
		fi
	fi
fi
