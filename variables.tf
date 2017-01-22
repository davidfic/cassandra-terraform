variable "security_group_name" {
  description = "The name for the security group"
}

variable "vpc_id" {
  description = "The VPC this security group will go in"
}

variable "source_cidr_block" {
  description = "The source CIDR block to allow traffic from"
  default = "0.0.0.0/0"
}

# Ubuntu 16.04 LTS AMI Linux
variable "ami" {
    default = {
        us-east-1 = "ami-8fe79998"
    }
}

# AWS Vars
variable "key_name" {
    description = "SSH key name in your AWS account for AWS instances."
}

variable "key_path" {
    description = "Path to the private key specified by key_name."
}

variable "region" {
    default = "us-east-1"
    description = "The region of AWS, for AMI lookups."
}

variable "instance_type" {
    default = "t2.small"
    description = "Name of the AWS instance type"
}

variable "ebs_size_gb" {
  description = "size of the Cassandra data disk volume in gigabytes"
}

variable "environment" {
  description = "environment name to tag instace with"
}

variable "az1_pub_subnet_cidr" {
  description = "az1 public subnet cidr block"
}

variable "az1" {
	description = "First Availability Zone"
  default = "us-east-1a"
}

variable "subnet_id_1" {
  description = "first subnet id"
}

variable "subnet_id_2" {
  description = "second subnet id"
}

variable "count" {
  description = "how many cassandra nodes do you want"
  default = 2
}
