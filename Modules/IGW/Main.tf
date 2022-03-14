resource "aws_internet_gateway" "igw" {
  vpc_id = var.custom_vpc_id
  tags = {
    Name = var.tag
  }
}