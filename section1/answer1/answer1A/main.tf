# format: "resource_type" "resource_name"
resource "aws_instance" "app_server" {
  # specify arguments here
  ami                         = "ami-0ad522a4a529e7aa8" # EC2 AMI
  instance_type               = "t3.micro"              # EC2 Instance Type
  subnet_id                   = var.tf_workshop_ex1_subnet_id[0]
  vpc_security_group_ids      = var.tf_workshop_ex1_vpc_sg_id

  tags = {
    Name = "[StudentName]-Ex1-App-Server-Instance"
  }
}
