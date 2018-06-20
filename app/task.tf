data "template_file" "task_node_app" {
  template = "${file("${path.module}/task-definition/task.json")}"

  vars {
    region    = "${var.region}"
    pre_tag   = "${var.pre_tag}"
    env_tag   = "${var.pre_tag}"
    project   = "${var.project}"
    ecr_uri   = "${var.node_app_ecr_uri}"
    image_tag = "${var.node_app_image_tag}"
  }
}

resource "aws_ecs_task_definition" "node_app" {
  family                = "${var.env_tag}-${var.project}-node_app-${var.pre_tag}"
  container_definitions = "${data.template_file.task_node_app.rendered}"
}
