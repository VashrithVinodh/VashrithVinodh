# generally used for load balancers or public facing resources

resource "aws_subnet" "public_zone1" {
    vpc_id = aws_vpc.main_vpc.id    # referencing the VPC created in vpc.tf
    cidr_block = "10.0.0.0/19"  # must be a subset of the VPC cidr block
    availability_zone = "us-east-1a"  # specify the availability zone in our region
    map_public_ip_on_launch = true # auto assign public IPs to instances launched in this subnet

    tags = {
        Name = "dev-public-us-east-1a"
    }
}

resource "aws_subnet" "public_zone2" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "10.0.32.0/19" # must be a subset of the VPC cidr block and different from other subnets
    availability_zone = "us-east-1b" # have different availability zones for redundancy
    map_public_ip_on_launch = true

    tags = {
        Name = "dev-public-us-east-1b"
    }
}