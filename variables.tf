variable "virtual_networks" {
  description = "Virtual networks to provision"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    address_space       = list(string)
    dns_servers         = optional(list(string))
    tags                = optional(map(string))
  }))
  default = {}
}

variable "subnets" {
  description = "Subnets to partition across virtual networks"
  type = map(object({
    name                 = string
    resource_group_name  = string
    virtual_network_name = optional(string)
    vnet_key             = optional(string)
    address_prefixes     = list(string)
    service_endpoints    = optional(list(string))
    delegations = optional(list(object({
      name         = string
      service_name = string
      actions      = optional(list(string))
    })), [])
  }))
  default = {}
}

variable "network_security_groups" {
  description = "Network Security Groups (NSGs) with stateful rules"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    tags                = optional(map(string))
    security_rules = optional(list(object({
      name                         = string
      priority                     = number
      direction                    = string # Inbound / Outbound
      access                       = string # Allow / Deny
      protocol                     = string # Tcp / Udp / Icmp / *
      source_port_range            = optional(string)
      source_port_ranges           = optional(list(string))
      destination_port_range       = optional(string)
      destination_port_ranges      = optional(list(string))
      source_address_prefix        = optional(string)
      source_address_prefixes      = optional(list(string))
      destination_address_prefix   = optional(string)
      destination_address_prefixes = optional(list(string))
    })), [])
  }))
  default = {}
}

variable "subnet_nsg_associations" {
  description = "Binds NSGs to target subnets"
  type = map(object({
    subnet_key                = optional(string)
    subnet_id                 = optional(string)
    nsg_key                   = optional(string)
    network_security_group_id = optional(string)
  }))
  default = {}
}

variable "route_tables" {
  description = "User Defined Route (UDR) tables"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    tags                = optional(map(string))
    routes = optional(list(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string # VirtualAppliance, VnetLocal, Internet, None
      next_hop_in_ip_address = optional(string)
    })), [])
  }))
  default = {}
}

variable "subnet_route_table_associations" {
  description = "Binds Route Tables to target subnets"
  type = map(object({
    subnet_key      = optional(string)
    subnet_id       = optional(string)
    route_table_key = optional(string)
    route_table_id  = optional(string)
  }))
  default = {}
}

variable "vnet_peerings" {
  description = "Bi-directional or unidirectional VNet peerings"
  type = map(object({
    name                         = string
    resource_group_name          = string
    vnet_key                     = optional(string)
    virtual_network_name         = optional(string)
    remote_virtual_network_id    = string
    allow_virtual_network_access = optional(bool, true)
    allow_forwarded_traffic      = optional(bool, false)
    allow_gateway_transit        = optional(bool, false)
    use_remote_gateways          = optional(bool, false)
  }))
  default = {}
}
