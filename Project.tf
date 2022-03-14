#creation of vpc with appropriate CIDR value
module "vpc" {
    source = "./Modules/VPC"
    vpc_cidr_block = "10.0.0.0/24"
    vpc_tag = "Custom VPC"
    
}
#creating and attaching internet gateway to the vpc
module "igw" {
    source = "./Modules/IGW"
    custom_vpc_id = module.vpc.custom_vpc_id
    tag = "Internet Gateway"
}
#creating subnets as per the requirement with specific CIDR range
#here i have created total 7 subnets- 4 private subnets and 3 public subnets
module "public_sub_1_az1" {
    source = "./Modules/Subnet"
    custom_vpc_id = module.vpc.custom_vpc_id
    subnet_cidr = "10.0.0.0/28"
    az = "ap-south-1a"
    public_ip_launch_bool = true
    tag = "public subnet in az1 "
}

#keeping the public_ip_launch_bool falg to false for ptivate subnets
module "private_sub_1_az1" {
source = "./Modules/Subnet"    
    custom_vpc_id = module.vpc.custom_vpc_id
    subnet_cidr = "10.0.0.16/28"
    az = "ap-south-1a"
    public_ip_launch_bool = false
    tag = "private subnet 1 in az1 "
}
module "private_sub_2_az1" {
source = "./Modules/Subnet"
    custom_vpc_id = module.vpc.custom_vpc_id
    subnet_cidr = "10.0.0.32/28"
    az = "ap-south-1a"
    public_ip_launch_bool = false
    tag = "private subnet 2 in az1 "
}
module "public_jump_sub_1_az1" {
source = "./Modules/Subnet"
    custom_vpc_id = module.vpc.custom_vpc_id
    subnet_cidr = "10.0.0.48/28"
    az = "ap-south-1a"
    public_ip_launch_bool = true
    tag = "public jump subnet in az1 "
}
module "public_sub_1_az2" {
source = "./Modules/Subnet"
    custom_vpc_id = module.vpc.custom_vpc_id
    subnet_cidr = "10.0.0.64/28"
    az = "ap-south-1b"
    public_ip_launch_bool = true
    tag = "public subnet in az2 "
}
module "private_sub_1_az2" {
source = "./Modules/Subnet"
    custom_vpc_id = module.vpc.custom_vpc_id
    subnet_cidr = "10.0.0.80/28"
    az = "ap-south-1b"
    public_ip_launch_bool = false
    tag = "private subnet 1 in az2 "
}
module "private_sub_2_az2" {
source = "./Modules/Subnet"
    custom_vpc_id = module.vpc.custom_vpc_id
    subnet_cidr = "10.0.0.96/28"
    az = "ap-south-1b"
    public_ip_launch_bool = false
    tag = "private subnet 2 in az2 "
}
#creating the security group that allows traffic from http and ssh from anywhere
#we can add another security group for loadbalancer
module "sg_allow_web" {
    source = "./Modules/SecurityGroup"


    custom_vpc_id = module.vpc.custom_vpc_id
    sgname = "allow web traffic"
    
    tag = "Allow Web traffic"
    #ingress_cidr = ["${module.jumpserver.jump_public_ip}/32"]

}

#creating the jump server in the public subnet which will let us connect to the private instances
module "jumpserver" {
    source = "./Modules/EC2Instance"
    ami = "ami-0851b76e8b1bce90b"
    instance_type = "t2.micro"
    availability_zone = "ap-south-1a"
    key_name = "new_key"
    subnet_id = module.public_jump_sub_1_az1.subnet_id
    vpc_security_group = [module.sg_allow_web.security_grp_id]
    tag = "public jump server"
    
}

    
#creating eip in az-1 for the nat creation ( depends on =internet gateway is compulsory for the eip creation)
module "eip_for_nat1" {
    source = "./Modules/EIP"
    vpc_bool = true
    depends_on = [
      module.igw
    ]
    
}

#creating the nag gateway with eip as allocation id in the public subnet of both az's
#depends_on[internet gateway] is compulsory for the nat gaateway 
module "nat_gateway_az1" {
    source = "./Modules/NATGateway"
    eip_id = module.eip_for_nat1.eip_id
    subnet_id_for_eip = module.public_sub_1_az1.subnet_id
    tags = "Nat Gateway in az 1"
    depends_on = [
      module.igw
    ]
   
}

