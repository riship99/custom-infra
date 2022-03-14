#this resource is for the creation of the jump server
#it have ubuntu ami id and subnet in which the instance should be launched and also the security group
resource "aws_instance" "instance" {
        ami             = "ami-0851b76e8b1bce90b"
        instance_type   = var.instance_type
        key_name        = var.key_name
        availability_zone = var.availability_zone
        subnet_id = var.subnet_id
        vpc_security_group_ids = var.vpc_security_group
        user_data=<<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install httpd -y
                sudo systemctl start httpd
                sudo systemctl enable httpd
                sudo bash -c "echo I am a webserver - terraform!! $(hostname -f). > /var/www/html/index.html"
                EOF
        
        tags = {
                     Name = var.tag
        }
}

        /*locals {
  userdata = <<-USERDATA
                #!/bin/bash
                sudo yum update -y
                sudo yum install httpd -y
                sudo systemctl start httpd
                sudo systemctl enable httpd
                sudo bash -c "echo I am a webserver - terraform!!. > /var/www/html/index.html"
  USERDATA
}
    /*connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }
  provisioner "remote-exec" {
            inline = [
                "sudo yum update -y",
                "sudo yum install httpd -y",
                "sudo systemctl start httpd",
                "sudo systemctl enable httpd",
                //sudo bash -c "echo I am a webserver - terraform!! $(hostname -f). > /var/www/html/index.html"
                "sudo bash -c 'echo I am a webserver - terraform!! $(hostname -f). > /var/www/html/index.html}'"
            ]
        
        }*/