terraform {
  cloud {
    organization = "rishikesh-Dev"

    workspaces {
      name = "Terraforminfra"
    }
  }
}
provider "aws" {
    region = "ap-south-1"
  
}