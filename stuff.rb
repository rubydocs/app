# create database

psql -h XXX.eu-central-1.rds.amazonaws.com -U postgres
create role chief with createdb login password 'password';
RAILS_ENV=production bin/rails db:create

h pg:backups:download
pg_restore --verbose --clean --no-acl --no-owner -h XXX.eu-central-1.rds.amazonaws.com -U chief -d rubydocs_production latest.dump
