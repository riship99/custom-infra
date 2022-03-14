variable "launch_conf_id" {
    type = string
  
}
variable "subnet_list" {
    type = list
}
variable "target_group_arn" {
    type = list
  
}
variable "name" {
    type = string
}
variable "min" {
    type = number
}
variable "max" {
    type = number
}