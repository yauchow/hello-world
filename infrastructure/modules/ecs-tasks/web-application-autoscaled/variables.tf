variable "config" {
  description = "the environment configuration"
}

variable "vpc" {
  description = "the vpc module"
}

variable "execution_role_arn" {
  description = "the arn to the IAM role used for the execution of the web application"
  type        = string
}

variable "environment" {
  description = "the environment, eg. Definitiv-dev, Definitiv-qa or Definitiv-prod"
  type        = string
}

variable "service_name" {
  description = "name of service, eg. webapp or identity_api.  This is also the name we will use to get the infrastructure configuration."
}

variable "environment_variables" {
  type = list(object({
    name  = string
    value = string
  }))

  default = []
}