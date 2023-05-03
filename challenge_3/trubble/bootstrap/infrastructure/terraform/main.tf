data "aws_availability_zones" "available" {}

resource "aws_key_pair" "deployer" {
  for_each = local.allowed_keys
  key_name   = each.key
  public_key = each.value
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "devops-challenge"

  enable_nat_gateway  = false
  create_database_subnet_group = false
  enable_vpn_gateway = false
  manage_default_vpc               = false
  manage_default_security_group = false
  manage_default_network_acl = false
  manage_default_route_table = false

  public_subnets  = ["10.0.101.0/24"]

  azs             = [data.aws_availability_zones.available.names[0]]
}


resource "aws_security_group" "allow_http" {
  name        = "devops-challenge-allow-http"
  description = "Allow HTTP traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "devops-challenge-allow-http"
  }
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_id" {
  value = module.vpc.public_subnets[0]
}

output "security_group_id" {
  value = aws_security_group.allow_http.id
}