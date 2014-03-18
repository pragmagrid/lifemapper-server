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

/* permissions for reader */
CREATE ROLE mapuser with LOGIN INHERIT ENCRYPTED PASSWORD  'PASSmapuser';
GRANT reader TO mapuser;

/* permissions for writer */
CREATE ROLE sdlapp with LOGIN INHERIT ENCRYPTED PASSWORD  'PASSsdlapp';
CREATE ROLE wsuser with LOGIN INHERIT ENCRYPTED PASSWORD  'PASSwsuser';
CREATE ROLE jobuser with LOGIN INHERIT ENCRYPTED PASSWORD 'PASSjobuser';
GRANT writer TO sdlapp;
GRANT writer TO wsuser;
GRANT writer TO jobuser;

