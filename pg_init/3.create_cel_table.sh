#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "asterisk" <<-EOSQL
	CREATE TABLE cel (
        id serial , 
        eventtype varchar (30) NOT NULL ,
        eventtime timestamp NOT NULL ,
        userdeftype varchar(255) NOT NULL ,
        cid_name varchar (80) NOT NULL , 
        cid_num varchar (80) NOT NULL ,
        cid_ani varchar (80) NOT NULL , 
        cid_rdnis varchar (80) NOT NULL ,
        cid_dnid varchar (80) NOT NULL ,
        exten varchar (80) NOT NULL ,
        context varchar (80) NOT NULL , 
        channame varchar (80) NOT NULL ,
        appname varchar (80) NOT NULL ,
        appdata varchar (80) NOT NULL , 
        amaflags int NOT NULL ,
        accountcode varchar (20) NOT NULL ,
        peeraccount varchar (20) NOT NULL ,
        uniqueid varchar (150) NOT NULL ,
        linkedid varchar (150) NOT NULL , 
        userfield varchar (255) NOT NULL ,
        peer varchar (80) NOT NULL 
);
EOSQL