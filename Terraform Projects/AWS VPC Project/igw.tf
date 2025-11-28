# Configuring the internet gateway for the VPC

resource "aws_internet_gateway" "main_igw" {
    vpc_id = aws_vpc.main_vpc.id    # referencing the VPC created in vpc.tf

    tags = {
        Name = "dev-igw"
    }
}