variable "environment" {
  description = "The environment name, used to help name and tag resources created"
  type        = string
}

variable "service_name" {
  description = "The name of an ecs service"
  type        = string
}

variable "config" {
  description = "The config"
}

variable "vpc" {
  description = "The VPC"
}

variable "environment_variables" {
  description = "Environment variables to pass to the container"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "task_role_arn" {
  description = "The execution role to run as in the container, this should include sufficent permissions to all AWS required by the code running in the container."
  type        = string
}