resource "aws_subnet" "subnets" {
  vpc_id = var.custom_vpc_id
  cidr_block = var.subnet_cidr
  availability_zone = var.az
  map_public_ip_on_launch = var.public_ip_launch_bool
  
  tags = {
    Name = var.tag
  }
}