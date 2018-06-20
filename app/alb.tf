resource "aws_lb" "node_app_alb" {
  name               = "${var.pre_tag}nodeapp-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = "${var.security_groups}"
  subnets            = "${var.subnets}"

  enable_deletion_protection = true

  access_logs {
    bucket  = "${aws_s3_bucket.lb_logs.bucket}"
    prefix  = "${var.pre_tag}nodeapp-alb"
    enabled = true
  }

  tags {
    Environment = "${var.env_tag}"
  }
}
