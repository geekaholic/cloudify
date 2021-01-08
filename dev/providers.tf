provider "aws" {
  profile = "default"
  region  = "us-east-1"
  alias   = "use1"
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
  alias   = "usw2"
}
