resource "aws_alb" "node_app_alb" {
  name               = "${var.pre_tag}nodeapp-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${var.security_groups}"]
  subnets            = ["${var.subnets}"]

  tags {
    Environment = "${var.env_tag}"
  }
}
