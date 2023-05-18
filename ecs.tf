resource "aws_ecs_cluster" "ecs-cluster" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "wp-task-definition" {
  family                   = "wp-task-family"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  network_mode = "awsvpc"

  execution_role_arn = aws_iam_role.wp-ecs-task-execution-role.arn
  task_role_arn      = aws_iam_role.wp-ecs-task-role.arn

  container_definitions = jsonencode(
    [{
      "name"   = "${var.container_name}",
      "image"  = "${var.container_image}",
      "cpu"    = "${var.container_cpu}",
      "memory" = "${var.container_memory}",
      "portMappings" = [
        {
          "containerPort" = "${var.container_port}",
        }
      ],
      "logConfiguration" = {
        "logDriver" = "awslogs",
        "options" = {
          "awslogs-group"         = "/aws/ecs/${var.cluster_name}",
          "awslogs-region"        = "${var.region}"
          "awslogs-stream-prefix" = "${var.stream_prefix}"
        }
      },
      "environment" = [
        {
          "name"  = "VARIABLE",
          "value" = "variable_value"
        },
        {
          "name"  = "ServerName",
          "value" = "localhost"
        }
      ]
    }]
  )
}
