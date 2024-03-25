provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "summary-ex-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "summary-ex-subnet" {
  vpc_id                  = aws_vpc.summary-ex-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "summary-ex-sg" {
  name   = "summary-ex-sg"
  vpc_id = aws_vpc.summary-ex-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "summary-ex-instance" {
  ami                    = "ami-07d9b9ddc6cd8dd30"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.summary-ex-subnet.id
  vpc_security_group_ids = [aws_security_group.summary-ex-sg.id]

  tags = {
    Name = "summary-ex-instance"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install docker.io -y",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo usermod -aG docker ubuntu",
      "sudo docker pull devoops93/todo-app:latest",  # Replace with your Docker image
      "sudo docker run -d devoops93/todo-app:latest" # Replace with your Docker image
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/id_rsa") # Replace with the path to your private key
      host        = self.public_ip
    }
  }
}



output "public_ip" {
  value = aws_instance.summary-ex-instance.public_ip
}
# provider "aws" {
#   region = "us-east-1"
# }

# resource "aws_vpc" "summary-ex-vpc" {
#   cidr_block = "10.0.0.0/16"
# }

# resource "aws_subnet" "summary-ex-subnet" {
#   vpc_id     = aws_vpc.summary-ex-vpc.id
#   cidr_block = "10.0.1.0/24"
# }

# resource "aws_launch_configuration" "summary-ex-instance" {
#   name          = "example"
#   image_id      = "ami-07d9b9ddc6cd8dd30"
#   instance_type = "t2.micro"
# }

# resource "aws_autoscaling_group" "summary-ex-autoscaling" {
#   launch_configuration = aws_launch_configuration.summary-ex-instance.id
#   min_size             = 1
#   max_size             = 2
#   desired_capacity     = 1
#   vpc_zone_identifier  = [aws_subnet.summary-ex-subnet.id]

#   tag {
#     key                 = "Name"
#     value               = "summary-ex-instance"
#     propagate_at_launch = true
#   }
# }

# data "aws_instances" "summary-ex-instances" {
#   instance_tags = {
#     Name = "summary-ex-instance"
#   }
# }

# output "public_ips" {
#   value = data.aws_instances.summary-ex-instances.public_ips
# }
