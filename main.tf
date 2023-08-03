terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {}

variable "region" {
  type    = string
  default = "sfo3"
}

variable "droplet_count" {
  type    = number
  default = 1
}

variable "droplet_size" {
  type    = string
  default = "s-1vcpu-1gb"
}

provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "default" {
  name = "terraform"
}

resource "digitalocean_droplet" "web" {
  count    = var.droplet_count
  image    = "ubuntu-22-04-x64"
  name     = "web-${var.region}-${count.index + 1}"
  region   = var.region
  size     = var.droplet_size
  ssh_keys = [data.digitalocean_ssh_key.default.id]

  lifecycle {
    create_before_destroy = true
  }
}

output "server_ip" {
  value = digitalocean_droplet.web.*.ipv4_address
}
