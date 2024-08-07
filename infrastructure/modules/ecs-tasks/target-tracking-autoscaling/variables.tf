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

variable "scale_out" {
  description = "Parameters for scaling out"

  type = object({
    cpu_utilization    = number
    memory_utilization = number
    cooldown           = number
    period             = number
  })

}

variable "scale_in" {
  description = "Parameters for scaling int"

  type = object({
    cooldown = number
  })
}