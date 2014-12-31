#!/bin/bash

BACKUP_DIR="${1}"
if [ -z "${BACKUP_DIR}" ] ; then
  echo "No backup-dir specified"
  exit 1
fi

slapcat -n 0 > ${BACKUP_DIR}/config.ldif
slapcat -n 1 > ${BACKUP_DIR}/data.ldif
if [ ! -f ${BACKUP_DIR}/data.ldif ] ; then
	echo "unable to dump ldap database"
	exit 1
fi
