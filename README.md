# Cloudify project

This repo contains terraform scripts to deploy a CI/CD pipeline on AWS.

Configure your AWS credentials

```
vim ~/.aws/credentials

[default]
aws_access_key_id = XXXXXX
aws_secret_access_key = YYYYY
```

Make a copy of `dev/terraform.tfvars.example` and modify it

```
cp dev/terraform.tfvars.example dev/terraform.tfvars
vim dev/terraform.tfvars
```

```
cd ./dev
terraform init
terraform plan
terraform apply
```

