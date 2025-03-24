variable "provider-region" {
  type   = string
}
variable "vpc-range" {
  type = string
}
variable "vpc-name" {
  type = string
}
variable "instance_tenancy" {
  type = string
}
variable "enable_dns_hostnames" {
  type = bool
}
variable "enable_dns_support" {
  type = bool
}
variable "cidr" {
  type        = list(string)
}

variable "availability_zones" {
  type        = list(string)
}
variable "tags" {
  type        = list(string)
}
variable "map_public_ip_on_launch" {
  type = bool
}
variable "igw_name" {
  type = string
}

variable "private_route_table_name" {
  type = string
}
variable "public_route_table_name" {
  type = string
}
variable "nat_gateway_name" {
  type = string
}
variable "custom-vpc-sg" {
  type = string
}
variable "cidr_block" {
  type = string
}
