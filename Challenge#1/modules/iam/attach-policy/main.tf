# creates a policy from a properly formated json file.
resource "aws_iam_policy" "iam-policy" {
  name        = join("-", [var.policy-name, "iam-policy"])
  description = var.iam-policy-description
  policy      = var.attach-policy
  tags        = var.tags
}

# attaches the policy to the IAM role
resource "aws_iam_policy_attachment" "policy-attachment" {
  name       = join("-", [var.policy-name, "policy-attachment"])
  roles      = [var.iam-role-name]
  policy_arn = aws_iam_policy.iam-policy.arn
}