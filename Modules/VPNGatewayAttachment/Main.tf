resource "aws_vpn_gateway_attachment" "vpn_attachment" {
  vpc_id         = var.custom_vpc_id
  vpn_gateway_id = var.vpn_id
}