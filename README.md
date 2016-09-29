# Cassandra-terraform

Example repo that uses terraform to deploy a Cassandra cluster and Ansible to provision.

# Setup

The following tools need to be installed

- [Terraform](https://www.terraform.io/)
- Python 2.7.x
- [Virtual Env] (https://virtualenv.pypa.io/en/stable/installation/)


# Configuration

Modify `terraform.tfvars` to match your AWS environment.
Also need to ensure your EC2 instance key pair is added to ssh-agent. E.g. `ssh-add <path to pem>`
Finally Terraform will expect the following environment variables to be set

```
export AWS_ACCESS_KEY=
export AWS_SECRET_KEY=
export AWS_REGION="us-east-1"
export AWS_DEFAULT_REGION="us-east-1"
```

Use the env template to get up and running quickly.
```
cp env-template.sh dev-env.sh
```
then modify `dev-env.sh` to match your environment.

# Usage

Ensure the proper environment variables are set e.g. `source dev-env.sh`

Deploy and provision with

`make deploy`
