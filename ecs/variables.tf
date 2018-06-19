## To DO : decide on how to pass the key-pair for ssh ing to ECS instances.

variable "region" {
  description = "AWS region to deploy (default Singapore)"
  default = "ap-northeast-1"
}

variable "pre_tag" {
    description = "Pre-tag to be attached to AWS resource names for identification"
    default = ""
}

variable "tag_environment" {
  description = "Specify the environment"
  default = "test"
}

variable "aws_private_subnet_ids" {
    type = "list"
    description = "Subnet IDs of private subnets"
}

variable "aws_security_group_ids" {
    type = "list"
    description = "ID of private security group"
}

variable "ecs_cluster_name" {
    description = "The name of the Amazon ECS cluster."
    default = "main"
}

variable "amis" {
    description = "Which AMI to spawn. Defaults to the AWS ECS optimized images."
    # TODO: support other regions.
    default = {
        us-east-1 = "ami-5e414e24"
        ap-northeast-1 = "ami-e3166185"
    }
}

variable "autoscale_min" {
    default = "1"
    description = "Minimum autoscale (number of EC2)"
}

variable "autoscale_max" {
    default = "10"
    description = "Maximum autoscale (number of EC2)"
}

variable "autoscale_desired" {
    default = "4"
    description = "Desired autoscale (number of EC2)"
}

variable "instance_type" {
    default = "t2.micro"
}
variable "ecs_agent_disk_size" {
    default = 30
}

variable "ecs_key_pair_name" {
    description = "Key pair for ECS instances"
}
