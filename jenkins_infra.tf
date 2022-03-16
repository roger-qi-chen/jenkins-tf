resource "aws_instance" "jenkins_host" {
  ami                         = var.aw_ami
  instance_type               = "t3.medium"
  associate_public_ip_address = true
  subnet_id                   = data.aws_subnet.ecs_2a.id
  key_name                    = "hammer_jenkins_ssh"
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  user_data                   = file("./user_data.sh")
  tags                        = var.instance_tags
  root_block_device {
    volume_type = "gp2"
    volume_size = "100"
  }
}



resource "aws_key_pair" "jenkins" {
  key_name   = "hammer_jenkins_ssh"
  public_key = file(var.ssh_key)
}

resource "aws_eip_association" "jenkins_eip_assos" {
  instance_id   = aws_instance.jenkins_host.id
  allocation_id = data.aws_eip.jenkins_eip.id
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "security group for jenkins"
  vpc_id      = data.aws_vpc.main.id

  tags = var.instance_tags
}

resource "aws_security_group_rule" "jenkins_sg_irule_http" {
  type        = "ingress"
  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = [data.aws_vpc.main.cidr_block]
  #cidr_blocks = ["0.0.0.0/0"]
  #ipv6_cidr_blocks  = [dat.aws_vpc.main.ipv6_cidr_block]
  security_group_id = aws_security_group.jenkins_sg.id
}


resource "aws_security_group_rule" "jenkins_sg_irule_https" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  #ipv6_cidr_blocks  = [dat.aws_vpc.main.ipv6_cidr_block]
  security_group_id = aws_security_group.jenkins_sg.id
}


resource "aws_security_group_rule" "jenkins_sg_irule_http80" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = [data.aws_vpc.main.cidr_block]
  #cidr_blocks = ["0.0.0.0/0"]
  #ipv6_cidr_blocks  = [dat.aws_vpc.main.ipv6_cidr_block]
  security_group_id = aws_security_group.jenkins_sg.id
}
resource "aws_security_group_rule" "jenkins_sg_irule_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  #ipv6_cidr_blocks  = [dat.aws_vpc.main.ipv6_cidr_block]
  security_group_id = aws_security_group.jenkins_sg.id
}


resource "aws_security_group_rule" "jenkins_sg_erule" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  #ipv6_cidr_blocks  = [dat.aws_vpc.main.ipv6_cidr_block]
  security_group_id = aws_security_group.jenkins_sg.id
}

resource "aws_ebs_volume" "jenkins_volume_ebs" {
  availability_zone = var.aw_az
  size              = "50"
  type              = "gp2"
  tags              = var.instance_tags
  lifecycle {
    prevent_destroy = true
  }

}
resource "aws_volume_attachment" "jenkins_volume_ebs_att" {
  device_name = "/dev/sdh"  #name seen in ebs volume, in ec2 it is "/dev/nvme1n1" 
  volume_id   = aws_ebs_volume.jenkins_volume_ebs.id
  instance_id = aws_instance.jenkins_host.id
}