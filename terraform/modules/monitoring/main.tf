locals {
  all_instance_ids = concat(
    [var.admin_instance_id],
    var.app_instance_ids
  )
}

resource "aws_cloudwatch_metric_alarm" "app_cpu_high" {
  count = length(var.app_instance_ids)

  alarm_name          = "${var.project_name}-${var.environment}-app-${count.index + 1}-cpu-high"
  alarm_description   = "Application server CPU utilization is high"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  evaluation_periods = 2
  threshold          = 80

  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"

  period    = 300
  statistic = "Average"

  treat_missing_data = "notBreaching"

  dimensions = {
    InstanceId = var.app_instance_ids[count.index]
  }
}

resource "aws_cloudwatch_metric_alarm" "instance_status_failed" {
  count = length(local.all_instance_ids)

  alarm_name          = "${var.project_name}-${var.environment}-instance-${count.index + 1}-status-failed"
  alarm_description   = "EC2 instance status check failed"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  evaluation_periods = 2
  threshold          = 1

  namespace   = "AWS/EC2"
  metric_name = "StatusCheckFailed"

  period    = 60
  statistic = "Maximum"

  treat_missing_data = "notBreaching"

  dimensions = {
    InstanceId = local.all_instance_ids[count.index]
  }
}

resource "aws_cloudwatch_metric_alarm" "unhealthy_targets" {
  alarm_name          = "${var.project_name}-${var.environment}-unhealthy-targets"
  alarm_description   = "One or more ALB application targets are unhealthy"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  evaluation_periods = 2
  threshold          = 1

  namespace   = "AWS/ApplicationELB"
  metric_name = "UnHealthyHostCount"

  period    = 60
  statistic = "Maximum"

  treat_missing_data = "notBreaching"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
    TargetGroup  = var.target_group_arn_suffix
  }
}

resource "aws_cloudwatch_dashboard" "project" {
  dashboard_name = "${var.project_name}-${var.environment}-infrastructure"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          title  = "Application EC2 CPU Utilization"
          view   = "timeSeries"
          region = var.aws_region
          stat   = "Average"
          period = 300

          metrics = [
            for instance_id in var.app_instance_ids :
            [
              "AWS/EC2",
              "CPUUtilization",
              "InstanceId",
              instance_id
            ]
          ]
        }
      },

      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          title  = "EC2 Status Checks"
          view   = "timeSeries"
          region = var.aws_region
          stat   = "Maximum"
          period = 60

          metrics = [
            for instance_id in local.all_instance_ids :
            [
              "AWS/EC2",
              "StatusCheckFailed",
              "InstanceId",
              instance_id
            ]
          ]
        }
      },

      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          title  = "Application Load Balancer Traffic"
          view   = "timeSeries"
          region = var.aws_region

          metrics = [
            [
              "AWS/ApplicationELB",
              "RequestCount",
              "LoadBalancer",
              var.alb_arn_suffix
            ],
            [
              "AWS/ApplicationELB",
              "TargetResponseTime",
              "LoadBalancer",
              var.alb_arn_suffix
            ]
          ]
        }
      },

      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6

        properties = {
          title  = "Unhealthy Application Targets"
          view   = "timeSeries"
          region = var.aws_region
          stat   = "Maximum"
          period = 60

          metrics = [
            [
              "AWS/ApplicationELB",
              "UnHealthyHostCount",
              "TargetGroup",
              var.target_group_arn_suffix,
              "LoadBalancer",
              var.alb_arn_suffix
            ]
          ]
        }
      }
    ]
  })
}


