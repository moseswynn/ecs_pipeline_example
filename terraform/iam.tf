
data "aws_iam_policy_document" "ecs_tasks_trust_policy" {
    version = "2012-10-17"
    statement {
      effect = "Allow"
      principals {
        type = "Service"
        identifiers = ["ecs-tasks.amazonaws.com"]
      }
      actions = ["sts:AssumeRole"]
    }
}

resource "aws_iam_role" "task_role" {
    name = "ecs-pipeline-task-role"
    assume_role_policy = data.aws_iam_policy_document.ecs_tasks_trust_policy.json
}

resource "aws_iam_role" "execution_role" {
    name = "ecs-pipeline-execution-role"
    assume_role_policy = data.aws_iam_policy_document.ecs_tasks_trust_policy.json
}

# aws iam attach-role-policy --role-name etl-pipeline-execution-role --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy
resource "aws_iam_role_policy_attachment" "execution_role_attachment" {
    role = aws_iam_role.execution_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# resource "aws_iam_service_linked_role" "ecs_linked_role" {
#     aws_service_name = "ecs.amazonaws.com"
# }

# aws iam create-role \
#     --role-name ecsEventsRole \
#     --assume-role-policy-document file://trust-policy-for-eventbridge.json

# aws iam attach-role-policy \
    # --role-name ecsEventsRole \
    # --policy-arn arn:aws:iam::aws:policy/AmazonECS_FullAccess