# configuring private subnets within the VPC

resource "aws_subnet" "private_subnet1" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "10.0.64.0/19"
    availability_zone = "us-east-1a"

    tags = {
        Name = "dev-private-us-east-1a"
    } 
}

resource "aws_subnet" "private_subnet2" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "10.0.96.0/19"
    availability_zone = "us-east-1b"

    tags = {
        Name = "dev-private-us-east-2a"
    }
}