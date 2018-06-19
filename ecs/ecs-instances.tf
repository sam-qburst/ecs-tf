resource "aws_autoscaling_group" "ecs_cluster" {
    name = "${var.pre_tag}-${var.ecs_cluster_name}"
    min_size = "${var.autoscale_min}"
    max_size = "${var.autoscale_max}"
    desired_capacity = "${var.autoscale_desired}"
    health_check_type = "EC2"
    launch_configuration = "${aws_launch_configuration.ecs.name}"
    vpc_zone_identifier = ["${var.aws_private_subnet_ids}"]
    force_delete = true
    tag {
        key = "Name"
        value = "${var.pre_tag}-${var.ecs_cluster_name}"
        propagate_at_launch =true
    }
    tag {
        key = "Environment"
        value = "${var.tag_environment}"
        propagate_at_launch = true
    }
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_launch_configuration" "ecs" {
    name = "${var.pre_tag}-${var.ecs_cluster_name}"
    image_id = "${lookup(var.amis, var.region)}"
    instance_type = "${var.instance_type}"
    security_groups = ["${var.aws_security_group_ids}"]
    iam_instance_profile = "${aws_iam_instance_profile.ecs.name}"
    # TODO: checkout the best practice to add key pair
    key_name = "${var.ecs_key_pair_name}"
    user_data = "#!/bin/bash\necho ECS_CLUSTER='${var.pre_tag}-${var.ecs_cluster_name}' > /etc/ecs/ecs.config"
    root_block_device {
        volume_size = "${var.ecs_agent_disk_size}"
    }
}
#
## Resources for ECS instance autoscaling
#
resource "aws_autoscaling_policy" "ecs_scale_up" {
  name = "${var.pre_tag}-${var.ecs_cluster_name}-instances-scale-up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.ecs_cluster.name}"
}

resource "aws_autoscaling_policy" "ecs_scale_down" {
  name = "${var.pre_tag}-${var.ecs_cluster_name}-instances-scale-down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.ecs_cluster.name}"
}

# A CloudWatch alarm that monitors CPU utilization of cluster instances for scaling up
resource "aws_cloudwatch_metric_alarm" "ecs_cluster_instances_cpu_high" {
  alarm_name = "${var.pre_tag}-${var.ecs_cluster_name}-instances-CPU-Above-50"
  alarm_description = "This alarm monitors ${var.pre_tag}-${var.ecs_cluster_name} instances CPU utilization for scaling up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "300"
  statistic = "Average"
  threshold = "50"
  alarm_actions = ["${aws_autoscaling_policy.ecs_scale_up.arn}"]

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.ecs_cluster.name}"
  }
}

# A CloudWatch alarm that monitors CPU utilization of cluster instances for scaling down
resource "aws_cloudwatch_metric_alarm" "ecs_cluster_instances_cpu_low" {
  alarm_name = "${var.pre_tag}-${var.ecs_cluster_name}-instances-CPU-Below-5"
  alarm_description = "This alarm monitors ${var.pre_tag}-${var.ecs_cluster_name} instances CPU utilization for scaling down"
  comparison_operator = "LessThanThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "300"
  statistic = "Average"
  threshold = "5"
  alarm_actions = ["${aws_autoscaling_policy.ecs_scale_down.arn}"]

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.ecs_cluster.name}"
  }
}
