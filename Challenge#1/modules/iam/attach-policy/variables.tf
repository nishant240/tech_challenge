variable "policy-name" {
  description = "The name of the policy you are attaching. Must be unique and should be in format of <project>-<service>."
  type        = string
  nullable    = false
}

variable "iam-policy-description" {
  description = "A short description for the iam policy"
  type        = string
  nullable    = false
}

variable "iam-role-name" {
  description = "The name of the IAM Role you want to attach the policy to."
  type        = string
  nullable    = false
}

variable "attach-policy" {
  description = "The name of the file that has the policy defined in JSON format"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}