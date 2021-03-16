
#Directory = /jagadt80/tf-az-poc::main
#File1 = main.tf
#File2 = outputs.tf
#File3 = providers.tf
#File4 = variables.tf

#File =main.tf
module "new_subscription" {
  source = "./modules/subscription"
}

module "management_groups" {
  source            = "./modules/management-groups"
  EA_subscriptionid = module.new_subscription.EA_subscriptionid
}

module "policy_assignments" {
  source                      = "./modules/policy-assignments"
  EA_id                       = module.new_subscription.EA_id
  tag_governance_policyset_id = module.policyset_definitions.tag_governance_policyset_id
}

module "policy_definitions" {
  source = "./modules/policy-definitions"
  # childmg_id = module.management_groups.childmg_id
  EA_subscriptionid = module.new_subscription.EA_subscriptionid
}

module "policyset_definitions" {
  source = "./modules/policyset-definitions"
  # childmg_id = module.management_groups.childmg_id
  EA_subscriptionid = module.new_subscription.EA_subscriptionid
  custom_policies_tag_governance = [
    {
      policyID = module.policy_definitions.addTagToRG_policy_ids[0]
    },
    {
      policyID = module.policy_definitions.addTagToRG_policy_ids[1]
    },
    {
      policyID = module.policy_definitions.addTagToRG_policy_ids[2]
    },
    {
      policyID = module.policy_definitions.addTagToRG_policy_ids[3]
    },
    {
      policyID = module.policy_definitions.addTagToRG_policy_ids[4]
    },
    {
      policyID = module.policy_definitions.addTagToRG_policy_ids[5]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRG_policy_ids[0]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRG_policy_ids[1]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRG_policy_ids[2]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRG_policy_ids[3]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRG_policy_ids[4]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRG_policy_ids[5]
    }
  ]
}

#File =outputs.tf
output "child_management_group" {
  description = "The id of the newly created Child Azure management group"
  value       = module.management_groups.childmg_id
}

output "parent_management_group" {
  description = "The id of the newly created Parent Azure management group"
  value       = module.management_groups.parentmg_id
}

output "new_subscription" {
  description = "The subscription id of the newly created Azure EA subscription"
  value       = module.new_subscription.EA_subscriptionid
}

output "new_subscription_owners" {
  description = "The subscription owners of the newly created Azure EA subscription"
  value       = module.new_subscription.EA_owners
}



#File =providers.tf
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
    azure-preview = {
      source  = "TeckResourcesTDS/azure-preview"
      version = "0.1.3"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "${var.subscriptionId}"
  client_id       = "${var.clientId}"
  client_secret   = "${var.clientSecret}"
  tenant_id       = "${var.tenantId}"
}


#File =variables.tf
variable "subscriptionId" {}
variable "clientId" {}
variable "clientSecret" {}
variable "tenantId" {}

variable "name" {
  description = "The display name of the subscription"
  type        = string
  default = "clz-wpp-wppit-snowmanagement"
}

variable "NewParentMGName" {
  description = "The name of the new parent management group"
  type        = string
  default = "WPPShared"
}

variable "NewParentMGDisplayName" {
  description = "The display name of the new parent management group"
  type        = string
  default = "WPP Shared"
}

variable "NewChildMGName" {
  description = "The name of the new child management group"
  type        = string
  default = "WPPManagement"
}

variable "NewChildMGDisplayName" {
  description = "The display name of the new child management group"
  type        = string
  default = "WPP Management"
}

variable "owners" {
  description = "The list of principals that should be granted Owner access on the subscription. Principals should be of type User, Service Principal or Security Group"
  type        = list
  default = ["41237360-560c-4459-91b2-582229a72dd6"]
}

variable "offer_type" {
  description = "The offer type of the subscription. Only valid when creating a subscription in a enrollment account scope. Possible values include: MS-AZR-0017P (production use), MS-AZR-0148P (dev/test)"
  type        = string
  default = "MS-AZR-0017P"
}

variable "enrollment_account" {
  description = "The name of the enrollment account to which the subscription will be billed"
  type        = string
  default = "716560cf-92ba-4082-aafb-0cf5f72c9c6d"
}


variable "mandatory_tag_keys" {
type = list
default = [
    "serviceowner",
    "cartesiscode",
    "environment",
    "opgrp",
    "opco",
    "projectcode"
  ]
  }
 
variable "mandatory_tag_value" {
type = list
default = [
    "Nikolai Lakovic",
    "99999",
    "propod",
    "WPP",
    "WPPIT",
    "190789"
  ]
  }
