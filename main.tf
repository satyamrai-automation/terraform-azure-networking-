resource "azurerm_virtual_network" "vnet" {
  for_each = var.virtual_networks

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.address_space
  dns_servers         = lookup(each.value, "dns_servers", null)
  tags                = lookup(each.value, "tags", null)
}

resource "azurerm_subnet" "subnet" {
  for_each = var.subnets

  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = lookup(each.value, "vnet_key", null) != null ? azurerm_virtual_network.vnet[each.value.vnet_key].name : each.value.virtual_network_name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = lookup(each.value, "service_endpoints", null)

  dynamic "delegation" {
    for_each = lookup(each.value, "delegations", [])
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_name
        actions = lookup(delegation.value, "actions", null)
      }
    }
  }
}

resource "azurerm_network_security_group" "nsg" {
  for_each = var.network_security_groups

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  tags                = lookup(each.value, "tags", null)

  dynamic "security_rule" {
    for_each = lookup(each.value, "security_rules", [])
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = lookup(security_rule.value, "source_port_range", null)
      source_port_ranges         = lookup(security_rule.value, "source_port_ranges", null)
      destination_port_range     = lookup(security_rule.value, "destination_port_range", null)
      destination_port_ranges    = lookup(security_rule.value, "destination_port_ranges", null)
      source_address_prefix      = lookup(security_rule.value, "source_address_prefix", null)
      source_address_prefixes    = lookup(security_rule.value, "source_address_prefixes", null)
      destination_address_prefix = lookup(security_rule.value, "destination_address_prefix", null)
      destination_address_prefixes = lookup(security_rule.value, "destination_address_prefixes", null)
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  for_each = var.subnet_nsg_associations

  subnet_id                 = lookup(each.value, "subnet_key", null) != null ? azurerm_subnet.subnet[each.value.subnet_key].id : each.value.subnet_id
  network_security_group_id = lookup(each.value, "nsg_key", null) != null ? azurerm_network_security_group.nsg[each.value.nsg_key].id : each.value.network_security_group_id
}

resource "azurerm_route_table" "rt" {
  for_each = var.route_tables

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  tags                = lookup(each.value, "tags", null)

  dynamic "route" {
    for_each = lookup(each.value, "routes", [])
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = lookup(route.value, "next_hop_in_ip_address", null)
    }
  }
}

resource "azurerm_subnet_route_table_association" "rt_assoc" {
  for_each = var.subnet_route_table_associations

  subnet_id      = lookup(each.value, "subnet_key", null) != null ? azurerm_subnet.subnet[each.value.subnet_key].id : each.value.subnet_id
  route_table_id = lookup(each.value, "route_table_key", null) != null ? azurerm_route_table.rt[each.value.route_table_key].id : each.value.route_table_id
}

resource "azurerm_virtual_network_peering" "peering" {
  for_each = var.vnet_peerings

  name                         = each.value.name
  resource_group_name          = each.value.resource_group_name
  virtual_network_name         = lookup(each.value, "vnet_key", null) != null ? azurerm_virtual_network.vnet[each.value.vnet_key].name : each.value.virtual_network_name
  remote_virtual_network_id    = each.value.remote_virtual_network_id
  allow_virtual_network_access = lookup(each.value, "allow_virtual_network_access", true)
  allow_forwarded_traffic      = lookup(each.value, "allow_forwarded_traffic", false)
  allow_gateway_transit        = lookup(each.value, "allow_gateway_transit", false)
  use_remote_gateways          = lookup(each.value, "use_remote_gateways", false)
}
