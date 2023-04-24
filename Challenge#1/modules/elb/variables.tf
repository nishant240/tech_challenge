variable vpc_id {
  type = string
  description = "VPC ID"
}

variable app_name {
  type = string
  description = "App Name"
}

variable public_subnet_ids {
  description = " public subnets"
}

variable instance_id {
  description = "Instance ID's to be attached to target group"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}