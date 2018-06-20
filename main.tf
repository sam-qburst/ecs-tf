provider "aws" {
  region = "${var.region}"
}

# terraform {
#   backend "s3" {
#     encrypt = true
#   }
# }

# Module network contains VPC, Subnets, Gatways and Route Tables.
module "network" {
  source               = "./network"
  region               = "${var.region}"
  vpc_cidr             = "${var.vpc_cidr}"
  pre_tag              = "${var.pre_tag}"
  tag_environment      = "${var.tag_environment}"
  public_subnet_count  = "${var.public_subnet_count}"
  private_subnet_count = "${var.private_subnet_count}"
  public_subnet_cidr   = "${var.public_subnet_cidr}"
  private_subnet_cidr  = "${var.private_subnet_cidr}"
}

module "security-groups" {
  source          = "./security"
  vpc_id          = "${module.network.vpc_id}"
  vpc_cidr        = "${var.vpc_cidr}"
  pre_tag         = "${var.pre_tag}"
  tag_environment = "${var.tag_environment}"
  ssh_allowed_ip  = "${var.ssh_allowed_ip}"
}

module "bastion" {
  source                 = "./bastion"
  pre_tag                = "${var.pre_tag}"
  env_tag                = "${var.tag_environment}"
  bastion_key_pair_name  = "${var.bastion_key_pair_name}"
  aws_subnet_id          = "${module.network.public_subnet_ids[0]}"
  aws_security_group_ids = ["${module.security-groups.private_sg_id}", "${module.security-groups.ssh_sg_id}", "${module.security-groups.public_sg_id}"]
}

module "ecs" {
  source                 = "./ecs"
  pre_tag                = "${var.pre_tag}"
  region                 = "${var.region}"
  autoscale_desired      = "${var.ecs_instance_count}"
  ecs_key_pair_name      = "${var.ecs_key_pair_name}"
  ecs_cluster_name       = "${var.ecs_cluster_name}"
  aws_private_subnet_ids = ["${module.network.private_subnet_ids}"]
  aws_security_group_ids = ["${module.security-groups.private_sg_id}"]
}

module "app" {
  source             = "./app"
  pre_tag            = "${var.pre_tag}"
  env_tag            = "${var.pre_tag}"
  region             = "${var.region}"
  project            = "${var.project}"
  vpc_id             = "${module.network.vpc_id}"
  node_app_ecr_uri   = "${var.node_app_ecr_uri}"
  node_app_image_tag = "${var.node_app_image_tag}"

  # node_app_min_capacity = "${var.node_app_min_capacity}"
  # node_app_max_capacity = "${var.node_app_max_capacity}"
  ecs_cluster_name = "${module.ecs.ecs_cluster_name}"

  security_groups = ["${module.security-groups.public_sg_id}"]
  subnets         = ["${module.network.public_subnet_ids}"]
}
