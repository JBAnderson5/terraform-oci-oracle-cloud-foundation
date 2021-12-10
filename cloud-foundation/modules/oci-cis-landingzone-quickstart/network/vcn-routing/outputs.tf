# Copyright © 2021, Oracle and/or its affiliates.
# All rights reserved. Licensed under the Universal Permissive License (UPL), Version 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "subnets_route_tables" {
  description = "The managed subnets_route tables, indexed by display_name."
  value = {
    for rt in oci_core_route_table.these : 
      rt.display_name => rt
    }
} 