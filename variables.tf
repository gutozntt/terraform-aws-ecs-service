variable "name" {
  description = "A name for the service."
}
variable "environment" {
  description = "The environment name. E.g dev, prod, stage"
}
variable "task_definition" {
  default     = null
  description = "The ARN of the task definition if you don't want to create a task definition through this module."
}
variable "desired_count" {
  default     = 0
  description = "The desired running tasks count."
}
variable "launch_type" {
  default     = "EC2"
  description = "Launch type on which to run your service. The valid values are EC2 and FARGATE. Defaults to EC2."
}
variable "platform_version" {
  default     = null
  description = "Platform version on which to run your service. Only applicable for launch_type set to FARGATE. Defaults to LATEST."
}
variable "scheduling_strategy" {
  default     = "REPLICA"
  description = "Scheduling strategy to use for the service. The valid values are REPLICA and DAEMON. Defaults to REPLICA."
}
variable "cluster" {
  default     = null
  description = "ARN of an ECS cluster."
}
variable "iam_role" {
  default     = null
  description = "ARN of the IAM role that allows Amazon ECS to make calls to your load balancer on your behalf. Only if the task definition does not use awsvpc mode."
}
variable "deployment_maximum_percent" {
  default     = null
  description = "Upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment."
}
variable "deployment_minimum_healthy_percent" {
  default     = null
  description = "Lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment."
}
variable "enable_ecs_managed_tags" {
  default     = null
  description = "Specifies whether to enable Amazon ECS managed tags for the tasks within the service."
}
variable "propagate_tags" {
  default     = null
  description = "Specifies whether to propagate the tags from the task definition or the service to the tasks. The valid values are SERVICE and TASK_DEFINITION."
}
variable "health_check_grace_period_seconds" {
  default     = null
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647. Only valid for services configured to use load balancers."
}
variable "tags" {
  type        = map(any)
  description = "Key-value map of resource tags."
}
variable "deployment_controller" {
  default     = []
  type        = list(any)
  description = "Configuration block for deployment controller configuration."
}
variable "load_balancer" {
  default     = []
  type        = list(any)
  description = "Configuration block for load balancers."
}
variable "ordered_placement_strategy" {
  default     = []
  type        = list(any)
  description = "Service level strategy rules that are taken into consideration during task placement. List from top to bottom in order of precedence. Updates to this configuration will take effect next task deployment unless force_new_deployment is enabled."
}
variable "placement_constraints" {
  default     = []
  type        = list(any)
  description = "Rules that are taken into consideration during task placement."
}
variable "network_configuration" {
  default     = []
  type        = list(any)
  description = "Network configuration for the service. This parameter is required for task definitions that use the awsvpc network mode to receive their own Elastic Network Interface, and it is not supported for other network modes."
}
variable "service_registries" {
  default     = []
  type        = list(any)
  description = "Service discovery registries for the service. The maximum number of service_registries blocks is 1."
}

variable "task_role_arn" {
  default     = null
  description = "ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services."
}

variable "cloudwatch_log_group" {
  default     = null
  description = "CloudWatch Log Group to send Firelends logs. Specify if enable_firelens is true."
}

variable "region" {
  default     = "us-east-1"
  description = "AWS Region."
}

variable "enable_firelens" {
  default     = false
  description = "Whether you want to enable firelens sidecar container logging option. It does not work with external task definition."
}

variable "container_name" {
  type        = string
  description = "The name of the container. Up to 255 characters ([a-z], [A-Z], [0-9], -, _ allowed)"
}

variable "container_image" {
  type        = string
  description = "The image used to start the container. Images in the Docker Hub registry available by default"
}

variable "container_memory" {
  type        = number
  description = "The amount of memory (in MiB) to allow the container to use. This is a hard limit, if the container attempts to exceed the container_memory, the container is killed. This field is optional for Fargate launch type and the total amount of container_memory of all containers in a task will need to be lower than the task memory value"
  default     = null
}

variable "container_memory_reservation" {
  type        = number
  description = "The amount of memory (in MiB) to reserve for the container. If container needs to exceed this threshold, it can do so up to the set container_memory hard limit"
  default     = null
}

