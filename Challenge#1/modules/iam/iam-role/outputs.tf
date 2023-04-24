output "name" {
  value       = aws_iam_role.role.name
  description = "Name of the role."
}

output "arn" {
  value       = aws_iam_role.role.arn
  description = "Amazon Resource Name (ARN) specifying the role."
}

output "create_date" {
  value       = aws_iam_role.role.create_date
  description = "Creation date of the IAM role."
}

output "id" {
  value       = aws_iam_role.role.id
  description = "Name of the role."
}

output "unique_id" {
  value       = aws_iam_role.role.unique_id
  description = "Stable and unique string identifying the role."
}

output "assume_role_policy" {
  value       = data.aws_iam_policy_document.iam_policy.json
  description = "The policy of the assume role in JSON format."
}
