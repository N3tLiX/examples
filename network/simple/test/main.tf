
# // Example 1

# module "name_empty" {
#   source  = "Azure/naming/azurerm"
#   version = "0.1.1"
# }

# output "name_empty" {
#   value = module.name_empty.storage_account.name_unique
# }

# # // Example 2

# module "suffix" {
#   source        = "Azure/naming/azurerm"
#   version       = "0.1.1"
#   suffix        = ["su", "fix"]
#   unique-length = 20
# }

# output "suffix" {
#   value = module.suffix.storage_account.name_unique
# }

# // Example 3

# module "random" {
#   source      = "Azure/naming/azurerm"
#   version     = "0.1.1"
#   unique-seed = module.suffix.unique-seed
# }

# output "random" {
#   value = module.random.storage_account.name_unique
# }

// Example 4

# module "everything" {
#   source  = "Azure/naming/azurerm"
#   version = "0.1.1"
#   suffix  = ["example"]
# }

# module "network" {
#   source                 = "Azure/naming/azurerm"
#   version                = "0.1.1"
#   suffix                 = ["example"]
#   unique-length          = 8
#   unique-include-numbers = true
# }

# output "storage_account" {
#   value = module.everything.storage_account.name_unique
# }
# #
# output "virtual_network" {
#   value = module.everything.virtual_network.name_unique
# }

# output "subnet" {
#   value = module.everything.subnet.name_unique
# }

# output "private_dns_zone" {
#   value = module.everything.private_dns_zone.name_unique
# }

# output "validation_everything" {
#   value = module.everything.validation
# }

locals {
  subnets = [
    {
      name : "AzureBastionSubnet"
      address_prefixes : ["10.255.0.0/26"]
      enforce_private_link_endpoint_network_policies : true
      enforce_private_link_service_network_policies : false
      service_endpoints : [
        "Microsoft.AzureActiveDirectory"
      ]
      deligation : {
        name : null
        service_delegation : {
          actions : null
          name : null
        }
      }
    },

    {
      name : "sn-example-endpoints"
      address_prefixes : ["10.255.0.64/26"]
      enforce_private_link_endpoint_network_policies : false
      enforce_private_link_service_network_policies : false
      service_endpoints : [
        "Microsoft.AzureActiveDirectory",
        "Microsoft.Storage",
      ]
      deligation : {
        name : null
        service_delegation : {
          actions : null
          name : null
        }
      }
    },
    {
      name : "sn-example-services"
      address_prefixes : ["10.255.0.128/25"]
      enforce_private_link_endpoint_network_policies : true
      enforce_private_link_service_network_policies : false
      service_endpoints : [
        "Microsoft.AzureActiveDirectory",
        "Microsoft.Storage",
      ]
      deligation : {
        name : null
        service_delegation : {
          actions : null
          name : null
        }
      }
    }
  ]
}

module "network" {
  for_each = { for subnet in local.subnets : subnet.name => subnet
  if subnet.name != "GatewaySubnet" && subnet.name != "AzureFirewallSubnet" && subnet.name != "AzureFirewallManagementSubnet" && subnet.name != "AzureBastionSubnet" && subnet.name != "RouteServerSubnet" }
  source                 = "Azure/naming/azurerm"
  version                = "0.1.1"
  suffix                 = [replace(replace(join("", (each.value.address_prefixes)), ".", "_"), "/", "__")]
  unique-length          = 8
  unique-include-numbers = true
}

output "subnet_suffix" {
  value = [for type in module.network : type.subnet.name_unique]
}
