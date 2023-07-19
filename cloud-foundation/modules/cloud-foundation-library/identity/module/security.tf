# Copyright © 2022, Oracle and/or its affiliates.
# All rights reserved. Licensed under the Universal Permissive License (UPL), Version 1.0 as shown at https://oss.oracle.com/licenses/upl.


# inputs

variable "create_security_persona" {
  type        = bool
  default     = false
  description = "if true, creates a Security-Administrators group to manage Security resources in a specific compartment and some tenancy-level resources. It also creates a Security-Users group"
}

variable "security_name" {
    type = string 
    default = "Security"
}

/* expected defined values 
local.enclosing_compartment - compartment OCID
var.tenancy_ocid - tenancy OCID
var.allow_compartment_deletion - bool
local.prefix - string

*/


# outputs
output "security_compartment" {
    value = var.create_security_persona ? oci_identity_compartment.security[0].id : null
    description = "ocid of the security compartment"
}

# logic

locals {
  security_name = "${local.prefix}${var.security_name}"
}


# resource or mixed module blocks

resource "oci_identity_compartment" "security" {
  count          = var.create_security_persona ? 1 : 0
  compartment_id = local.enclosing_compartment
  description    = "Compartment for all security related resources: vaults, topics, notifications, logging, scanning, and others."
  name           = local.security_name
  enable_delete  = var.allow_compartment_deletion
}

resource "oci_identity_group" "security" {
  count          = var.create_security_persona ? 1 : 0
  compartment_id = var.tenancy_ocid
  description    = "Group for managing security services in compartment ${oci_identity_compartment.security[0].name}."
  name           = "${local.security_name}-Administrators"
}

resource "oci_identity_group" "security_service" {
  count          = var.create_security_persona ? 1 : 0
  compartment_id = var.tenancy_ocid
  description    = "Group for users of the Security team to access security resources in compartment ${oci_identity_compartment.security[0].name}."
  name           = "${local.security_name}-Users"
}

resource "oci_identity_policy" "tenancy_security" {
  count          = var.create_security_persona ? 1 : 0
  compartment_id = var.tenancy_ocid
  description    = "Policy for ${oci_identity_group.security[0].name}'s group to manage security related services in tenancy"
  name           = "${local.security_name}-tenancy"
  statements     = concat(
      #security team in tenancy
      formatlist("allow group ${oci_identity_group.security[0].name} to %s in tenancy", [
        "manage cloudevents-rules", "manage cloud-guard-family", "read tenancies", "read objectstorage-namespaces",
        "use cloud-shell", "read usage-budgets", "read usage-reports", "manage tag-namespaces", "manage tag-defaults",
        "manage repos", "read audit-events", "read app-catalog-listing", "read instance-images", "inspect buckets"
      ]),
      
      # devops service
      var.enable_devops == true ? formatlist ("allow dynamic-group ${oci_identity_dynamic_group.devops_services[0].name} to %s in tenancy",[
        "use adm-knowledge-bases", "manage adm-vulnerability-audits"
      ]) : [],
      
  )
}
resource "oci_identity_policy" "security" {
  count          = var.create_security_persona ? 1 : 0
  compartment_id = oci_identity_compartment.security[0].id
  description    = "Policy for ${oci_identity_group.security[0].name}'s group and ${oci_identity_group.security_service[0].name} to manage security related services in Landing Zone compartment ${oci_identity_compartment.security[0].name}."
  name           = local.security_name
  statements     = concat(
      # security team in security compartment
      formatlist("allow group ${oci_identity_group.security[0].name} to %s in compartment ${oci_identity_compartment.security[0].name}", [
        "read all-resources", "manage instance-family", "manage vaults", "manage keys", "manage secret-family",
        "manage logging-family", "manage serviceconnectors", "manage streams", "manage ons-family", "manage functions-family",
        "manage waas-family", "manage security-zone", "manage orm-stacks", "manage orm-jobs", "manage orm-config-source-providers",
        "manage vss-family", "read work-requests", "manage bastion-family", "read instance-agent-plugins", "manage cloudevents-rules",
        "manage alarms", "manage metrics",
        "manage certificate-authority-family"
      ]),
      # security users in security compartment
      formatlist("allow group ${oci_identity_group.security_service[0].name} to %s in compartment ${oci_identity_compartment.security[0].name}", [
        "read vss-family", "use bastion", "manage bastion-session", "use vaults", "use keys", 
        "manage secrets", "manage secret-versions", "read secret-bundles", "manage instance-images",
      ]),

      # devops service
      var.enable_devops == true ? concat(
        formatlist ("allow dynamic-group ${oci_identity_dynamic_group.devops_services[0].name} to %s in compartment ${oci_identity_compartment.security[0].name}",[
        "use cabundles", "read secret-family"
      ]), 
      "allow dynamic-group ${oci_identity_dynamic_group.compute[0].name} to read secret-family in compartment ${oci_identity_compartment.security[0].name}"
      ) : [],
    )
}