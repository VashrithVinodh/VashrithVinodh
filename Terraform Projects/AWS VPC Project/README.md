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

### Procedure
---
1. Setup the provider --> providers.tf
2. Setting version constraints on the providers and terraform --> providers.tf
3. Create the VPC --> vpc.tf
4. Create Subnets --> public_subnets.tf
5. Create Public Route Table --> public_routes.tf
6. Create NAT Gateway --> nat.tf
7. Create Private Subnet
8. Create Private Route Table --> private_routes.tf
9. Create Isolate Subnet --> isolated_subnet.tf
10. Run terraform init
11. Run terraform validate (this checks for errors)
12. Run terraform apply
If we select the VPC we just created and click on the resource map, we can see that everything has been configured correctly.

### Resource Map
<img width="1394" height="484" alt="image" src="https://github.com/user-attachments/assets/1c680b2c-91a8-44f7-9bf6-ac8243c24d45" />
<img width="1373" height="441" alt="image" src="https://github.com/user-attachments/assets/76dcbc59-1b4f-422d-8f99-ddc616094723" />




