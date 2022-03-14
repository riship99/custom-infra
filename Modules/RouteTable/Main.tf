resource "aws_route_table" "route-table" {
  vpc_id = var.custom_vpc_id

  route{
      cidr_block = var.ipv4_cidr
      gateway_id = var.gatewayid
    }
  

  tags = {
    Name = var.tag
  }
}