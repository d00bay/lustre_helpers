variable "region" {}

variable "availability_zone" {}

variable "instance_type" {
  default = "m6i.xlarge"
}

variable "boot_disk_size_gb" {
  default = 100
}

variable "fsname" {
  default = "lustrefs"
}

variable "cluster_subnet_cidr" {
  default = "10.10.0.0/24"
}

variable "mdt_disk_size_gb" {
  default = 80
}

variable "ost_disk_size_gb" {
  default = 100
}

variable "oss_count" {
  type    = number
  default = 4
}

variable "client_count" {
  type    = number
  default = 4
}

variable "admin_cidr" {
  description = "CIDR allowed to SSH into the lab, usually your public IP with /32"

  type = string
}

variable "public_key_path" {
  description = "Absolute path to the SSH public key used for EC2"
  type        = string
}

