#==================================================================
# kms-key.tf
#==================================================================

#------------------------------------------------------------------
# KMS Key
#------------------------------------------------------------------
resource "aws_kms_key" "this" {
  description             = "KMS key used in ${local.source_resource} encryption"
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation
  policy                  = var.kms_policy

  tags = { "Name" : local.key_name }
}


#------------------------------------------------------------------
# KMS Key - Alias
#------------------------------------------------------------------
resource "aws_kms_alias" "this" {
  name          = "alias/${local.key_name}"
  target_key_id = aws_kms_key.this.id
}
