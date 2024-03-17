
# flatten location variable to a list
locals {
  clients = toset(flatten([for loc in values(var.locations) : loc.network]))
}


# create necessary resources such as VPC, subnet, igw etc
resource "aws_vpc" "my_comeon_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = merge(local.tags, {
    Name = "my_comeon_vpc"
  })
}

resource "aws_subnet" "my_comeon_public_subnet" {
  vpc_id            = aws_vpc.my_comeon_vpc.id
  cidr_block        = var.public_subnet_cidr_block
  availability_zone = var.availability_zone

  tags = merge(local.tags, {
    Name = "my_comeon_public_subnet"
  })
}

resource "aws_internet_gateway" "my_comeon_ig" {
  vpc_id = aws_vpc.my_comeon_vpc.id

  tags = merge(local.tags, {
    Name = "my_comeon_ig"
  })
}

resource "aws_route_table" "my_comeon_public_rt" {
  vpc_id = aws_vpc.my_comeon_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_comeon_ig.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.my_comeon_ig.id
  }

  tags = merge(local.tags, {
    Name = "my_comeon_public_rt"
  })
}

resource "aws_route_table_association" "my_comeon_public_1_rt_a" {
  subnet_id      = aws_subnet.my_comeon_public_subnet.id
  route_table_id = aws_route_table.my_comeon_public_rt.id
}

resource "aws_security_group" "my_comeon_ec2_sg" {
  name   = "HTTP and SSH"
  vpc_id = aws_vpc.my_comeon_vpc.id

  # access from the client's subnets
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = local.clients
  }

  # access from devops's subnets
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.devops_ips
  }

  # access to the client's subnets
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = local.clients
  }

  # access to the database
  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.database_ip]
  }
}

# an EC2 to host application
# attention, an instance needs a key, the key was not created here
resource "aws_instance" "my_comeon_web_instance" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  key_name      = "comeon_key"

  subnet_id                   = aws_subnet.my_comeon_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.my_comeon_ec2_sg.id]
  associate_public_ip_address = true

  tags = merge(local.tags, {
    Name = "my_comeon_web_instance"
  })
}


