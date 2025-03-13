#==================================================================
# kms_key - outputs.tf
#==================================================================

#------------------------------------------------------------------
# KMS Key
#------------------------------------------------------------------
output "kms-key_arn" {
  description = "O ARN da KMS Key."
  value       = aws_kms_key.this.arn
}

output "kms-key_id" {
  description = "O ID da KMS Key."
  value       = aws_kms_key.this.key_id
}

output "kms-key_policy" {
  description = "A politica de acesso associada a KMS Key."
  value       = aws_kms_key.this.policy
}


#------------------------------------------------------------------
# KMS Key - Alias
#------------------------------------------------------------------
output "kms-key-alias_arn" {
  description = "O ARN do alias da KMS Key."
  value       = aws_kms_alias.this.arn
}


#------------------------------------------------------------------
# IAM Policy
#------------------------------------------------------------------
output "policy_map" {
  description = "Mapa com ARNs de politicas de acesso ('acao' : 'arn')."
  value = {
    "kms_read-only" : aws_iam_policy.kms_ro.arn
    "kms_operator" : aws_iam_policy.kms_op.arn
    "kms_power-user" : aws_iam_policy.kms_pu.arn
  }
}
