variable "config" {
  description = "the environment configuration"
}

variable "vpc" {
  description = "the vpc module"
}

variable "task_role_arn" {
  description = "The role with sufficent permissions AWS resources needed to fullfil the completion of business logic."
  type        = string
}

variable "environment" {
  description = "the environment, eg. Definitiv-dev, Definitiv-qa or Definitiv-prod"
  type        = string
}

variable "service_name" {
  description = "name of service, eg. webapp or identity_api.  This is also the name we will use to get the infrastructure configuration."
}

variable "port" {
  description = "The port that is exposed"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "The health check path"
  type        = string
  default     = "/"
}

variable "environment_variables" {
  type = list(object({
    name  = string
    value = string
  }))

  default = []
}