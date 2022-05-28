provider "aws" {
    region = "ap-southeast-2"
    access_key = "AKIAYNYRUPXLI3P47HHZ"
    secret_key = "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"
}

resource "aws_vpc" "lam_tf_vpc" {
    cidr_block       = "10.1.0.0/16"
    instance_tenancy = "default"

    tags = {
        Name = "VPC_Oz_TF"
    }
}

resource "aws_subnet" "lam_tf_pub_subnet1" {
    vpc_id = aws_vpc.lam_tf_vpc.id
    cidr_block = "10.1.1.0/24"

    tags = {
        Name = "Pub_subnet_1_Oz_TF"
    }
}

resource "aws_subnet" "lam_tf_pri_subnet1" {
    vpc_id = aws_vpc.lam_tf_vpc.id
    cidr_block = "10.1.10.0/24"

    tags = {
        Name = "Pri_subnet_1_Oz_TF"
    }
}

resource "aws_internet_gateway" "lam_igw_tf" {
  vpc_id = aws_vpc.lam_tf_vpc.id

  tags = {
    Name = "igw_Oz_TF"
  }
}

resource "aws_route_table" "pub_route" {
  vpc_id = aws_vpc.lam_tf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lam_igw_tf.id
  }

  tags = {
      Name = "lam_pub_rt_TF"
  }
}

resource "aws_route_table_association" "pub_route_asso" {
  subnet_id      = aws_subnet.lam_tf_pub_subnet1.id
  route_table_id = aws_route_table.pub_route.id
}

resource "aws_route_table" "pri_route" {
  vpc_id = aws_vpc.lam_tf_vpc.id

  tags = {
      Name = "lam_pri_rt_TF"
  }

}

resource "aws_route_table_association" "pri_route_asso" {
  subnet_id      = aws_subnet.lam_tf_pri_subnet1.id
  route_table_id = aws_route_table.pri_route.id
}

resource "aws_main_route_table_association" "default_route_lam_tf" {
  vpc_id         = aws_vpc.lam_tf_vpc.id
  route_table_id = aws_route_table.pri_route.id
}