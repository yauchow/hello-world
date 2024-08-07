resource "aws_appautoscaling_policy" "scale_out" {
  name = "${var.environment}-${var.service_name}-scale-out-policy"

  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.target.resource_id
  scalable_dimension = aws_appautoscaling_target.target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = var.scale_out.cooldown
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      # increment ECS count by 1
      scaling_adjustment = 1
    }
  }
}