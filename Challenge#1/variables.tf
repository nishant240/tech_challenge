variable aws_region {
  type = string
  description = "AWS region which should be used"
}

variable aws_zones {
  type = list
  description = "AWS zones which should be used"
}

variable vpc_cidr {
  type = string
  description = "CIDR of the VPC"
  default = ""
}

variable "app_name" {
  description = "Application name"
}

variable "instance_class" {
    description = "RDS instance type"
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

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "instance_count" {
  description = "Number of instances to be launched"
  type        = number
  default     = "1"
}

variable "instance_type" {
  description = "Type of instance to be launched"
  type        = string
  default     = "t2.micro"
}

variable "root_volume_type" {
  description = "Type of root volume"
  type        = string
  default     = "gp2"
}

variable "instance_volume_size" {
  description = "Size of root partition"
  type        = number
  default     = "20"
}

variable user_data {
  type = string
  description = "User data"
  default = ""
}

variable "private_key_path" {
  type    = string
  default = ""
}