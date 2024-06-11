variable "image_url" {
  type = string
}

variable "cpu" {
  type = number
  default = 512
}

variable "memory" {
  type = number
  default = 1024
}

variable "name" {
  type = string
}

variable "log_group" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "ecs_cluster_id" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "subnets" {
  
}

resource "aws_ecs_task_definition" "streaming_task" {
family = "ecs-streaming-task"
task_role_arn = var.task_role_arn
execution_role_arn = var.execution_role_arn
network_mode = "awsvpc"
container_definitions = <<TASK_DEFINITION
[
  {
    "name": "ecs-pipelines-${var.name}",
    "image": "${var.image_url}",
    "cpu": ${var.cpu},
    "memory": ${var.memory},
    "essential": true,
    "command": ["python","run.py","--stream","-n","${var.name}"],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${var.log_group}",
        "awslogs-region": "${var.aws_region}",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
TASK_DEFINITION
  requires_compatibilities = ["FARGATE"]
  cpu = var.cpu
  memory = var.memory
}

resource "aws_ecs_service" "streaming_services" {
  name = "ecs-streaming-service-${var.name}"
  cluster = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.streaming_task.arn
  launch_type = "FARGATE"
  desired_count = 1
  force_new_deployment = true
  network_configuration {
    subnets = var.subnets
    assign_public_ip = true
  }
}