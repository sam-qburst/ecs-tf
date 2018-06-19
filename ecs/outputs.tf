## Add the required outputs 
/*
ecs_cluster_name
*/
output "ecs_cluster_name" {
    value = "${aws_ecs_cluster.main.id}"
}