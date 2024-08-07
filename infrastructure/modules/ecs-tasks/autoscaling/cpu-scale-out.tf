resource "aws_cloudwatch_metric_alarm" "cpu_scale_out_alarm" {
  alarm_name        = "${var.environment}-${var.service_name}-cpu-scale-out-alarm"
  alarm_description = "Triggers scale out when cpu utilization is above the given threshold"

  # For the the given ECS service
  namespace = "AWS/ECS"
  dimensions = {
    ClusterName = var.ecs_cluster.name
    ServiceName = var.ecs_service.name
  }

  # When average the Memory Utilitization
  statistic   = "Average"
  metric_name = "CPUUtilization"

  # the the last number of seconds
  period             = var.scale_out.period
  evaluation_periods = 1

  # is greater than or equal to the provided threshold
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = var.scale_out.cpu_utilization

  # Then trigger the alarm
  alarm_actions = [aws_appautoscaling_policy.scale_out.arn]
}