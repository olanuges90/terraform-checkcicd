provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "default"
  region = "us-east-1"
}
