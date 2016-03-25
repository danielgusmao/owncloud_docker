#!/bin/bash

ocdir=/owncloud

# update alpine
apk update && apk upgrade
rm -rf /var/cache/apk/*

if [ -e $ocdir/config/config.php ]
then
  # nothing to do here
  echo "OwnCloud is allready installed!"

else
  # run install
  php  $ocdir/occ  maintenance:install --database "${DBTYPE:-mysql}" \
				       --database-name "${DBNAME:-owncloud}" \
                                       --database-host "${DBHOST:-mysqldb}" \
		                       --database-user "${DBUSER:-root}" \
                                       --database-pass "${DBPASS:-password}" \
                                       --admin-user "${ADMIN:-admin}" \
                                       --admin-pass "${ADMINPASS:-password}"
fi

# enable default apps
$ocdir/occ app:enable documents
$ocdir/occ app:enable contacts
$ocdir/occ app:enable calendar

# fix rights for productivity
set_rights.sh ${ocdir}

# go RUN!
php-fpm
nginx &
tail -f $ocdir/data/owncloud.log
