# Security Group for webserver
resource "aws_security_group" "webserver-security-group" {
  name        = "Webserver SG"
  description = "Allow HTTP,ICMP & SSH access on Port 80,(0-65535), & 22"
  vpc_id      = aws_vpc.awslab-vpc.id

  ingress {
    description = "HTTP Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP Access"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "awslab webserver"
  }
}



# Security Group for the database Server
resource "aws_security_group" "database-security-group" {
  name        = "Database SG"
  description = "Allow CUSTOM,ICMP,& SSH access on Port 3110,(0-65535), & 22"
  vpc_id      = aws_vpc.awslab-vpc.id


  ingress {
    description = "CUSTOM Access"
    from_port   = 3110
    to_port     = 3110
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/24"]
  }

  ingress {
    description = "ICMP Access"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "awslab Database"
  }
}
