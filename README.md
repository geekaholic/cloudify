# Cloudify a project

This repo contains example terraform scripts to deploy a CI/CD CodePipeline on AWS. The pipeline will monitor for code changes of a git repo, build a docker image of it and push to ERC. That's it for now!

Feel free to fork and adopt for your needs.

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

