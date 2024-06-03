###############################################################################
# AWS IAM Policy Statements for Vault Demo
###############################################################################
resource "aws_iam_role" "vault_server" {
  name_prefix        = "${var.name_prefix}-"
  assume_role_policy = data.aws_iam_policy_document.instance_trust_policy.json
}

data "aws_iam_policy_document" "instance_trust_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

data "aws_iam_policy_document" "instance_permissions_policy" {
  statement {
    sid    = "VaultAutoJoin"
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
    ]
    resources = [
      "*"
    ]
  }

  #########################################################
  # This allows you to not have to unseal the Vault instance
  #########################################################
  statement {
    sid    = "VaultAutoUnsealKMS"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey",
    ]
    resources = [
      aws_kms_key.vault.arn
    ]
  }

  statement {
    sid    = "VaultAWSEC2AuthMethod"
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "iam:GetInstanceProfile",
      "iam:GetUser",
      "iam:GetRole"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid    = "VaultAWSEC2AuthMethodAssumeRole"
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    resources = [
      aws_iam_role.vault_server.arn
    ]
  }

}

resource "aws_iam_role_policy" "vault_server" {
  name_prefix = "${var.name_prefix}-"
  role        = aws_iam_role.vault_server.id
  policy      = data.aws_iam_policy_document.instance_permissions_policy.json
}

resource "aws_iam_instance_profile" "vault_server" {
  name_prefix = "${var.name_prefix}-"
  role        = aws_iam_role.vault_server.id
}
