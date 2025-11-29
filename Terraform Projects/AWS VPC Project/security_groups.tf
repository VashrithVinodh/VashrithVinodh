# configuring our public and private security groups

# security group for public subnet allowing host machine access
resource "aws_security_group" "public_sg" {
    name = "allow_host"
    description = "security group for public subnet allowing host machine access"
    vpc_id = aws_vpc.main_vpc.id

    tags = {
        Name = "public-sg"
    }

    # this allows the host IP address to access instances in the public subnet via SSH
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["HOST_IP_ADDRESS"] # should be your host machine's public IP
    }

    # this allows all outbound traffic from instances in the public subnet
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


# security group for private subnet allowing web traffic from public subnet
resource "aws_security_group" "private_sg" {
    name = "allow-public-sg"
    description = "security group for private subnet that allows traffic from public subnet"
    vpc_id = aws_vpc.main_vpc.id

    tags = {
        Name = "private-sg"
    }

    # this allows inbound SSH traffic from the public security group to the private security group
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [aws_security_group.public_sg.id]
    }
}
