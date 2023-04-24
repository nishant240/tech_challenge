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

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
