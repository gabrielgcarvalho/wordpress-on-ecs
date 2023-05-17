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

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvent"
        ],
        Resource = "*"
      }
    ]
  })

}
