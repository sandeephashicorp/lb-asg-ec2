variable "image_path" {
  description = "image path"
  type        = string
  default = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
}

variable "virtualization_type" {
  description = "ID of subnet to house NGINX instance."
  type        = string
  default = "hvm"
}

variable "ami_id" {
  description = "image id."
  type        = string
  default     = "ami-0747bdcabd34c712a"
}

variable "ownerid" {
  description = "image owner id."
  type        = string
  default     = ["099720109477"]
}

variable "name_prefix" {
    description = "image name prefix"
  type    = string
  default = "terraform-lc-demo-"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Size of NGINX's EC2 instance."
}

variable "security_group" {
  description = "vpc security group."
  type        = string
  default     = []
}

variable "asg_name" {
  description = "image name prefix"
  type    = string
  default = "terraform-asg-demo"
}

variable "min_size" {
  description = "Minimum number of Nginx instances in autoscaling group."
  default     = 1
  type        = number
}

variable "max_size" {
  description = "Maximum number of Nginx instances in autoscaling group."
  default     = 5
  type        = number
}