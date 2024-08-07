resource "aws_cloudwatch_metric_alarm" "scale_in_alarm" {
  alarm_name        = "${var.environment}-${var.service_name}-scale-in-alarm"
  alarm_description = "Triggers scale out when cpu utilization is above the given threshold"


  # When both CPU Utilization and Memory Utilization are below a certiain threshold
  metric_query {
    id          = "should_scale_down"
    expression  = "IF(cpu <= ${var.scale_in.cpu_utilization} AND mem <= ${var.scale_in.memory_utilization}, 0, 1)"
    return_data = true
  }

  metric_query {
    id          = "cpu"
    return_data = false

    metric {
      # For the the given ECS service
      namespace = "AWS/ECS"
      dimensions = {
        ClusterName = var.ecs_cluster.name
        ServiceName = var.ecs_service.name
      }

      # Evaluate the average CPU Utilization for the 
      stat        = "Average"
      metric_name = "CPUUtilization"

      # last number of seconds
      period = var.scale_in.period
    }
  }

  metric_query {
    id          = "mem"
    return_data = false

    metric {
      # For the the given ECS service
      namespace = "AWS/ECS"
      dimensions = {
        ClusterName = var.ecs_cluster.name
        ServiceName = var.ecs_service.name
      }

      # Evaluate the average Memory Utilization for the 
      stat        = "Average"
      metric_name = "MemoryUtilization"

      # last number of seconds
      period = var.scale_in.period
    }
  }

  evaluation_periods = 1

  # When our metric criteria is a match, 
  # ie. cpu utilization and memory utilization are both below their given thresholds respectively 
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = 0

  # Then trigger the action to scale in
  alarm_actions = [aws_appautoscaling_policy.scale_in.arn]
}

resource "aws_appautoscaling_policy" "scale_in" {
  name = "${var.environment}-${var.service_name}-scale-in-policy"

  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.target.resource_id
  scalable_dimension = aws_appautoscaling_target.target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = var.scale_out.cooldown
    metric_aggregation_type = "Average"

    step_adjustment {
      # decrease ecs count by 1
      metric_interval_lower_bound = 0
      scaling_adjustment          = -1
    }
  }
}