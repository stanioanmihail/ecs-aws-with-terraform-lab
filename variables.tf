variable "aws_region" {
  type = string
  default = "us-west-2"
}

variable "aws_profile" {
    type = string
    default = "default"
  
}

variable "vpc_name" {
  type = string
}

variable "ecs_cluster_name" {
    type = string
    default = "ims_nginx_ecs_cluster"
}