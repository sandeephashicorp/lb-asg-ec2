module "vpc" {
  source = "./modules/terraform-aws-vpc"

  name = "asg-demo-vpc"
  cidr = "10.0.0.0/20"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway = true

}


module "asg_sg" {
  source = "./modules/terraform-aws-security-group"
  #source = "modules/terraform-aws-modules/security-group/aws"

  name        = "demo-asg-sg"
  #vpc_id      = "vpc-03ee51d6a6ae3b4e0"
  vpc_id      = module.vpc.vpc_id
  #ingress_cidr_blocks      = ["10.10.0.0/16"]
  #ingress_rules            = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_with_cidr_blocks = [
    {
      rule = "all-all"
    },
  ]
}

module "alb" {
  source  = "./modules/terraform-aws-alb"

  name = "demo-alb"

  vpc_id          = module.vpc.vpc_id
  #vpc_id          = "vpc-03ee51d6a6ae3b4e0"
  subnets         = module.vpc.public_subnets
  #subnets         = ["subnet-096cdeb3da1ae1f8a","subnet-0cfbd32dfb9497b18"]
  security_groups = [module.asg_sg.security_group_id]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  target_groups = [
    {
      name             = "demo-alb-tg"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    },
  ]

}

module "asg" {
  source  = "./modules/terraform-aws-autoscaling"

  # Autoscaling group
  name = "demo-asg"

  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  health_check_type         = "EC2"
  vpc_zone_identifier       = module.vpc.private_subnets
  associate_public_ip_address = false
  key_name = "demokeypair"
  use_lc    = true
  create_lc = true

  # Launch configuration
  lc_name                = "demo-asg-lc"

  target_group_arns = module.alb.target_group_arns

  image_id          = "ami-0747bdcabd34c712a"
  instance_type     = "t2.micro"
  ebs_optimized     = false
  enable_monitoring = false
  #security_groups   = ["sg-002d9c55d08b41850"]
  security_groups   = [module.asg_sg.security_group_id]
  #owners = ["099720109477"]

  user_data = file("install_nginx.sh")
}



