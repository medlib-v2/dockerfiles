#!/bin/bash
set -e


# if we're linked to MySQL, and we're using the root user, and our linked
# container has a default "root" password set up and passed through... :)
: ${DB_USERNAME:=root}
if [ "$DB_USERNAME" = 'root' ]; then
	: ${DB_PASSWORD:=$MYSQL_ENV_MYSQL_ROOT_PASSWORD}
fi

echo "DB_USERNAME=$DB_USERNAME" >> .env
echo "DB_PASSWORD=$DB_PASSWORD" >> .env

if [ ! -d /var/www/medlib/storage ]; then
	cp -Rp /var/www/medlib/docker-backup-storage /var/www/medlib/storage
else
	IN_STORAGE_BACKUP="$(ls /var/www/medlib/docker-backup-storage/)"
	for path in $IN_STORAGE_BACKUP; do
		if [ ! -e "/var/www/medlib/storage/$path" ]; then
			cp -Rp "/var/www/medlib/docker-backup-storage/$path" "/var/www/medlib/storage/"
		fi
	done
fi

if [ ! -d /var/www/medlib/public/avatars ]; then
	cp -Rp /var/www/medlib/docker-backup-public-avatars /var/www/medlib/public/avatars
else
	IN_LOGO_BACKUP="$(ls /var/www/medlib/docker-backup-public-avatars/)"
	for path in $IN_LOGO_BACKUP; do
		if [ ! -e "/var/www/medlib/public/avatars/$path" ]; then
			cp -Rp "/var/www/medlib/docker-backup-public-avatars/$path" "/var/www/medlib/public/avatars/"
		fi
	done
fi

chown www-data .env

exec "$@"
