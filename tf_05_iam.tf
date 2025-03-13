#==================================================================
# kms-key - iam.tf
#==================================================================

#------------------------------------------------------------------
# IAM Policy - KMS Key - Read-Only
#------------------------------------------------------------------
resource "aws_iam_policy" "kms_ro" {
  name = local.iam_kms_ro

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "ReadOnly",
        "Effect" : "Allow"
        "Action" : [
          "kms:DescribeKey",
          "kms:GetKeyPolicy",
          "kms:GetKeyRotationStatus",
          "kms:GetParametersForImport",
          "kms:ListAliases",
          "kms:ListKeys",
          "kms:ListResourceTags",
          "kms:ListRetirableGrants"
        ],
        "Resource" : aws_kms_key.this.arn,
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "true"
          }
        }
      }
    ]
  })

  tags = { "Name" : local.iam_kms_ro }
}


#------------------------------------------------------------------
# IAM Policy - KMS Key - Operator
#------------------------------------------------------------------
resource "aws_iam_policy" "kms_op" {
  name = local.iam_kms_op

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Operator",
        "Effect" : "Allow"
        "Action" : [
          "kms:DescribeKey",
          "kms:GetKeyPolicy",
          "kms:GetKeyRotationStatus",
          "kms:GetParametersForImport",
          "kms:ListAliases",
          "kms:ListKeys",
          "kms:ListResourceTags",
          "kms:ListRetirableGrants",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncryptFrom",
          "kms:ReEncryptTo",
          "kms:GenerateDataKey",
          "kms:GenerateDataKeyWithoutPlaintext"
        ],
        "Resource" : aws_kms_key.this.arn,
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "true"
          }
        }
      }
    ]
  })

  tags = { "Name" : local.iam_kms_op }
}


#------------------------------------------------------------------
# IAM Policy - KMS Key - Power User
#------------------------------------------------------------------
resource "aws_iam_policy" "kms_pu" {
  name = local.iam_kms_pu

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PowerUser",
        "Effect" : "Allow",
        "Action" : [
          "kms:DescribeKey",
          "kms:GetKeyPolicy",
          "kms:GetKeyRotationStatus",
          "kms:GetParametersForImport",
          "kms:ListAliases",
          "kms:ListKeys",
          "kms:ListResourceTags",
          "kms:ListRetirableGrants",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncryptFrom",
          "kms:ReEncryptTo",
          "kms:GenerateDataKey",
          "kms:GenerateDataKeyWithoutPlaintext"
        ],
        "Resource" : aws_kms_key.this.arn,
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "true"
          }
        }
      }
    ]
  })

  tags = { "Name" : local.iam_kms_pu }
}
