provider "aws" {
  region = "eu-central-1"
  alias  = "pivot"
}

provider "aws" {
  alias  = "central"
  region = "eu-west-1"
}