#public route table in az-1 which will contain the igw route 
module "public_route_table_az1" {
    source = "./Modules/RouteTable"
    custom_vpc_id = module.vpc.custom_vpc_id
    ipv4_cidr = "0.0.0.0/0"
    gatewayid = module.igw.igw_id
    tag = "public route table"
}

#associating the public subnets in az-1 with the route table in az-1
module "public_subnet_asso_in_az1" {
    source = "./Modules/RouteTableAssociation"
    subnet_id = module.public_sub_1_az1.subnet_id
    route_table_id = module.public_route_table_az1.route_table_id

}


module "public_jump_subnet_asso_in_az1" {
    source = "./Modules/RouteTableAssociation"
    subnet_id = module.public_jump_sub_1_az1.subnet_id
    route_table_id = module.public_route_table_az1.route_table_id
}

module "public_subnet_asso_in_az2" {
    source = "./Modules/RouteTableAssociation"
    subnet_id = module.public_sub_1_az2.subnet_id
    route_table_id = module.public_route_table_az1.route_table_id
}
#public route table in az-1 which will contain the nat gateway route

module "private_route_table_az1" {
    source = "./Modules/RouteTable"
    custom_vpc_id = module.vpc.custom_vpc_id
    ipv4_cidr = "0.0.0.0/0"
    gatewayid = module.nat_gateway_az1.nat_id
    tag = "private route table"
}

#associating the private subnets in az-1 with the private route table in az-1
module "private_subnet1_asso_in_az1" {
    source = "./Modules/RouteTableAssociation"
    subnet_id = module.private_sub_1_az1.subnet_id
    route_table_id = module.private_route_table_az1.route_table_id
}
module "private_subnet2_asso_in_az1" {
    source = "./Modules/RouteTableAssociation"
    subnet_id = module.private_sub_2_az1.subnet_id
    route_table_id = module.private_route_table_az1.route_table_id
}

module "private_subnet1_asso_in_az2" {
    source = "./Modules/RouteTableAssociation"
    subnet_id = module.private_sub_1_az2.subnet_id
    route_table_id = module.private_route_table_az1.route_table_id
}
module "private_subnet2_asso_in_az2" {
    source = "./Modules/RouteTableAssociation"
    subnet_id = module.private_sub_2_az2.subnet_id
    route_table_id = module.private_route_table_az1.route_table_id
}

#creating a loadbalancer to witch the traffic between instances in different az's
module "alb_for_instances" {
    source = "./Modules/ALB"
    subnet_list = [     module.private_sub_1_az1.subnet_id,
                        module.private_sub_1_az2.subnet_id,
                  ]
    security_group_list = [module.sg_allow_web.security_grp_id]    
}

#creating a launch_configuration for the autoscaling group to create new instances if the previous one's gets unhealthy 
module "launch_configuration" {
    source = "./Modules/LaunchConfiguration"
    ami = "ami-0851b76e8b1bce90b"
    
    instancetype = "t2.micro"
    key_name = "new_key"
    securitygroup = [module.sg_allow_web.security_grp_id]

    
}
#creating a target group in the vpc and after that in the autoscaling group use this target group
#it will contain the health checks and instance thresholds in the resource section
module "target_group" {
    source = "./Modules/TargetGroup"
    custom_vpc_id = module.vpc.custom_vpc_id
  
}
#creating an autoscaling group which will use two subnets in different az's
#also, it will select the already created target group
module "asg" {
    source = "./Modules/AutoScaling"
    launch_conf_id = module.launch_configuration.launch_conf_id
    subnet_list =     [module.private_sub_1_az1.subnet_id,
                        module.private_sub_1_az2.subnet_id]
    target_group_arn = [module.target_group.target_group_arn]
    min = 2
    max = 2
    name ="instance"
}
#creating a aws_lb_listener to forward the traffic coming to the load balancer to target group
module "lb_listener" {
    source = "./Modules/LBListener"
    lb_arn = module.alb_for_instances.lb_id
    target_group_arn = module.target_group.target_group_arn
    
}