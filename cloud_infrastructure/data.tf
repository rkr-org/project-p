# Way to fetch vpc and subnets id's with data resources
data "aws_vpc" "this" {
  tags       = {
    "environment" = "dev"
    "Name"        = "${var.environment}-vpc"
  }
}

data "aws_subnets" "private" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
  tags = {
    "environment" = var.environment
    "type"        = "private"
    "Name"        = "${var.environment}-private-subnet*"
  }
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

data "aws_subnets" "public" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
  tags = {
    "environment" = var.environment
    "type"        = "public"
    "Name"        = "${var.environment}-public-subnet*"
  }
}

data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}

locals {
  vpc_id = data.aws_vpc.this.id
  private_subnets = data.aws_subnets.private.ids
  public_subnets = data.aws_subnets.public.ids
  private_subnet_cidr_blocks = [for subnet in data.aws_subnet.private : subnet.cidr_block]
  public_subnet_cidr_blocks = [for subnet in data.aws_subnet.public : subnet.cidr_block]
}
