#!/bin/sh
# subo.sh: automatiza la subida de datos a una tabla, descomprimiendo el archivo si vino comprimido
# acepta como parametros: DATABASE TABLE COMPRESS(S/Y/s/y)
#
# (c)2009 manuel fernando aller manuel.aller@gmail.com
# CHANGELOG:
# 20090511 v.0.01: inicio, funcionalidades basicas
#                  initial release, basic functionalities
# 20090921 v.0.02: cambio de onpladm por dbload, mas compatible con motores viejos
#

DATABASE=$1
TABLE=$2
COMPRESS=$3
DBLOADCOMMIT=5000

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

if [ ${COMPRESS} = 'S' ]
then
	gunzip ${ARCHIVE}.gz
else
	if [ ${COMPRESS} = 's' ]
	then
		gunzip ${ARCHIVE}.gz
	else
		if [ ${COMPRESS} = 'Y' ]
		then
			gunzip ${ARCHIVE}.gz
		else
			if [ ${COMPRESS} = 'y' ]
			then
				gunzip ${ARCHIVE}.gz
			fi
		fi
	fi
fi


# hay maquinas viejas que NO TIENEN dbload?
if [ -r "${INFORMIXDIR}/bin/dbload" ]
then
	CAMPOS=`head -1 ${ARCHIVE} |grep -o "|" |wc -l`
	CMDFILE=/tmp/${DATABASE}${TABLE}.cmd
	LOGFILE=/tmp/${DATABASE}${TABLE}.log
	echo "FILE ${ARCHIVE} DELIMITER '|' ${CAMPOS};" > $CMDFILE
	echo "INSERT INTO ${TABLE};" >> $CMDFILE
	dbload -d ${DATABASE} -c $CMDFILE -l $LOGFILE -n $DBLOADCOMMIT
	if [ ! $? -eq 0 ] ; then
		echo "PROBLEMAS cargando la tabla ${TABLE}"
		cat $LOGFILE
		exit 1;
	fi
	# borro los temporales, si hubo...
	rm $CMDFILE $LOGFILE
else
	# no encontre el dbload.... 
	dbaccess $DATABASE >/dev/null 2>/dev/null <<PEDRO
		load from $ARCHIVE insert into $TABLE
PEDRO
fi
	
if [ $? != 0 ]
then
	echo "problemas subiendo ${DATABASE}:${TABLE} "
	exit 1
else

	if [ ${COMPRESS} = 'S' ]
	then
		gzip ${ARCHIVE}
	else
		if [ ${COMPRESS} = 's' ]
		then
			gzip ${ARCHIVE}
		else
			if [ ${COMPRESS} = 'Y' ]
			then
				gzip ${ARCHIVE}
			else
				if [ ${COMPRESS} = 'y' ]
				then
					gzip ${ARCHIVE}
				fi
			fi
		fi
	fi
fi

