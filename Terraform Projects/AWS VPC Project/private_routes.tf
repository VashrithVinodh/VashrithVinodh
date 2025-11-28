# configuring the private route table for the VPC

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main_vpc.id

    route {
        cidr_block = "0.0.0.0/0" # route for all IPv4 traffic (default)
        nat_gateway_id = aws_nat_gateway.nat.id # referencing the NAT gateway created in nat.tf
    }
    
    tags = {
        Name = "dev-private"
    }
}

# linking the private route table to our private subnets
resource "aws_route_table_association" "private_subnet1" {
    subnet_id = aws_subnet.private_subnet1.id # referencing the private subnet created in private_subnets.tf
    route_table_id = aws_route_table.private.id # referencing the private route table created above
}

resource "aws_route_table_association" "private_subnet2" {
    subnet_id = aws_subnet.private_subnet2.id # referencing the private subnet created in private_subnets.tf
    route_table_id = aws_route_table.private.id # referencing the private route table created above
}