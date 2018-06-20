variable "region" {
  description = "AWS region to deploy (default Singapore)"
  default     = "ap-northeast-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the vpc"
  default     = "10.0.0.0/16"
}

variable "pre_tag" {
  description = "Pre-tag to be attached to AWS resource names for identification"
  default     = ""
}

variable "tag_environment" {
  description = "Specify the environment"
  default     = "test"
}

variable "public_subnet_count" {
  description = "The number of public subnets to deploy across (must be minimum of two to use ALB)"
  default     = 2
}

variable "private_subnet_count" {
  description = "The number of private subnets to deploy across (must be minimum of two to use ALB)"
  default     = 2
}

variable "public_subnet_cidr" {
  type        = "list"
  description = "The CIDR blocks for the public subnets"
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_cidr" {
  type        = "list"
  description = "The CIDR blocks for the private subnets"
  default     = ["10.0.100.0/24", "10.0.101.0/24"]
}

variable "ssh_allowed_ip" {
  description = "IP address allowed to SSH to bastion instance"
  default     = "0.0.0.0/0"
}

variable "ecs_cluster_name" {
  description = "The name of the Amazon ECS cluster."
  default     = "main"
}

variable "ecs_instance_count" {
  description = "Number of EC2 instances in ECS cluster"
  default     = 4
}

variable "ecs_key_pair_name" {
  description = "Key pair for ECS instances"
}

variable "bastion_key_pair_name" {
  description = "Key pair for bastion instance"
}

variable "project" {
  description = "Specify the project name - ecs"
}

variable "node_app_ecr_uri" {
  description = "ECR Repository URI"
}

variable elb_port {
  description = "port to expose the app in the elb"
}

variable "node_app_image_tag" {
  description = "Docker image tag in ECR"
}

variable "node_app_min_capacity" {
  description = "Minimum number of containers to run"
}

variable "node_app_max_capacity" {
  description = "Maximum number of containers to run"
}
