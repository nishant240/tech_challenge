output "id" {
  value       = aws_iam_policy.iam-policy.id
  description = "The ARN assigned by AWS to this policy."
}

output "arn" {
  value       = aws_iam_policy.iam-policy.arn
  description = "The ARN assigned by AWS to this policy."
}

output "description" {
  value       = aws_iam_policy.iam-policy.description
  description = "The description of the policy."
}

output "name" {
  value       = aws_iam_policy.iam-policy.name
  description = "The name of the policy."
}

output "path" {
  value       = aws_iam_policy.iam-policy.path
  description = "The path of the policy in IAM."
}

output "policy" {
  value       = aws_iam_policy.iam-policy.policy
  description = "The policy document."
}

output "policy_id" {
  value       = aws_iam_policy.iam-policy.policy_id
  description = "The policy's ID."
}

output "attachment_name" {
  value       = aws_iam_policy_attachment.policy-attachment.name
  description = "The name of the attachment."
}