variable "container_definition" {
  type        = map(any)
  description = "Container definition overrides which allows for extra keys or overriding existing keys."
  default     = {}
}

variable "port_mappings" {
  type = list(object({
    containerPort = number
    hostPort      = number
    protocol      = string
  }))

  description = "The port mappings to configure for the container. This is a list of maps. Each map should contain \"containerPort\", \"hostPort\", and \"protocol\", where \"protocol\" is one of \"tcp\" or \"udp\". If using containers in a task with the awsvpc or host network mode, the hostPort can either be left blank or set to the same value as the containerPort"

  default = []
}

# https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_HealthCheck.html
variable "healthcheck" {
  type = object({
    command     = list(string)
    retries     = number
    timeout     = number
    interval    = number
    startPeriod = number
  })
  description = "A map containing command (string), timeout, interval (duration in seconds), retries (1-10, number of times to retry before marking container unhealthy), and startPeriod (0-300, optional grace period to wait, in seconds, before failed healthchecks count toward retries)"
  default     = null
}

variable "container_cpu" {
  type        = number
  description = "The number of cpu units to reserve for the container. This is optional for tasks using Fargate launch type and the total amount of container_cpu of all containers in a task will need to be lower than the task-level cpu value"
  default     = 0
}

variable "essential" {
  type        = bool
  description = "Determines whether all other containers in a task are stopped, if this container fails or stops for any reason. Due to how Terraform type casts booleans in json it is required to double quote this value"
  default     = true
}

variable "entrypoint" {
  type        = list(string)
  description = "The entry point that is passed to the container"
  default     = null
}

variable "command" {
  type        = list(string)
  description = "The command that is passed to the container"
  default     = null
}

variable "working_directory" {
  type        = string
  description = "The working directory to run commands inside the container"
  default     = null
}

variable "environment_vars" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "The environment variables to pass to the container. This is a list of maps. map_environment overrides environment"
  default     = []
}

variable "extra_hosts" {
  type = list(object({
    ipAddress = string
    hostname  = string
  }))
  description = "A list of hostnames and IP address mappings to append to the /etc/hosts file on the container. This is a list of maps"
  default     = null
}

variable "map_environment" {
  type        = map(string)
  description = "The environment variables to pass to the container. This is a map of string: {key: value}. map_environment overrides environment"
  default     = null
}

variable "map_secrets" {
  type        = map(string)
  description = "The environment variables to pass to the container. This is a map of string: {key: value}. map_secrets overrides secrets"
  default     = null
}

# https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_EnvironmentFile.html
variable "environment_files" {
  type = list(object({
    value = string
    type  = string
  }))
  description = "One or more files containing the environment variables to pass to the container. This maps to the --env-file option to docker run. The file must be hosted in Amazon S3. This option is only available to tasks using the EC2 launch type. This is a list of maps"
  default     = null
}

variable "secrets" {
  type = list(object({
    name      = string
    valueFrom = string
  }))
  description = "The secrets to pass to the container. This is a list of maps"
  default     = []
}

variable "readonly_root_filesystem" {
  type        = bool
  description = "Determines whether a container is given read-only access to its root filesystem. Due to how Terraform type casts booleans in json it is required to double quote this value"
  default     = false
}

# https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_LinuxParameters.html
variable "linux_parameters" {
  type = object({
    capabilities = object({
      add  = list(string)
      drop = list(string)
    })
    devices = list(object({
      containerPath = string
      hostPath      = string
      permissions   = list(string)
    }))
    initProcessEnabled = bool
    maxSwap            = number
    sharedMemorySize   = number
    swappiness         = number
    tmpfs = list(object({
      containerPath = string
      mountOptions  = list(string)
      size          = number
    }))
  })
  description = "Linux-specific modifications that are applied to the container, such as Linux kernel capabilities. For more details, see https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_LinuxParameters.html"
  default     = null
}

# https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_LogConfiguration.html
variable "log_configuration" {
  type        = any
  description = "Log configuration options to send to a custom log driver for the container. For more details, see https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_LogConfiguration.html"
  default     = null
}

