# AWS VPC with Terraform

## Objective

This project used terraform to create a virtual private network that contained
- A private subnet
- A public subnet
- An isolated subnet
- An internet gateway
- A network address tranlation table

### Skills Learned
- Using terraform to code AWS configurations
- Understanding how to connect public and private subnets to the internet
- How to configure route tables to connect within the network

### Tools Used
- AWS
- Terraform

## Documentation
### Public Subnet
---
Before we can create a VPC, we need to create a subnet. For servers that need to be connected to the internet, we need to create a public subnet then attach an internet gateway to the VPC. We also need to associate an internet gateway with a subnet, which can be done with a route table.  

### Private Subnet
---
There may be situations where you want to connect to the internet but don't want to directly expose virtual machines to the internet, this is where we can use a NAT gateway. The private address is linked with the public address of the NAT gateway, NAT essentially acts as point of connection to the internet. This can be configured with a private route table.

### Isolated Subnet
---
Isolated subnets can be seen in cases with databases, there is no need for access to or from the internet. This type of subnet is rare but secure; however, it requires more infrastructure in general. 

### Security Groups
---
A security group is similar to a virtual firewall, it checks allowed IP addresses, protocols, and port and permits entry. They are also stateful, meaning once a certain traffic is allowed it automatically allows return traffic.

### Procedure
---
1. Setup the provider --> providers.tf
2. Setting version constraints on the providers and terraform --> providers.tf
3. Create the VPC --> vpc.tf
4. Create Subnets --> public_subnets.tf
5. Create Public Route Table --> public_routes.tf
6. Create NAT Gateway --> nat.tf
7. Create Private Subnet --> private_subnets.tf
8. Create Private Route Table --> private_routes.tf
9. Create Isolate Subnet --> isolated_subnet.tf
10. Create Public Security Group --> security_groups.tf
11. Run terraform init
12. Run terraform validate (this checks for errors)
13. Run terraform apply

If we select the VPC we just created and click on the resource map, we can see that everything has been configured correctly.

### Resource Map and EC2 Instances
<img width="1046" height="542" alt="image" src="https://github.com/user-attachments/assets/58d897b0-1a37-4211-8244-f206e13c3f51" />
<img width="1039" height="515" alt="image" src="https://github.com/user-attachments/assets/f4584ccb-bac5-4853-b9ae-3426bd29d3a9" />
<img width="1048" height="554" alt="image" src="https://github.com/user-attachments/assets/268a54d0-3b2b-4392-84a9-082b14dfe26f" />

### Connecting to the instances
---
To ensure that we have properly configured our private and public security groups, we need to create an EC2 server and connect its key pair to our system. Once that's done, we can: 
1. Get the public IP of your public EC2 instance
2. Get the private IP of your private EC2 instance
3. Run ssh -A ec2-user@<PUBLIC_EC2_PUBLIC_IP>
4. Run ssh ec2-user@<PRIVATE_EC2_PRIVATE_IP>
<img width="1044" height="674" alt="image" src="https://github.com/user-attachments/assets/b4e55007-db47-45f1-af6d-4db497d6c872" />







