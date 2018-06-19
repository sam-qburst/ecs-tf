resource "aws_instance" "bastion_host" {
  ami = "${lookup(var.bastion_ami, var.region)}"
  instance_type = "t2.micro"
  key_name = "${var.bastion_key_pair_name}"
  vpc_security_group_ids = ["${var.aws_security_group_ids}"]
  subnet_id = "${var.aws_subnet_id}"
  source_dest_check = false
  associate_public_ip_address = true
  tags {
    Name = "${var.pre_tag}-bastion"
    Environment = "${var.env_tag}"
  }
  root_block_device {
    volume_size = "20"
    delete_on_termination = true
  }
}