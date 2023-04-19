## MSQL resource
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance

## Connecting to a DB instance running the PostgreSQL database engine
```
https://www.hostinger.com/tutorials/how-to-install-postgresql-on-centos-7/
yum update -y
yum install postgresql-server postgresql-contrib
psql --version
```

## Ubuntu
```
apt update -y
sudo apt-get install postgresql-client
psql --version
```


## Connect through the CLI
- The default db in postgres is `postgres`
```
https://www.timescale.com/blog/how-to-install-psql-on-mac-ubuntu-debian-windows/
psql -h [HOSTNAME] -p [PORT] -U [USERNAME] -W -d [DATABASENAME]
psql -h s3-postgres.cv3uwkomseya.us-east-1.rds.amazonaws.com -p 5432 -U s3postgres -W -d s3
```