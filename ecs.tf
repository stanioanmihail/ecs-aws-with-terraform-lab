
# once the EC2 setup is completed, create an ECS cluster
resource "aws_ecs_cluster" "demo-ecs-cluster" {
    name = var.ecs_cluster_name
}

# generate a container definition to be spin-up inside the EC2 nodes 
resource "aws_ecs_task_definition" "task_definition" {
  container_definitions = file("tasks/task_definition.json")
  family = "webservice"
}

# spin-up 2 nginx containers
resource "aws_ecs_service" "nginx_deployment" {
    name = "brl_nginx_deployment"
    cluster = aws_ecs_cluster.demo-ecs-cluster.id
    task_definition = aws_ecs_task_definition.task_definition.arn
    desired_count = 2
}