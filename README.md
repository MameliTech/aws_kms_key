# AWS KMS Key

![Provedor](https://img.shields.io/badge/provider-AWS-orange) ![Engine](https://img.shields.io/badge/engine-KMS_Key-blueviolet) ![Versão](https://img.shields.io/badge/version-1.0.0-success) ![Coordenação](https://img.shields.io/badge/coord.-Mameli_Tech-informational)<br>

Módulo desenvolvido para o provisionamento de **AWS KMS Key**.

Este módulo tem como objetivo criar um KMS Key seguindo os padrões da Mameli Tech.

Serão criados os seguintes recursos:
1. **KMS Key** com o nome no padrão <span style="font-size: 12px;">`NomeDaEquipe-NomeDaAplicação-Ambiente-FunçãoDoRecurso-AbreviaçãoTipoRecurso-kms`</span>
2. **IAM Policy** com permissão ***Read-Only*** ao KMS Key com o nome no padrão <span style="font-size: 12px;">`AccessToKMS-NomeDaAplicação-Ambiente-FunçãoDoRecurso-AbreviaçãoTipoRecurso_ro`</span>
3. **IAM Policy** com permissão ***Operator*** ao KMS Key com o nome no padrão <span style="font-size: 12px;">`AccessToKMS-NomeDaAplicação-Ambiente-FunçãoDoRecurso-AbreviaçãoTipoRecurso_op`</span>
4. **IAM Policy** com permissão ***Read-Write*** ao KMS Key com o nome no padrão <span style="font-size: 12px;">`AccessToKMS-NomeDaAplicação-Ambiente-FunçãoDoRecurso-AbreviaçãoTipoRecurso_rw`</span>

## Como utilizar?

### Passo 1

Precisamos configurar o Terraform para armazenar o estado dos recursos criados.<br>
Caso não exista um arquivo para este fim, crie o arquivo `tf_01_backend.tf` com o conteúdo abaixo:

```hcl
#==================================================================
# backend.tf - Script de definicao do Backend
#==================================================================

terraform {
  backend "s3" {
    encrypt = true
  }
}
```

### Passo 2

Precisamos armazenar as definições de variáveis que serão utilizadas pelo Terraform.<br>
Caso não exista um arquivo para este fim, crie o arquivo `tf_02_variables.tf` com o conteúdo a seguir.<br>
Caso exista, adicione o conteúdo abaixo no arquivo:

```hcl
#==================================================================
# variables.tf - Script de definicao de Variaveis
#==================================================================

#------------------------------------------------------------------
# Provider
#------------------------------------------------------------------
variable "account_region" {
  description = "Regiao onde os recursos serao alocados."
  type        = string
  default     = "us-east-1"
  nullable    = false
}

variable "profile" {
  description = "Perfil AWS."
  type        = string
  default     = "devops"
  nullable    = false
}


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
# Resource Nomenclature & Tags
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

variable "default_tags" {
  description = "TAGs padrao que serao adicionadas a todos os recursos."
  type        = map(string)
}


#------------------------------------------------------------------
# KMS Key
#------------------------------------------------------------------
variable "kms-key" {
  type = map(object({
    rn_role                    = string
    resource_type_abbreviation = string
    deletion_window_in_days    = optional(number)
    enable_key_rotation        = optional(bool)
    kms_policy                 = optional(string)
  }))
}
```

### Passo 3

Precisamos configurar informar o Terraform em qual região os recursos serão implementados.<br>
Caso não exista um arquivo para este fim, crie o arquivo `tf_03_provider.tf` com o conteúdo abaixo:

```hcl
#==================================================================
# provider.tf - Script de definicao do Provider
#==================================================================

provider "aws" {
  region  = var.account_region
  profile = var.profile

  default_tags {
    tags = merge(
      var.default_tags,
      {
        "T_time" : var.rn_squad
        "T_applicacao" : var.rn_application
        "T_ambiente" : var.rn_environment
        "A_provisionamento" : "terraform"
      }
    )
  }
}
```

### Passo 4

O script abaixo será responsável pela chamada do módulo.<br>
Crie um arquivo no padrão `tf_NN_kms-key.tf` com o conteúdo abaixo:

```hcl
#==================================================================
# kms-key.tf - Script de chamada do modulo KMS Key
#==================================================================

module "kms-key" {
  source   = "git@github.com:MameliTech/aws_kms_key.git"
  for_each = var.kms-key

  foundation_squad           = var.foundation_squad
  foundation_application     = var.foundation_application
  foundation_environment     = var.foundation_environment
  foundation_role            = var.foundation_role
  rn_squad                   = var.rn_squad
  rn_application             = var.rn_application
  rn_environment             = var.rn_environment
  rn_role                    = each.value.rn_role
  resource_type_abbreviation = each.value.resource_type_abbreviation
  deletion_window_in_days    = each.value.deletion_window_in_days
  enable_key_rotation        = each.value.enable_key_rotation
  kms_policy                 = each.value.kms_policy
}
```

### Passo 5

O script abaixo será responsável por gerar os Outputs dos recursos criados.<br>
Crie um arquivo no padrão `tf_99_outputs.tf` e adicione:

```hcl
#==================================================================
# outputs.tf - Script para geracao de Outputs
#==================================================================

output "all_outputs" {
  description = "Todos os outputs do modulo KMS Key."
  value       = module.kms-key
}
```

### Passo 6

Adicione uma pasta env com os arquivos `dev.tfvars`, `hml.tfvars` e `prd.tfvars`. Em cada um destes arquivos você irá informar os valores das variáveis que o módulo utiliza.

Segue um exemplo do conteúdo de um arquivo `tfvars`:

```hcl
#==================================================================
# dev.tfvars - Arquivo de definicao de Valores de Variaveis
#==================================================================

#------------------------------------------------------------------
# Provider
#------------------------------------------------------------------
account_region = "us-east-1"
profile        = "devops"


#------------------------------------------------------------------
# Data Source
#------------------------------------------------------------------
foundation_squad       = "devops"
foundation_application = "sap"
foundation_environment = "dev"
foundation_role        = "sample"


#------------------------------------------------------------------
# Resource Nomenclature & Tags
#------------------------------------------------------------------
rn_squad       = "devops"
rn_application = "sapfi"
rn_environment = "dev"

default_tags = {
  "N_projeto" : "DevOps Lab"                                                            # Nome do projeto
  "N_ccusto_ti" : "Mameli-TI-2025"                                                      # Centro de Custo TI
  "N_ccusto_neg" : "Mameli-Business-2025"                                               # Centro de Custo Negocio
  "N_info" : "Para maiores informacoes procure a Mameli Tech - consultor@mameli.com.br" # Informacoes adicionais
  "T_funcao" : "KMS Key padrao"                                                         # Funcao do recurso
  "T_versao" : "1.0"                                                                    # Versao de provisionamento do ambiente
  "T_backup" : "nao"                                                                    # Descritivo se sera realizado backup automaticamente dos recursos provisionados
}


#------------------------------------------------------------------
# KMS Key
#------------------------------------------------------------------
kms-key = {
  logic1 = {
    rn_role                    = "keytest1"
    resource_type_abbreviation = "general"
    deletion_window_in_days    = 7
    enable_key_rotation        = false
    kms_policy                 = <<EOF
{
  "Version": "2012-10-17",
  "Id": "key-default-1",
  "Statement": [
    {
      "Sid": "EnableIAMUserPermissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::911540969837:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "AllowS3Access",
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": [
        "kms:GenerateDataKey*",
        "kms:Decrypt"
      ],
      "Resource": "*",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "arn:aws:s3:::rispacs-pacs-dev-carga-s3"
        }
      }
    }
  ]
}
EOF
  }
}
```

<br>

## Provedores

| Nome | Versão |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.84.0 |

## Recursos

| Nome | Tipo |
|------|------|
| [aws_iam_policy.kms_op](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.kms_pu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.kms_ro](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_default_tags.tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_subnets.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Entradas do módulo

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-------------|------|---------|:--------:|
| <a name="input_foundation_squad"></a> [foundation\_squad](#input\_foundation\_squad) | Nome da squad definida na VPC que sera utilizada. | `string` | n/a | yes |
| <a name="input_foundation_application"></a> [foundation\_application](#input\_foundation\_application) | Nome da aplicacao definida na VPC que sera utilizada. | `string` | n/a | yes |
| <a name="input_foundation_environment"></a> [foundation\_environment](#input\_foundation\_environment) | Acronimo do ambiente definido na VPC que sera utilizada. | `string` | n/a | yes |
| <a name="input_foundation_role"></a> [foundation\_role](#input\_foundation\_role) | Nome da funcao definida na VPC que sera utilizada. | `string` | n/a | yes |
| <a name="input_rn_squad"></a> [rn\_squad](#input\_rn\_squad) | Nome da squad. Limitado a 8 caracteres. | `string` | n/a | yes |
| <a name="input_rn_application"></a> [rn\_application](#input\_rn\_application) | Nome da aplicacao. Limitado a 8 caracteres. | `string` | n/a | yes |
| <a name="input_rn_environment"></a> [rn\_environment](#input\_rn\_environment) | Acronimo do ambiente (dev/hml/prd/devops). Limitado a 6 caracteres. | `string` | n/a | yes |
| <a name="input_rn_role"></a> [rn\_role](#input\_rn\_role) | Funcao do recurso. Limitado a 8 caracteres. | `string` | n/a | yes |
| <a name="input_resource_type_abbreviation"></a> [resource\_type\_abbreviation](#input\_resource\_type\_abbreviation) | Abreviacao do tipo de recurso que utiliza o KMS Key. | `string` | `""` | no |
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | Periodo de espera apos a exclusao da chave KMS. O minimo sao 7 dias. | `number` | `7` | no |
| <a name="input_enable_key_rotation"></a> [enable\_key\_rotation](#input\_enable\_key\_rotation) | Define se deve haver rotacao da chave KMS. | `bool` | `true` | no |
| <a name="input_kms_policy"></a> [kms\_policy](#input\_kms\_policy) | A policy usada no KMS Key. | `string` | "" | no |

## Saída dos módulos

| Nome | Descrição |
|------|-------------|
| <a name="output_account_id"></a> [account\_id](#output\_account\_id) | O ID da conta AWS. |
| <a name="output_account_region"></a> [account\_region](#output\_account\_region) | A regiao que hospeda os recursos. |
| <a name="output_kms-key_arn"></a> [kms-key\_arn](#output\_kms-key\_arn) | O ARN da KMS Key. |
| <a name="output_kms-key_id"></a> [kms-key\_id](#output\_kms-key\_id) | O ID da KMS Key. |
| <a name="output_kms-key_policy"></a> [kms-key\_policy](#output\_kms-key\_policy) | A politica de acesso associada a KMS Key. |
| <a name="output_kms-key-alias_arn"></a> [kms-key-alias\_arn](#output\_kms-key-alias\_arn) | O ARN do alias da KMS Key. |
| <a name="output_policy_map"></a> [policy\_map](#output\_policy\_map) | Mapa com ARNs de politicas de acesso ('acao' : 'arn'). |

<br><br><hr>

<div align="right">

<strong> Data da última versão: &emsp; 09/03/2025 </strong>

</div>
