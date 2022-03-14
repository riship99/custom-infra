output "subnet_id" {
    value = aws_subnet.subnets.id
}
output "subnet_name" {
    value = aws_subnet.subnets.tags
}