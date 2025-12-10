

# getting the latest amazon linux 3 ami
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    # This specific wildcard finds the standard x86 version
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# the zero trust server
resource "aws_instance" "zero_trust_server" {
    ami = data.aws_ami.amazon_linux_2023.id
    instance_type = "t2.micro"

    # network: placing it in the private subnet
    subnet_id = aws_subnet.private_subnet.id

    # security: attaching the "no ports" security group
    vpc_security_group_ids = [aws_security_group.zero_trust_sg.id]

    # identity: attaching the IAM role
    iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

    tags = {
        Name = "zero_trust_server"
    }
}

# output the zero trust server's ID (needed to connect to the server)
output "zero_trust_server_id" {
    value = aws_instance.zero_trust_server.id
}