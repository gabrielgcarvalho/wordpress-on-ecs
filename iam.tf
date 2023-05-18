resource "aws_iam_role" "wp-ecs-service-role" {
  name = "wp-ecs-service-role"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Principal = {
            Service = "ecs.amazonaws.com"
          },
          Action = "sts:AssumeRole"
        },
      ]
  })
}

// IAM ECS Policy
resource "aws_iam_role_policy" "wp-ecs-service-policy" {
  name = "wp-ecs-service-policy"
  role = aws_iam_role.wp-ecs-service-role.id

  depends_on = [aws_cloudwatch_log_group.wp-cloudwatch-log-group]

  policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Effect" = "Allow",
          "Action" = [
            "logs:CreateLogStream",
            "logs:PutLogEvent"
          ],
          "Resource" = aws_cloudwatch_log_group.wp-cloudwatch-log-group.arn
        }
      ]
  })

}


resource "aws_iam_role" "wp-ecs-task-execution-role" {
  name = "wp-ecs-task-execution-role"
  assume_role_policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Effect" = "Allow",
          "Principal" = {
            "Service" = "ecs-tasks.amazonaws.com"
          },
          "Action" = "sts:AssumeRole"
        }
      ]
  })
}

resource "aws_iam_role_policy" "wp-ecs-task-execution-policy" {
  name = "wp-ecs-task-execution-policy"
  role = aws_iam_role.wp-ecs-service-role.id

  depends_on = [aws_cloudwatch_log_group.wp-cloudwatch-log-group]

  policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Action" = [
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" = "*",
          "Effect"   = "Allow"
        },
        {
          "Action"   = "ecr:GetAuthorizationToken",
          "Resource" = "*",
          "Effect"   = "Allow"
        }
      ]
  })

}

resource "aws_iam_role" "wp-ecs-task-role" {
  name = "wp-ecs-task-role"
  assume_role_policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Effect" = "Allow",
          "Principal" = {
            "Service" = "ecs-tasks.amazonaws.com"
          },
          "Action" = "sts:AssumeRole"
        }
      ]
  })
}

resource "aws_iam_role_policy" "wp-ecs-task-policy" {
  name = "wp-ecs-task-policy"
  role = aws_iam_role.wp-ecs-service-role.id

  depends_on = [aws_cloudwatch_log_group.wp-cloudwatch-log-group]

  policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Action" : ["s3:GetObject"],
          "Resource" = "*",
          "Effect"   = "Allow"
        }
      ]
  })

}
