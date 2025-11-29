# configuring our EC2 instances in public and private subnets

resource "aws_instance" "public_instance" {
    ami = "ami-0c02fb55956c7d316" 
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_zone1.id # launching in the public subnet
    vpc_security_group_ids = [aws_security_group.public_sg.id]# associating the public security group

    key_name = "KEY_FILE_NAME" # replace with your key pair name (no .pem extension)

    tags = {
        Name = "public-instance"
    }
}

resource "aws_instance" "private_instance" {
    ami = "ami-0c02fb55956c7d316" 
    instance_type = "t2.micro"
    subnet_id = aws_subnet.private_subnet1.id # launching in the private subnet
    vpc_security_group_ids = [aws_security_group.private_sg.id] # associating the private security group

    key_name = "<KEY_FILE_NAME" # replace with your key pair name

    tags = {
        Name = "private-instance"
    }
}

