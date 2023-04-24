variable "iam_role_name" {
  description = "The name of the IAM role"
  type        = string
  nullable    = false
}

variable "description" {
  description = "A description for your role."
  type        = string
  nullable    = false
}

variable "identifiers" {
  description = "A list of services that can be trusted to assume this role"
  type        = list(string)
  nullable    = false
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}