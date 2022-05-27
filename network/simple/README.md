# [examples/network/simple]

Create an Azure Network Setup with Terraform Modues (IaC).

## Used Modules:

- Virutal Network: ```github.com/N3tLiX/modules//vnet```
- NAT Gateway: ```github.com/N3tLiX/modules//nat```
- Private DNS Zone: ```github.com/N3tLiX/modules//privatednszone```
- Network Security Group: ```github.com/N3tLiX/modules//nsg```
- Bastion Host: ```github.com/N3tLiX/modules//bastionhost```

## Variables (locals.tf)

```hcl
locals {
  resource_group_name                   = "rg-example-simple-network"
  location                              = "westeurope"
  vnet_name                             = "vn-example-simple"
  address_space                         = ["10.255.0.0/24"]
  nat_gateway_prefix_enabled            = false
  bastion_host_name                     = "bh-example-simple"
  private_dns_zone_name                 = "simple.example.mydomain.com"
  private_dns_zone_registration_enabled = true
  subnets = [
    {
      name : "AzureBastionSubnet"
      address_prefixes : ["10.255.0/26"]
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
```

## Deploy

```sh
$ export ARM_SUBSCRIPTION_ID="0000...."
$ export ARM_CLIENT_ID="0000...."
$ export ARM_CLIENT_SECRET="myClientSecret"
$ export ARM_TENANT_ID="0000....."
§ terraform init
§ terraform plan -out tfplan
§ terraform apply tfplan
```
## Authors

Originally created by [Patrick Hayo](http://github.com/adminph-de)

## License

[MIT](LICENSE)