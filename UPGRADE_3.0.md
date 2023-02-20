# UPGRADE FROM 2.x to 3.0

## azure/subnet

* Replace `enforce_private_link_endpoint_network_policies` variable with `private_endpoint_network_policies_enabled` variable.
  
  Warning the value has to be inverted.
  
  Before:
  ```hcl
  inputs = {
    enforce_private_link_endpoint_network_policies = false
  }
  ```
  
  After:
  ```hcl
  inputs = {
    private_endpoint_network_policies_enabled = true
  }
  ```
