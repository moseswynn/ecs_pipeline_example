terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = "us-west-2"
}

# container image repository
resource "aws_ecr_repository" "image_repository" {
    name = "ecs-pipelines"
}

output "ecr_repo_url" {
    value = aws_ecr_repository.image_repository.repository_url
    description = "The URL for the ECR repository."
}

# cloudwatch log group
resource "aws_cloudwatch_log_group" "ecs_pipeline_logs" {
    name = "ecs/pipeline-logs"
}


resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs-pipelines-cluster"
}

# Tasks and Services for Streaming Pipelines

module "streams" {
  source = "./streams"
  for_each = local.streams
  image_url = var.image_url
  cpu = each.value.cpu
  memory = each.value.memory
  name = each.value.name
  log_group = aws_cloudwatch_log_group.ecs_pipeline_logs.name
  aws_region = var.aws_region
  ecs_cluster_id = aws_ecs_cluster.ecs_cluster.id
  task_role_arn = aws_iam_role.task_role.arn
  execution_role_arn = aws_iam_role.execution_role.arn
  subnets = aws_subnet.public.*.id
}


# TODO: Tasks and EventBridge Schedules for batch pipelines.

# resource "aws_ecs_task_definition" "pipeline_tasks" {
# for_each = local.pipelines
# family = "ecs-streaming-task-${each.key}"
#   task_role_arn = aws_iam_role.task_role.arn
#   execution_role_arn = aws_iam_role.execution_role.arn
#   network_mode = "awsvpc"
#   container_definitions = <<TASK_DEFINITION
# [
#   {
#     "name": "ecs-pipelines-${each.value.name}",
#     "image": "${var.image_url}",
#     "cpu": ${each.value.cpu},
#     "memory": ${each.value.memory},
#     "essential": true,
#     "command": ["python","run.py","-n","${each.key}"]
#     "logConfiguration": {
#       "logDriver": "awslogs",
#       "options": {
#         "awslogs-group": ${aws_cloudwatch_log_group.ecs_pipeline_logs},
#         "awslogs-region": ${var.aws_region},
#         "awslogs-stream-prefix": "ecs"
#       }
#     }
#   }
# ]
# TASK_DEFINITION
#   requires_compatibilities = ["FARGATE"]
#   cpu = each.value.cpu
#   memory = each.value.memory
# }