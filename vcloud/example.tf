# Configure the VMware vCloud Director Provider
provider "vcd" {
user = "xxx"
org = "xxx"
password = "xxx"
vdc = "xxx"
url = "https://xxx/api"
allow_unverified_ssl = "true"
}
 
variable "mgt_net_cidr" { default = "10.10.0.0/24" }
 
# Create our networks
resource "vcd_network" "mgmt_net" {
name = "Management Network"
edge_gateway = "Datacenter Gateway"
gateway = "${cidrhost(var.mgt_net_cidr, 1)}"
static_ip_pool {
start_address = "${cidrhost(var.mgt_net_cidr, 10)}"
end_address = "${cidrhost(var.mgt_net_cidr, 200)}"
}
}
 
resource "vcd_vapp" "vapp01" {
name = "Alex_vApp_01"
power_on = false
}
 
resource "vcd_vapp_vm" "vm01" {
vapp_name = "${vcd_vapp.vapp01.name}"
name = "alextest01"
depends_on = ["vcd_vapp.vapp01"]
catalog_name = "IMAGES"
template_name = "Photon OS 2.0"
memory = 2048
cpus = 1
network_name = "${vcd_network.mgmt_net.name}"
ip = "${cidrhost(var.mgt_net_cidr, 100)}"
}
