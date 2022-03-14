resource "aws_launch_configuration" "launch_config" {
        image_id            = var.ami
        instance_type   = var.instancetype
        security_groups = var.securitygroup
        key_name        = var.key_name
        user_data=<<-EOF
                #!/bin/bash
                sudo apt-get update -y
                sudo apt-get install apache2 -y
                sudo systemctl start apache2
                sudo systemctl enable apache2
                sudo bash -c "echo I am a webserver - terraform!! $(hostname -f). > /var/www/html/index.html"
                EOF
       
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

        lifecycle{
        create_before_destroy = true
        
        }
}

/*data "aws_ami" "amzn" {
  most_recent = true
  owners = [ "amazon" ]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
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
}*/