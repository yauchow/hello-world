variable "environment" {
  description = "The environment name, used to help name and tag resources created"
  type        = string
}

variable "vpc" {
  description = "The VPC"
}

variable "service_name" {
  description = "The name of an ecs service"
  type        = string
}

variable "container_image" {
  description = "The container image"
  type        = string
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
  description = "The role to run with sufficent permissions to access aws resources to fullfil the business logic."
  type        = string
}

