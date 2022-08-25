data "aws_availability_zones" "available" {}

module "vpc" {
    source  = "terraform-aws-modules/vpc/aws"
    version = "3.14.2"

    name    = "${var.project}-vpc"
    cidr    = var.vpc_cidr
    azs     = data.aws_availability_zones.available.names

    private_subnets  = var.private_subnets
    public_subnets   = var.public_subnets
    database_subnets = var.database_subnets


    create_database_subnet_group = true
    enable_nat_gateway           = true
    single_nat_gateway           = true
}

#----------------- Tạo Security Group cho VPC ------------------------------------
#Cho phép truy cập port 80 của ALB từ mọi nơi.
module "alb_sg" {
  source = "terraform-in-action/sg/aws"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      port        = 80
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

#Cho phép truy cập port 80 của các EC2 từ ALB.
module "web_sg" {
  source = "terraform-in-action/sg/aws"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      port        = 80
      security_groups = [module.alb_sg.security_group.id]
    }
  ]
}

#Cho phép truy cập port 5432 của RDS từ EC2.
module "db_sg" {
  source = "terraform-in-action/sg/aws"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      port            = 5432
      security_groups = [module.web_sg.security_group.id]
    }
  ]
}