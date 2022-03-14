resource "aws_vpc_endpoint" "s3" {
  
  vpc_id       = var.custom_vpc_id
  service_name = var.service_name

  tags = {
      name = var.tags
  }
}
//vpc endpoint subnet or routetable association