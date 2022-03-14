resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = var.custom_vpc_id

  tags = {
    Name = "main"
  }
}