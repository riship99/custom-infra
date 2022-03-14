#this resource is for the route tables in the vpc
# it will contain the routes for that particular route table
resource "aws_default_route_table" "example" {
  default_route_table_id = var.custom_vpc_id

  route {
    cidr_block = var.cidr
    gateway_id = var.gateway_id
  }

  tags = {
    Name = "for private-nat"
  }
}