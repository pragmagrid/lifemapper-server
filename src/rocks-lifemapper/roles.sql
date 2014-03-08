/* enable pgcrypto module ; */
create extension pgcrypto; 

/* create password for postgres user */
ALTER USER postgres with encrypted password 'PASSpostgres';

/* create user admin */
CREATE ROLE admin with CREATEROLE CREATEDB LOGIN ENCRYPTED PASSWORD  'PASSadmin';
GRANT ALL ON DATABASE template1 TO admin WITH GRANT OPTION;

/* create user roles */
CREATE ROLE reader NOINHERIT;
CREATE ROLE writer CREATEDB NOINHERIT;

CREATE ROLE mapuser with LOGIN INHERIT ENCRYPTED PASSWORD  'PASSmapuser';
GRANT reader TO mapuser;

CREATE ROLE sdlapp with LOGIN INHERIT ENCRYPTED PASSWORD  'PASSsdlapp';
GRANT writer TO sdlapp;

CREATE ROLE wsuser with LOGIN INHERIT ENCRYPTED PASSWORD  'PASSwsuser';
GRANT writer TO wsuser;

CREATE ROLE jobuser with LOGIN INHERIT ENCRYPTED PASSWORD 'PASSjobuser';
GRANT writer TO jobuser;

