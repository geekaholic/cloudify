# variable.tf
variable "ns_prefix_use1" {
  description = "Name space prefix used to uniquely create resources"
}

variable "github_token" {
  description = "Github OAuth token"
}

variable "github_owner" {}
variable "github_repo" {}
variable "github_branch" {}

variable "aws_creds" {
  type = map(any)
}
