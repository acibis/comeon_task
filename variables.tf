variable "aws_region" {
  description = "AWS region"
  default     = "eu-central-1"
}

variable "availability_zone" {
  description = "AWS availability zone"
  default     = "eu-central-1a"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
  description = "CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}

variable "locations" {
  type = map(any)

  default = {
    eu = {
      network = ["10.200.249.0/24"]
      descr   = "customer network in Ireland"
    }

    jp = {
      network = ["10.200.251.0/24", "10.200.252.0/24"]
      descr   = "customer network in Japan"
    }
  }
}

variable "devops_ips" {
  type    = list(string)
  default = ["1.2.3.4/32"]
}

variable "database_ip" {
  description = "ip of a database the app stores data"
  default     = "1.2.3.4/32"
}

variable "instance_ami" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-0233214e13e500f77"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.nano"
}
