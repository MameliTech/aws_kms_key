#==================================================================
# kms_key - variables.tf
#==================================================================

#------------------------------------------------------------------
# Data Source
#------------------------------------------------------------------
variable "foundation_squad" {
  description = "Nome da squad definida na VPC que sera utilizada."
  type        = string
}

variable "foundation_application" {
  description = "Nome da aplicacao definida na VPC que sera utilizada."
  type        = string
}

variable "foundation_environment" {
  description = "Acronimo do ambiente definido na VPC que sera utilizada."
  type        = string
}

variable "foundation_role" {
  description = "Nome da funcao definida na VPC que sera utilizada."
  type        = string
}


#------------------------------------------------------------------
# Resource Nomenclature
#------------------------------------------------------------------
variable "rn_squad" {
  description = "Nome da squad. Limitado a 8 caracteres."
  type        = string
}

variable "rn_application" {
  description = "Nome da aplicacao. Limitado a 8 caracteres."
  type        = string
}

variable "rn_environment" {
  description = "Acronimo do ambiente (dev/hml/prd/devops). Limitado a 6 caracteres."
  type        = string
}

variable "rn_role" {
  description = "Funcao do recurso. Limitado a 8 caracteres."
  type        = string
}


#------------------------------------------------------------------
# KMS Key
#------------------------------------------------------------------
variable "resource_type_abbreviation" {
  description = "Abreviacao do tipo de recurso que utiliza o KMS Key."
  type        = string
  default     = ""
  nullable    = false
}

variable "deletion_window_in_days" {
  description = "Periodo de espera apos a exclusao da chave KMS. O minimo sao 7 dias."
  type        = number
  default     = 7
  nullable    = false
}

variable "enable_key_rotation" {
  description = "Define se deve haver rotacao da chave KMS."
  type        = bool
  default     = true
  nullable    = false
}

variable "kms_policy" {
  type        = string
  description = "A policy usada no KMS Key."
  default     = ""
  nullable    = false
}
