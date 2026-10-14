output "virtual_networks" {
  description = "Virtual network objects"
  value       = azurerm_virtual_network.vnet
}

output "virtual_network_ids" {
  description = "Map of Virtual Network IDs"
  value       = { for k, v in azurerm_virtual_network.vnet : k => v.id }
}

output "virtual_network_names" {
  description = "Map of Virtual Network names"
  value       = { for k, v in azurerm_virtual_network.vnet : k => v.name }
}

output "virtual_network_address_spaces" {
  description = "Map of Virtual Network address spaces"
  value       = { for k, v in azurerm_virtual_network.vnet : k => v.address_space }
}

output "subnets" {
  description = "Subnet objects"
  value       = azurerm_subnet.subnet
}

output "subnet_ids" {
  description = "Map of Subnet IDs"
  value       = { for k, v in azurerm_subnet.subnet : k => v.id }
}

output "subnet_names" {
  description = "Map of Subnet names"
  value       = { for k, v in azurerm_subnet.subnet : k => v.name }
}

output "subnet_address_prefixes" {
  description = "Map of Subnet address prefixes"
  value       = { for k, v in azurerm_subnet.subnet : k => v.address_prefixes }
}

output "network_security_groups" {
  description = "Network Security Group objects"
  value       = azurerm_network_security_group.nsg
}

output "network_security_group_ids" {
  description = "Map of Network Security Group IDs"
  value       = { for k, v in azurerm_network_security_group.nsg : k => v.id }
}

output "route_tables" {
  description = "Route Table objects"
  value       = azurerm_route_table.rt
}

output "route_table_ids" {
  description = "Map of Route Table IDs"
  value       = { for k, v in azurerm_route_table.rt : k => v.id }
}

output "vnet_peerings" {
  description = "Virtual Network Peering objects"
  value       = azurerm_virtual_network_peering.peering
}
