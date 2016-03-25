# Owncloud Docker Container
All you need to build a docker container of OwnCloud.
This container is based on aphine and contains the OwnCloud apps contacts, documents and calendar.
Also there is no tls/ssl support. For transport encryption you should use a separate
nginx reverse proxy.

## Run with existing config
To run this container you need an existing owncloud config and data directory

    docker run --name owncloud -v $PWD/config:/owncloud/config -v $PWD/data:/owncloud/data d4v1d31/owncloud

Depending on your database you should link this container to a database container.

## Run OwnCloud for the first time
For the first run without existing configuration or database you could set this
Envirenment variables:

|Variable| Default | Description |
|--------------------------------|
|DBTYPE  | mysql       | Type of database (only mysql supportet yet)|
|DBNAME  | owncloud    | Database name                              |
|DBHOST  | mysqldb     | Hostname or address to datatbase           |
|DBUSER  | root        | Database Username for OwnCloud             |
|DBPASS  | password    | Password for database username             |
|ADMIN   | admin       | Username for OwnCloud administrator        |
|ADMINPASS| password   | Password for OwnCloud administrator        |

Or run with the default settings like this:

    docker run --name db -e MYSQL_ROOT_PASSWORD=password -d mariadb
    docker run --name owncloud -v $PWD/config:/owncloud/config \
                               -v $PWD/data:/owncloud/data \
                               --link mariadb:mysqldb d4v1d31/owncloud

## Add more OwnCloud apps
To add more apps copy the download link of the app and add two lines like this to
the Dockerfile:

    ADD	https://github.com/owncloud/calendar/releases/download/v1.0/calendar.tar.gz /tmp/
    RUN	tar -xzf /tmp/calendar.tar.gz -C /owncloud/apps/

Additional the app must be enable add container start, so you should add a line
like the following to the start.sh:

    $ocdir/occ app:enable calendar

Now rebuild the image.
