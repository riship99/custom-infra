output "ec2_id" {
    value = aws_instance.instance.id
  
}
output "jump_public_ip" {
    value = aws_instance.instance.public_ip
}