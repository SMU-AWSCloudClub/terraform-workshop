# format: "resource_type" "resource_name" { resource_arguments }

# Example
resource "aws_instance" "app_server" {
  # specify arguments here
  ami                         = "ami-0ad522a4a529e7aa8"
  instance_type               = "t3.small" # EC2 Instance Type
  subnet_id                   = var.tf_workshop_ex1_subnet_id
  vpc_security_group_ids      = [var.tf_workshop_ex1_vpc_sg_id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.student_id}-Ex1-EC2-Instance"
  }
}