# https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_FirelensConfiguration.html
variable "firelens_configuration" {
  type = object({
    type    = string
    options = map(string)
  })
  description = "The FireLens configuration for the container. This is used to specify and configure a log router for container logs. For more details, see https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_FirelensConfiguration.html"
  default     = null
}

variable "mount_points" {
  type = list(any)

  description = "Container mount points. This is a list of maps, where each map should contain a `containerPath` and `sourceVolume`. The `readOnly` key is optional."
  default     = []
}

variable "dns_servers" {
  type        = list(string)
  description = "Container DNS servers. This is a list of strings specifying the IP addresses of the DNS servers"
  default     = null
}

variable "dns_search_domains" {
  type        = list(string)
  description = "Container DNS search domains. A list of DNS search domains that are presented to the container"
  default     = null
}

variable "ulimits" {
  type = list(object({
    name      = string
    hardLimit = number
    softLimit = number
  }))
  description = "Container ulimit settings. This is a list of maps, where each map should contain \"name\", \"hardLimit\" and \"softLimit\""
  default     = null
}

variable "repository_credentials" {
  type        = map(string)
  description = "Container repository credentials; required when using a private repo.  This map currently supports a single key; \"credentialsParameter\", which should be the ARN of a Secrets Manager's secret holding the credentials"
  default     = null
}

variable "volumes_from" {
  type = list(object({
    sourceContainer = string
    readOnly        = bool
  }))
  description = "A list of VolumesFrom maps which contain \"sourceContainer\" (name of the container that has the volumes to mount) and \"readOnly\" (whether the container can write to the volume)"
  default     = []
}

variable "links" {
  type        = list(string)
  description = "List of container names this container can communicate with without port mappings"
  default     = null
}

variable "user" {
  type        = string
  description = "The user to run as inside the container. Can be any of these formats: user, user:group, uid, uid:gid, user:gid, uid:group. The default (null) will use the container's configured `USER` directive or root if not set."
  default     = null
}

variable "container_depends_on" {
  type = list(object({
    containerName = string
    condition     = string
  }))
  description = "The dependencies defined for container startup and shutdown. A container can contain multiple dependencies. When a dependency is defined for container startup, for container shutdown it is reversed. The condition can be one of START, COMPLETE, SUCCESS or HEALTHY"
  default     = null
}

variable "docker_labels" {
  type        = map(string)
  description = "The configuration options to send to the `docker_labels`"
  default     = null
}

variable "start_timeout" {
  type        = number
  description = "Time duration (in seconds) to wait before giving up on resolving dependencies for a container"
  default     = null
}

variable "stop_timeout" {
  type        = number
  description = "Time duration (in seconds) to wait before the container is forcefully killed if it doesn't exit normally on its own"
  default     = null
}

variable "privileged" {
  type        = bool
  description = "When this variable is `true`, the container is given elevated privileges on the host container instance (similar to the root user). This parameter is not supported for Windows containers or tasks using the Fargate launch type."
  default     = null
}

variable "system_controls" {
  type        = list(map(string))
  description = "A list of namespaced kernel parameters to set in the container, mapping to the --sysctl option to docker run. This is a list of maps: { namespace = \"\", value = \"\"}"
  default     = null
}

variable "execution_role_arn" {
  default     = null
  description = "ARN of the task execution role that the Amazon ECS container agent and the Docker daemon can assume."
}

variable "capacity_provider_strategy" {
  type        = list(any)
  default     = []
  description = "Capacity provider strategy to use for the service. Can be one or more."
}

variable "enable_app_autoscaling" {
  default     = false
  description = "Whether you want to enable application autoscaling."
}
variable "max_capacity" {
  default     = null
  description = "The max capacity of the scalable target (app autoscaling)."
}
variable "min_capacity" {
  default     = null
  description = "The min capacity of the scalable target (app autoscaling)."
}
variable "target_value" {
  default     = null
  description = "The target value for the metric (app autoscaling)."
}
variable "predefined_metric_type" {
  default     = null
  description = "A predefined metric (app autoscaling)."
}
