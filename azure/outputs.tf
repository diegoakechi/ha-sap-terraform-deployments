# Outputs:
# - Private IP
# - Public IP
# - Private node name
# - Public node name

# iSCSI server

data "azurerm_public_ip" "iscsisrv" {
  name                = azurerm_public_ip.iscsisrv.name
  resource_group_name = azurerm_virtual_machine.iscsisrv.resource_group_name
}

data "azurerm_network_interface" "iscsisrv" {
  name                = azurerm_network_interface.iscsisrv.name
  resource_group_name = azurerm_virtual_machine.iscsisrv.resource_group_name
}

output "iscsisrv_ip" {
  value = [data.azurerm_network_interface.iscsisrv.private_ip_address]
}

output "iscsisrv_public_ip" {
  value = [data.azurerm_public_ip.iscsisrv.ip_address]
}

output "iscsisrv_name" {
  value = [azurerm_virtual_machine.iscsisrv.name]
}

output "iscsisrv_public_name" {
  value = [data.azurerm_public_ip.iscsisrv.fqdn]
}

# Cluster nodes

data "azurerm_public_ip" "hananodes" {
  count = var.ninstances
  name  = element(azurerm_public_ip.hananodes.*.name, count.index)
  resource_group_name = element(
    azurerm_virtual_machine.hananodes.*.resource_group_name,
    count.index,
  )
}

data "azurerm_network_interface" "hananodes" {
  count = var.ninstances
  name  = element(azurerm_network_interface.hananodes.*.name, count.index)
  resource_group_name = element(
    azurerm_virtual_machine.hananodes.*.resource_group_name,
    count.index,
  )
}

output "cluster_nodes_ip" {
  value = data.azurerm_network_interface.hananodes.*.private_ip_address
}

output "cluster_nodes_public_ip" {
  value = data.azurerm_public_ip.hananodes.*.ip_address
}

output "cluster_nodes_name" {
  value = azurerm_virtual_machine.hananodes.*.name
}

output "cluster_nodes_public_name" {
  value = data.azurerm_public_ip.hananodes.*.fqdn
}

# Monitoring

data "azurerm_public_ip" "monitoring" {
  count               = var.monitoring_enabled == true ? 1 : 0
  name                = azurerm_public_ip.monitoring.0.name
  resource_group_name = azurerm_virtual_machine.monitoring.0.resource_group_name
}

data "azurerm_network_interface" "monitoring" {
  count               = var.monitoring_enabled == true ? 1 : 0
  name                = azurerm_network_interface.monitoring.0.name
  resource_group_name = azurerm_virtual_machine.monitoring.0.resource_group_name
}

output "monitoring_ip" {
  value = join("", data.azurerm_network_interface.monitoring.*.private_ip_address)
}

output "monitoring_public_ip" {
  value = join("", data.azurerm_public_ip.monitoring.*.ip_address)
}

output "monitoring_name" {
  value = join("", azurerm_virtual_machine.monitoring.*.name)
}

output "monitoring_public_name" {
  value = join("", data.azurerm_public_ip.monitoring.*.fqdn)
}

# drbd

output "drbd_ip" {
  value = module.drbd_node.drbd_ip
}

output "drbd_public_ip" {
  value = module.drbd_node.drbd_public_ip
}

output "drbd_name" {
  value = module.drbd_node.drbd_name
}

output "drbd_public_name" {
  value = module.drbd_node.drbd_public_name
}
