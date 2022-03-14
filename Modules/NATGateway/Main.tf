# module "igw" {
#     source = "../IGW"
    
# }

resource "aws_nat_gateway" "NAT" {
  allocation_id = var.eip_id
  subnet_id     = var.subnet_id_for_eip
  tags = {
    Name = var.tags
  }

  //depends_on = [module.igw]
}