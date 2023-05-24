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
          "name"  = "ServerName",
          "value" = "localhost"
        }
      ]
    }]
  )
}

resource "aws_ecs_service" "wp-ecs-service" {
  name                               = "wp-ecs-service"
  cluster                            = aws_ecs_cluster.ecs-cluster.id
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  task_definition                    = aws_ecs_task_definition.wp-task-definition.id
  desired_count                      = 1
  health_check_grace_period_seconds  = 60

  network_configuration {
    subnets = [
      aws_subnet.private_subnet1.id,
      aws_subnet.private_subnet2.id
    ]

    assign_public_ip = true
    security_groups  = [aws_security_group.wp-ecs-task-security-group.id]
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.wp-alb-target-group.arn
    container_name   = var.container_name
    container_port   = 80
  }


  depends_on = [
    aws_iam_role.wp-ecs-service-role,
    aws_ecs_task_definition.wp-task-definition,
    aws_db_instance.wp-db
  ]
}
