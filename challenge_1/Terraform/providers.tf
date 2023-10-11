provider "aws" {
region     = "eu-west-1" #desired AWS region

  default_tags {
    tags = {
      Category  = "TechTest"
    }
  }
}
