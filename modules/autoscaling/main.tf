
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = var.image_path
  }

  filter {
    name   = "virtualization-type"
    values = var.virtualization_type
  }

  id = "ami-0747bdcabd34c712a"

  owners = var.ownerid # Canonical
}

resource "aws_launch_configuration" "as_conf" {

  name_prefix   = var.name_prefix
  instance_type = var.instance_type
  image_id      = data.aws_ami.ubuntu.id
  security_groups = var.security_group

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name                 = var.asg_name
  launch_configuration = aws_launch_configuration.as_conf.name_prefix
  min_size             = var.min_size
  max_size             = var.max_size

  lifecycle {
    create_before_destroy = true
  }
}