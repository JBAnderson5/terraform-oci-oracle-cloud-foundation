# Copyright © 2022, Oracle and/or its affiliates.
# All rights reserved. Licensed under the Universal Permissive License (UPL), Version 1.0 as shown at https://oss.oracle.com/licenses/upl.


# inputs

variable "enable_devops" {
    default = false
    type = bool
    description = "if true, allows for the creation of dynamic groups and policies enabling multiple devops resources to access required resources in the application compartment. Note: this is a top level toggle. You will additionally need to toggle on the parts of the devops service you wish to use"
}


variable "target_environment_OKE" {
  default = false 
  type = bool
}
variable "target_environment_compute" {
  default = false 
  type = bool
}
variable "target_environment_functions" {
  default = false 
  type = bool
}



# outputs


# logic

locals {

  devops_rules = concat (
    var.target_environment_OKE ? ["read all-artifacts", "manage cluster"] : [],
    var.target_environment_compute ? ["read all-artifacts", "read instance-family", "use instance-agent-command-family", "use load-balancers", "use vnics"] : [], 
    #TODO: LBs could be in application compartment or network compartment
    var.target_environment_functions ? ["manage fn-function", "read fn-app", "use fn-invocation"] : [],
    [ "manage devops-family", "use ons-topics", "manage repos", "manage generic-artifacts", "manage compute-container-instances", "manage compute-containers", "read all-artifacts"  ] 
  )
  

}


# resource or mixed module blocks

# compute instances
# if compute instances are one of the desired target environments, it also needs a dynamic group to work properly
resource "oci_identity_dynamic_group" "compute" {
    count = var.enable_devops && var.target_environment_compute ? 1 : 0
    compartment_id = var.tenancy_ocid
    description = "all compute instances in ${oci_identity_compartment.application[0].name} compartment"
    matching_rule = "All {instance.compartment.id = 'oci_identity_compartment.application[0].id'}"
    name = "${oci_identity_compartment.application[0].name}-compute"
}

resource "oci_identity_policy" "compute" {
    count = var.enable_devops && var.target_environment_compute ? 1 : 0

    compartment_id = oci_identity_compartment.application[0].id
    description = "enables compute dynamic group to work with devops service in ${oci_identity_compartment.application[0].name} compartment"
    name = "${oci_identity_compartment.application[0].name}-compute"
    statements = concat(
      formatlist("allow dynamic-group ${oci_identity_dynamic_group.compute[0].name} to %s in compartment ${oci_identity_compartment.application[0].name}", [
        "read generic-artifacts", "use instance-agent-command-execution-family"
      ]),
    )
}

# all devops services
resource "oci_identity_dynamic_group" "devops_services" {
    count = var.enable_devops ? 1 : 0
    compartment_id = var.tenancy_ocid
    description = "all Devops services (build, deploy, repo, connection, and trigger) in ${oci_identity_compartment.application[0].name} compartment"
    matching_rule = "All {resource.compartment.id = 'oci_identity_compartment.application[0].id', Any {resource.type = 'devopsdeploypipeline', resource.type = 'devopsbuildpipeline', resource.type = 'devopsrepository', resource.type = 'devopsconnection', resource.type = 'devopstrigger'}}"
    name = "${oci_identity_compartment.application[0].name}-devops-services"
}

resource "oci_identity_policy" "devops_services" {
    count = var.enable_devops ? 1 : 0

    compartment_id = oci_identity_compartment.application[0].id
    description = "enables devops services dynamic group to work with devops service in ${oci_identity_compartment.application[0].name} compartment"
    name = "${oci_identity_compartment.application[0].name}-devops-services"
    statements = concat(
      formatlist("allow dynamic-group ${oci_identity_dynamic_group.devops_services[0].name} to %s in compartment ${oci_identity_compartment.application[0].name}",
        local.devops_rules
      ),
    )
}




