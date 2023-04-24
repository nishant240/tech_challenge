# creates the IAM role using the assume 
data "aws_iam_policy_document" "iam_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = var.identifiers
    }
    effect = "Allow"
  }
}

# set up the role and attached the document as the assume role policy
resource "aws_iam_role" "role" {
  name               = join("-", [var.iam_role_name, "iam-role"])
  description        = var.description
  assume_role_policy = data.aws_iam_policy_document.iam_policy.json
  tags               = var.tags
}