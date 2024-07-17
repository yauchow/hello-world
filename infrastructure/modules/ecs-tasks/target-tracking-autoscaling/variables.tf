variable "service_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "min_capacity" {
  type = number
}

variable "max_capacity" {
  type = number
}

variable "ecs_cluster" {
  description = "The ecs cluster"
  type = object({
    id   = string
    name = string
  })
}

variable "ecs_service" {
  description = "The ecs service to scale"
  type = object({
    id   = string
    name = string
  })
}

variable "cpu_utilization" {
  description = "The average CPU utilization across all task defintions before we scale up or down the number of task definition to managed the current load."
  type        = number
  default     = 80
}

variable "memory_utilization" {
  description = "The average memory utilization across all task definitions before we scale up or down the number of task definition to managed the current load."
  type        = number
  default     = 80
}