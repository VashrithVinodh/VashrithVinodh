# converts private IP addresses to public IP addresses for outbound traffic

# elastic IP for the NAT gateway
resource "aws_eip" "nat" {
    domain = "vpc"

    tags = {
        Name = "dev-nat"
    }
}

resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat.id  # referencing the elastic IP created above
    subnet_id = aws_subnet.public_zone1.id  # placing the NAT gateway in a public subnet

    tags = {
        Name = "dev-nat"
    }

    depends_on = [ aws_internet_gateway.main_igw ]
}