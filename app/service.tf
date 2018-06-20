data "aws_iam_role" "ecs_service_role" {
  name = "AWSServiceRoleForECS"
}

resource "aws_ecs_service" "node_app" {
  name            = "node_app_${var.pre_tag}"
  cluster         = "${var.ecs_cluster_name}"
  task_definition = "${aws_ecs_task_definition.node_app.arn}"
  desired_count   = 1
  iam_role        = "${data.aws_iam_role.ecs_service_role.arn}"

  load_balancer {
    target_group_arn = "${aws_lb_target_group.default_5000_tg.arn}"
    container_name   = "node_app"
    container_port   = "3000"
  }

  depends_on = ["aws_lb_listener.default_3000_lstnr"]
}

resource "aws_lb_listener" "default_3000_lstnr" {
  load_balancer_arn = "${aws_alb.node_app_alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.default_5000_tg.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "default_5000_tg" {
  name     = "${var.pre_tag}-${var.env_tag}-node-app-3000"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  health_check {
    interval            = 30
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 3
    timeout             = 5
    protocol            = "HTTP"
    matcher             = "200"
  }
}

resource "aws_cloudwatch_log_group" "node_app" {
  name = "${var.env_tag}-${var.project}-node_app-${var.pre_tag}"
}
