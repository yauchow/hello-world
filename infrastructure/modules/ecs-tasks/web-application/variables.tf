variable "environment" {
  description = "The environment name, used to help name and tag resources created"
  type        = string
}

variable "vpc" {
  description = "The VPC"
  type        = string
}

variable "service_name" {
  description = "The name of an ecs service"
  type        = string
}

variable "port" {
  description = "The port that is exposed"
  type        = number
  default     = 80
}

variable "protocol" {
  description = "The network protocol, eg. TCP, UDP"
  type        = string
  default     = "TCP"
}

variable "health_check_path" {
  description = "The health check path"
  type        = string
  default     = "/"
}

variable "ecs_cluster" {
  description = "The ecs cluster id"
  type = object({
    id = string
  })
}

variable "subnets" {
  description = "Subnets to run the ecs tasks, must be at least two subnets on different availability zones"
  type        = list(string)
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

variable "ecr_security_group" {
  description = "The security group used to get the task definitiv the network access to the ECR api and docker endpoints"
  type        = string
}

variable "http_security_group" {
  description = "The security group used to expose port 80 publicly"
  type        = string
}

variable "execution_role_arn" {
  description = "The execution role to run as in the container, this should include sufficent permissions to all AWS required by the code running in the container."
  type        = string
}

variable "task_role_arn" {
  description = "A role provision with access permissions to setup a container with images from ECR."
  type        = string
}

