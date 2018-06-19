resource "aws_security_group" "private" {
  vpc_id = "${var.vpc_id}"
  name = "private"
  description = "Allow internal traffic"

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.pre_tag}-Private"
    Environment = "${var.tag_environment}"
  }
}

resource "aws_security_group" "ssh" {
  vpc_id = "${var.vpc_id}"
  name = "ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.ssh_allowed_ip}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.pre_tag}-SSH"
    Environment = "${var.tag_environment}"
  }
}

resource "aws_security_group" "public" {
  vpc_id = "${var.vpc_id}"
  name = "${var.pre_tag}-Public"
  description = "Allow inbound HTTPS traffic"

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.pre_tag}-Public"
    Environment = "${var.tag_environment}"
  }
}
