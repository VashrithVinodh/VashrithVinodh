# configuring our route table for public subnets to allow internet access
# also connecting the route table to our public subnets

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main_vpc.id

    route {
        cidr_block = "0.0.0.0/0" # route for all IPv4 traffic (default)
        gateway_id = aws_internet_gateway.main_igw.id # referencing the internet gateway created in igw.tf
    }

    tags = {
        Name = "dev-public"
    }
}

resource "aws_route_table_association" "public_zone1" {
    subnet_id = aws_subnet.public_zone1.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_zone2" {
    subnet_id = aws_subnet.public_zone2.id
    route_table_id = aws_route_table.public.id
}