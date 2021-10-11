
# create assume policy for autoscaling group to work in ECS context
data "aws_iam_policy_document" "demo_ecs_brl" {
  statement {
    actions = [ "sts:AssumeRole" ]
    sid = ""
    effect = "Allow"
    principals {
      identifiers = [ "ec2.amazonaws.com" ]
      type = "service"
    }
  }
}

# create an associated role for the Autoscaling Group
resource "aws_iam_role" "demo_ecs_brl" {
  assume_role_policy = data.aws_iam_policy_document.demo_ecs_brl.json
  name = "brl_demo_ecs"
}

# apply the appropriate access policy to the Autoscaling Group dedicated role
resource "aws_iam_role_policy_attachment" "demo_ecs_brl" {
  role = aws_iam_role.demo_ecs_brl.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

# apply the role binding
resource "aws_iam_instance_profile" "demo_ecs_brl" {
  role = aws_iam_role.demo_ecs_brl.name
  name = "demo_nginx"
}

# since the ECS deployment will rely on EC2, find an VM image optimized for the ECS
data "aws_ami" "ecs_optimized_image_linux" {

  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-*"]
  }

  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

# create a launch definition for EC2 to be used by autoscaling group
resource "aws_launch_configuration" "demo_ecs_brl" {
  name = "demo_nginx"
  image_id = data.aws_ami.ecs_optimized_image_linux.id
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.demo_ecs_brl.name

  user_data = <<EOF
#!/bin/bash

sudo echo "ECS_CLUSTER=${var.ecs_cluster_name}" >> /etc/ecs/ecs.config
EOF

}

# create the autoscaling group and hardcode the number of instances to be always on: 2
resource "aws_autoscaling_group" "demo_ecs_brl" {
  name = "demo_nginx_asg"
  launch_configuration = aws_launch_configuration.demo_ecs_brl.name
  min_size = 2
  max_size = 2
  desired_capacity = 2
  health_check_type = "EC2"

}

