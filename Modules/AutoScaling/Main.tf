#this is the resource for the autoscaling group which will use the 
#launch configuration to create new instance and target group to add the instance to that group
resource "aws_autoscaling_group" "autoscale" {
  
  launch_configuration      = var.launch_conf_id
  vpc_zone_identifier       = var.subnet_list
  
  target_group_arns = var.target_group_arn
  health_check_type ="ELB"
  
  min_size=var.min
  max_size= var.max
  name = var.name

 }
