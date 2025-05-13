provider "aws" {
    region = "ap-south-1"
}

module "network" {
  source = "./modules/network"
  region = var.region
}
