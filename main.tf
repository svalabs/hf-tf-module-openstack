variable "public_key" {}
variable "image" {}
variable "name" {}
variable "cloud-config" {}

variable "os_username" {}
variable "os_password" {}
variable "os_tenant" {}
variable "os_auth_url" {}

variable "os_network" {}
variable "os_flavor_id" {}

terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.48.0"
    }
  }
}

#Configure the OpenStack Cloud Provider
provider "openstack" {
  user_name		= var.os_username
  password		= var.os_password
  auth_url		= var.os_auth_url
  tenant_name = var.os_tenant
}

# Create a new SSH key
resource "openstack_compute_keypair_v2" "key" {
  name       = "${var.name}-key"
  public_key = var.public_key
}

resource "openstack_compute_instance_v2" "basic" {
  name            = var.name
  image_id        = var.image
  flavor_id       = var.os_flavor_id
  key_pair        = "${var.name}-key"
  
  user_data = var.cloud-config

  network {
    name = var.os_network
  }
}

output "private_ip" {
  value = openstack_compute_instance_v2.basic.access_ip_v4
}

output "public_ip" {
  value = openstack_compute_instance_v2.basic.access_ip_v4
}

output "hostname" {
  value = openstack_compute_instance_v2.basic.name
}
