module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  
  name = var.vpc_name
  cidr = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

}

data "aws_vpc" "main_vpc" {
  id = module.vpc.vpc_id
  
}