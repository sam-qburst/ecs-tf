variable "aws_subnet_id" {
  description = "Subnet ID for deploying Bastion Host"
}

variable "pre_tag" {
  description = "Pre-tag to be attached to AWS resource names for identification"
  default = ""
}

variable "env_tag" {
  description = "Specify the environment"
  default = "test"
}

variable "bastion_ami" {
  type = "map"
  default = {
    ap-northeast-1 = "ami-ceafcba8"
  }
}

variable "region" {
  description = "AWS region to deploy (default Singapore)"
  default = "ap-northeast-1"
}

variable "bastion_key_pair_name" {
  description = "the keypair name of the pemfile to be used in bastion host. This keypair should exist in the same region"
  default = "bastion-key"
}

variable "aws_security_group_ids" {
  type = "list"
  description = "List of AWS security groups to be added to the instance"

}