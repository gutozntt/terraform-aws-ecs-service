resource "aws_ecs_task_definition" "this" {
  count                 = var.task_definition == null ? 1 : 0
  family                = "${var.environment}-${var.name}-task-definition"
  container_definitions = var.enable_firelens ? "[${local.container_json_map},${local.firelens_container_json_map}]" : "[${local.container_json_map}]"
  execution_role_arn    = var.execution_role_arn
  tags                  = merge({ "Name" = "${var.environment}-${var.name}-task-definition" }, var.tags)
}
