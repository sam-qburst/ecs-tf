variable "vpc_id" {
  description = "VPC ID to which the sgs has to be deployed"
}

variable "vpc_cidr" {
  description = "The CIDR block for the vpc"
  default = "10.0.0.0/16"
}

variable "pre_tag" {
  description = "Pre-tag to be attached to AWS resource names for identification"
  default = ""
}

variable "tag_environment" {
  description = "Specify the environment"
  default = "test"
}

variable "ssh_allowed_ip" {
  description = "IP address allowed to SSH to bastion instance"
  default = "0.0.0.0/0"
}

