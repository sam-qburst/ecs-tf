## Variables used in node_app service
variable "region" {
  description = "AWS region to deploy"
}

variable "pre_tag" {
  description = "Pre-tag to be attached to AWS resource names for identification"
}

variable "env_tag" {
  description = "Tag to identify the environment - dev/stg/prd"
}

variable "project" {
  description = "Specify the project name - data-catalog "
}

variable "vpc_id" {
  description = "ID of the VPC"
}

variable "node_app_ecr_uri" {
  description = "ECR Repository URI"
}

variable "node_app_image_tag" {
  description = "Docker image tag in ECR"
}

# variable "node_app_min_capacity" {
#   description = "Minimum number of containers to run"
# }

# variable "node_app_max_capacity" {
#   description = "Maximum number of containers to run"
# }

variable "ecs_cluster_name" {
  description = "The name of the Amazon ECS cluster."
  default     = "main"
}

variable "security_groups" {
  type        = "list"
  description = "ID of public security group"
}

variable "subnets" {
  type        = "list"
  description = "ID of private security group"
}
