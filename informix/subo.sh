#!/bin/sh
# subo.sh: sube a lo pavote data a una tabla, descomprimiendo el archivo si vino comprimido
# acepta como parametros: DATABASE TABLE COMPRESS(S/Y/s/y)
#
# (c)2009 manuel fernando aller manuel.aller@gmail.com
# CHANGELOG:
# 20090511 v.0.01: inicio, funcionalidades basicas
#                  initial release, basic functionalities
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


# hay maquinas viejas que NO TIENEN onpladm:
if [ -r "${INFORMIXDIR}/bin/onpladm" ]
then
	#conectar con HPL para un unload lleva tiempo, solo tiene sentido si la tabla es GRANDE...
	HAY=`wc -l ${ARCHIVE}|cut -f1 -d' '`

	if [ ${HAY} -gt 90000 ]
	then
		onpladm create project test
		onpladm create job ${DATABASE}-${TABLE} -D $DATABASE -t $TABLE -f l -d $ARCHIVE
		onpladm run job ${DATABASE}-${TABLE} -f l
		onpladm delete job ${DATABASE}-${TABLE} -f l
		onpladm delete project test
	else
		dbaccess $DATABASE >/dev/null 2>/dev/null <<PEDRO
		load from $ARCHIVE insert into $TABLE
PEDRO
		
	fi

	else
		dbaccess $DATABASE >/dev/null 2>/dev/null <<PEDRO
		load from $ARCHIVE insert into $TABLE
PEDRO
fi
	
if [ $? != 0 ]
then
	echo "problemas subiendo ${DATABASE}:${TABLE} "
	exit
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

