
resource "aws_cloudwatch_log_group" "wp-cloudwatch-log-group" {
  name              = "/aws/ecs/${var.cluster_name}"
  retention_in_days = 3
}
