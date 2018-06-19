output "private_sg_id" {
    value = "${aws_security_group.private.id}"
}

output "ssh_sg_id" {
    value = "${aws_security_group.ssh.id}"
}

output "public_sg_id" {
    value = "${aws_security_group.public.id}"
}