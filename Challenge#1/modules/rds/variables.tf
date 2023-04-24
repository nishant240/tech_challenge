variable vpc_id {
  type = string
  description = "VPC ID"
}

variable private_subnet_ids {
  description = " private subnets"
}

variable "app_name" {
    description = "Application name"
}

variable "allocated_storage" {
    description = "RDS initial storage capacity in GB"
}

variable "max_allocated_storage" {
    description = "RDS storage capacity in GB for autoscaling"
}

variable "engine" {
    description = "RDS database type"
}

variable "engine_version" {
    description = "RDS database version"
}

variable "vpc_cidr" {
    description = "VPC cidr"
}

variable "instance_class" {
    description = "Instance class of database"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}