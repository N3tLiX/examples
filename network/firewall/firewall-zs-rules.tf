resource "azurerm_firewall_policy_rule_collection_group" "zscaler_policy" {
  name               = "ZscalerEgressRuleCollegionGroup"
  firewall_policy_id = module.firewall.policy_id
  priority           = 610

  application_rule_collection {
    name     = "ApplicationRules"
    priority = 500
    action   = "Allow"

    rule {
      name             = "AllowZpaFqdns"
      source_addresses = ["10.1.255.128/26"]
      destination_fqdns = [
        "*.prod.zpath.net",
        "*.private.zscaler.com",
        "*.zscalergov.net",
        "*.zpagov.net"
      ]

      protocols {
        port = "443"
        type = "Https"
      }
    }

    rule {
      name             = "AllowZiaFqdns"
      source_addresses = ["10.1.255.128/26"]
      destination_fqdns = [
        "*.sme.zscaler.net",
        "*.sme.zscalerone.net",
        "*.sme.zscalertwo.net",
        "*.sme.zscalertree.net",
        "*.sme.zscloud.net",
        "*.sme.zscalerbeta.net",
        "*.sme.zscalergov.net",
      ]

      protocols {
        port = "443"
        type = "Https"
      }
    }

    rule {
      name             = "AllowOsUpdateFqdns"
      source_addresses = ["10.1.255.128/26"]
      destination_fqdns = [
        "yum.private.zscaler.com",
        "rhn.redhat.com",
        "xmlrpc.rhn.redhat.com",
        "content-xmlrpc.rhn.redhat.com",
        "content-web.rhn.redhat.com",
        "cdn.redhat.com",
        "satellite.rhn.redhat.com",
        "content-satellite.rhn.redhat.com",
        "*.akamaiedge.net",
      ]

      protocols {
        port = "443"
        type = "Https"
      }

      protocols {
        port = "80"
        type = "Http"
      }

    }
  }
  depends_on = [
    module.firewall
  ]
}
