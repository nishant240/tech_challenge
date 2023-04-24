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

variable "app_name" {
  description = "Application name"
}

variable aws_zones {
  type = list
  description = "AWS zones which should be used"
}

variable private_subnet_ids {
  description = " private subnets"
}

variable public_subnet_ids {
  description = " public subnets"
}

variable "vpc_cidr" {
  description = "VPC cidr"
}

variable vpc_id {
  type = string
  description = "VPC ID"
}

variable "private_key_path" {
  type    = string
  default = ""
}

variable user_data {
  type = string
  description = "User data"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}