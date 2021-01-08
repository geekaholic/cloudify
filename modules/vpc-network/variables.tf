# Module: vpc-network/variable.tf

variable "cidr_block" {
  description = "CIDR of network"
}

variable "vpc_tag_name" {
  description = "VPC tag"
}

variable "az_count" {
  type = number
  description = "Number of AZs within VPC"
  default = 1
}
