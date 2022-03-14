#this is the resource for loadbalancer with the subnets and security groups to be attached with it
resource "aws_lb" "custom_loadbalancer" {
  name               = "CustomLoadbalancer"
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  subnets            = var.subnet_list
  security_groups    = var.security_group_list
   

  enable_deletion_protection = false

}