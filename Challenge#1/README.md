# Challenge #1
This project creates a sample 3-tier environment in aws using terraform.

All configurable parameters are stored in `envs/challenge.tfvars` file.

RDS module generates a random root password, username value is taken from the variable `app_name`
it also creates 3 secrets in aws secret manager to store the dns hostname, username and password for the RDS database.

A python script is part of the ec2 module which is copied to all app servers.
The script accepts HTTP GET request on path `/status` and tries to initiate a database connection. If connection is established it responds with http 200.
The scripts accepts 3 arguments `db_host` `db_username` `db_password` to be able to initiate a connection to db
The script has to be started manually for now, it can be automated by attaching a IAM role to the EC2 instance to allow fetching the secrets from secret manager.

The target group has the same path `/status` configured in the health check.

# Usage

```
terraform init
terraform plan -var-file=envs/challenge.tfvars
terraform apply -var-file=envs/challenge.tfvars
```