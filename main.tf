resource "aws_ecs_service" "this" {
  name                               = "${var.environment}-${var.name}-service"
  task_definition                    = var.task_definition == null ? aws_ecs_task_definition.this[0].arn : var.task_definition
  desired_count                      = var.desired_count
  launch_type                        = var.capacity_provider_strategy == [] ? var.launch_type : null
  platform_version                   = var.platform_version
  scheduling_strategy                = var.scheduling_strategy
  cluster                            = var.cluster
  iam_role                           = var.iam_role
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  enable_ecs_managed_tags            = var.enable_ecs_managed_tags
  propagate_tags                     = var.propagate_tags
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  # tags                               = merge({ "Name" = "${var.environment}-${var.name}-service" } , var.tags)

  dynamic "capacity_provider_strategy" {
    for_each = var.capacity_provider_strategy
    content {
      capacity_provider = lookup(capacity_provider_strategy.value, "capacity_provider", null)
      weight            = lookup(capacity_provider_strategy.value, "weight", null)
      base              = lookup(capacity_provider_strategy.value, "base", null)
    }
  }

  dynamic "deployment_controller" {
    for_each = var.deployment_controller
    content {
      type = lookup(deployment_controller.value, "type", null)
    }
  }

  dynamic "load_balancer" {
    for_each = var.load_balancer
    content {
      elb_name         = lookup(load_balancer.value, "elb_name", null)
      target_group_arn = lookup(load_balancer.value, "target_group_arn", null)
      container_name   = load_balancer.value["container_name"]
      container_port   = load_balancer.value["container_port"]
    }
  }

  dynamic "ordered_placement_strategy" {
    for_each = var.ordered_placement_strategy
    content {
      type  = ordered_placement_strategy.value["type"]
      field = lookup(ordered_placement_strategy.value, "field", null)
    }
  }

  dynamic "placement_constraints" {
    for_each = var.placement_constraints
    content {
      type       = placement_constraints.value["type"]
      expression = lookup(placement_constraints.value, "expression", null)
    }
  }

  dynamic "network_configuration" {
    for_each = var.network_configuration
    content {
      subnets          = network_configuration.value["subnets"]
      security_groups  = lookup(network_configuration.value, "subnets", null)
      assign_public_ip = lookup(network_configuration.value, "assign_public_ip", null)
    }
  }

  dynamic "service_registries" {
    for_each = var.service_registries
    content {
      registry_arn   = service_registries.value["registry_arn"]
      port           = lookup(service_registries.value, "port", null)
      container_port = lookup(service_registries.value, "container_port", null)
      container_name = lookup(service_registries.value, "container_name", null)
    }
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}

resource "aws_appautoscaling_target" "this" {
  count = var.enable_app_autoscaling ? 1 : 0
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${var.environment}-cluster/${aws_ecs_service.this.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  count = var.enable_app_autoscaling ? 1 : 0
  name               = "${var.environment}-scaling-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this[0].resource_id
  scalable_dimension = aws_appautoscaling_target.this[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.this[0].service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = var.target_value

    predefined_metric_specification {
      predefined_metric_type = var.predefined_metric_type
    }
  }
}
