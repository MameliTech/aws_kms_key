#==================================================================
# kms_key - resource-names.tf
#==================================================================

locals {
  key_name        = "${var.rn_squad}-${var.rn_application}-${var.rn_environment}-${var.rn_role}-${var.resource_type_abbreviation}-kms"
  source_resource = "${var.rn_squad}-${var.rn_application}-${var.rn_environment}-${var.rn_role}-${var.resource_type_abbreviation}"
  iam_kms_ro      = "${var.rn_squad}-${var.rn_application}-${var.rn_environment}-${var.rn_role}-AccessToKMS_${var.resource_type_abbreviation}_ro"
  iam_kms_op      = "${var.rn_squad}-${var.rn_application}-${var.rn_environment}-${var.rn_role}-AccessToKMS_${var.resource_type_abbreviation}_op"
  iam_kms_pu      = "${var.rn_squad}-${var.rn_application}-${var.rn_environment}-${var.rn_role}-AccessToKMS_${var.resource_type_abbreviation}_pu"
}
