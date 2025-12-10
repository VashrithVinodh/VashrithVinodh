# configure the network to have no ports open

# create the vpc
resource "aws_vpc" "zero_trust_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
}

# create the internet gateway and attach it to the VPC
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.zero_trust_vpc.id
}

# create a public subnet for the NAT Gateway
resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.zero_trust_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
}

# create a private subnet for the EC2 instance
resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.zero_trust_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = false
}

# configure NAT to have an elastic IP
resource "aws_eip" "nat_eip" {
    domain = "vpc"

    tags = {
        Name = "zero-trust-nat"
    }
}

# create the NAT gateway in the public subnet
resource "aws_nat_gateway" "nat_gw" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.public_subnet.id
    depends_on = [ aws_internet_gateway.igw ]
}

# create public route table
resource "aws_route_table" "public_route" {
    vpc_id = aws_vpc.zero_trust_vpc.id
    route {
        cidr_block = "0.0.0.0/0" # allow all IPv4 traffic
        gateway_id = aws_internet_gateway.igw.id # route through the internet gateway
    }

    
}

# create the private route table
resource "aws_route_table" "private_route" {
    vpc_id = aws_vpc.zero_trust_vpc.id
    route {
        cidr_block = "0.0.0.0/0" # allow all IPv4 traffic
        nat_gateway_id = aws_nat_gateway.nat_gw.id # route through the NAT gateway
    }
}

# associate the public subnet with the public route table
resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_route.id
}

# associate the private subnet with the private route table
resource "aws_route_table_association" "private" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_route.id
}

# create security group that denies all inbound traffic and allows all outbound traffic
resource "aws_security_group" "zero_trust_sg" {
    name = "zero-trust-sg"
    description = "security group that denies all inbound traffic and allows all outbound traffic"
    vpc_id = aws_vpc.zero_trust_vpc.id

    tags = {
        Name = "zero-trust-sg"
    }

    # deny all inbound traffic (no ingress rules)
    # allow all outbound traffic
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

