provider "aws" {
  version = "~> 2.49"
  region  = "ap-northeast-1" # Tokyo
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "eks-demo-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name"                                      = "terraform-eks-demo-node"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

resource "aws_subnet" "eks-demo-subnet" {
  count = 2

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet(aws_vpc.eks-demo-vpc.cidr_block, 8, count.index)
  vpc_id            = aws_vpc.eks-demo-vpc.id

  tags = {
    "Name"                                      = "terraform-eks-demo-node"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

resource "aws_internet_gateway" "eks-demo-gw" {
  vpc_id = aws_vpc.eks-demo-vpc.id

  tags = {
    "Name" = var.cluster-name
  }
}

resource "aws_route_table" "eks-demo-rt" {
  vpc_id = aws_vpc.eks-demo-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks-demo-gw.id
  }
}

resource "aws_route_table_association" "eks-demo-rta" {
  count = 2

  subnet_id      = aws_subnet.eks-demo-subnet[count.index].id
  route_table_id = aws_route_table.eks-demo-rt.id
}
