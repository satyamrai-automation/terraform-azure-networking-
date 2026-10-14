# 🌐 Terraform Azure Networking Module 

Production-ready Terraform child module for core Azure networking topology, subnet zoning, stateful packet filtering (NSGs), route tables, and peering.

---

## 🌟 Managed Resources

This module consolidates the following Azure networking resources:

1. **[`azurerm_virtual_network`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network)**: Private software-defined cloud networks with custom address spaces.
2. **[`azurerm_subnet`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)**: Network subnets with delegation and service endpoint support.
3. **[`azurerm_network_security_group`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group)**: Stateful Layer 4 packet inspection firewall rules.
4. **[`azurerm_subnet_network_security_group_association`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association)**: Attaches NSGs to subnet boundaries.
5. **[`azurerm_route_table`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table)**: User Defined Routes (UDR) to steer outbound traffic.
6. **[`azurerm_subnet_route_table_association`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association)**: Binds custom routing tables to subnets.
7. **[`azurerm_virtual_network_peering`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering)**: Low-latency inter-VNet routing over the Azure backbone.

---

## 🔐 Azure Permissions

* **Contributor Role:** ✅ **100% Supported**. All resources reside under `Microsoft.Network/*`. No elevated Owner or User Access Administrator rights required.

---

## 🚀 Consumption in Root Modules (`Rally-tech-infra`)

### 1. In `environments/dev/main.tf`:
```hcl
module "networking" {
  source = "git::https://github.com/satyamrai-automation/terraform-azure-networking-.git?ref=v1.0.0"

  virtual_networks                = var.virtual_networks
  subnets                         = var.subnets
  network_security_groups         = var.network_security_groups
  subnet_nsg_associations         = var.subnet_nsg_associations
  route_tables                    = var.route_tables
  subnet_route_table_associations = var.subnet_route_table_associations
  vnet_peerings                   = var.vnet_peerings

  depends_on = [module.governance]
}
```

### 2. In `environments/dev/terraform.tfvars`:
```hcl
virtual_networks = {
  "vnet-dev" = {
    name                = "vnet-rally-dev-centralindia"
    location            = "centralindia"
    resource_group_name = "rg-rally-dev-centralindia"
    address_space       = ["10.30.0.0/16"]
  }
}

subnets = {
  "snet-frontend" = {
    name                = "snet-frontend"
    resource_group_name = "rg-rally-dev-centralindia"
    vnet_key            = "vnet-dev"
    address_prefixes    = ["10.30.1.0/24"]
  }
  "snet-backend" = {
    name                = "snet-backend"
    resource_group_name = "rg-rally-dev-centralindia"
    vnet_key            = "vnet-dev"
    address_prefixes    = ["10.30.2.0/24"]
  }
}
```

---

## 📥 Inputs

| Name | Type | Description | Default | Required |
| :--- | :--- | :--- | :---: | :---: |
| `virtual_networks` | `map(object)` | Virtual networks with address space and DNS | `{}` | No |
| `subnets` | `map(object)` | Subnets with CIDR, service endpoints, and delegations | `{}` | No |
| `network_security_groups` | `map(object)` | NSGs with list of stateful security rules | `{}` | No |
| `subnet_nsg_associations` | `map(object)` | Associations binding NSGs to subnets | `{}` | No |
| `route_tables` | `map(object)` | User-defined route tables and routes | `{}` | No |
| `subnet_route_table_associations` | `map(object)` | Associations binding route tables to subnets | `{}` | No |
| `vnet_peerings` | `map(object)` | VNet peering definitions | `{}` | No |

---

## 📤 Outputs

| Name | Description |
| :--- | :--- |
| `virtual_networks` | Complete map of created Virtual Network objects |
| `virtual_network_ids` | Map of Virtual Network IDs |
| `virtual_network_names` | Map of Virtual Network names |
| `virtual_network_address_spaces` | Map of Virtual Network CIDR address spaces |
| `subnets` | Complete map of created Subnet objects |
| `subnet_ids` | Map of Subnet IDs (used to connect VMs, AKS, Private Endpoints) |
| `subnet_names` | Map of Subnet names |
| `network_security_groups` | Complete map of created NSG objects |
| `network_security_group_ids` | Map of NSG IDs |
| `route_tables` | Complete map of created Route Table objects |
| `route_table_ids` | Map of Route Table IDs |
| `vnet_peerings` | Complete map of created VNet Peering objects |
