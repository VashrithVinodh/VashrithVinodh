# Zero Trust Cloud Architecture (AWS SSM)

## Objective
---
This project implements a **Zero Trust Network Access (ZTNA)** architecture on AWS. Unlike traditional "Bastion Host" setups that rely on open ports (SSH/22) and static keys, this environment relies entirely on **Identity-Based Authentication**. The target server is deployed in a deep private subnet with **zero inbound ports** open, making it invisible to external port scanners. Administration is performed via an encrypted tunnel using AWS Systems Manager (SSM).

### Skills Demonstrated
* **Zero Trust Networking:** Designing "air-gapped" architectures with no public ingress.
* **Identity & Access Management (IAM):** Replacing network trust (IP allow-listing) with identity trust (IAM Roles).
* **Infrastructure as Code:** Using Terraform to create VPCs, NAT Gateways, and Instance Profiles.
* **Systems Manager (SSM):** Configuring agent-based remote management to eliminate the need for SSH keys.

### Architecture
* **The "Invisible" Server:** An EC2 instance residing in a **Private Subnet** with no Public IP.
* **The Firewall:** A Security Group with **0 Inbound Rules** (Deny All) and **Allow All Outbound** (for SSM).
* **The Connection Line:** A **NAT Gateway** in a public subnet allows the server to reach the AWS API without being reachable from the internet.
* **The Key:** An **IAM Instance Profile** granting the server permission to communicate with the SSM service.

### Procedure
---
1. **Configure Provider:** Set up `providers.tf` for AWS `us-east-1`.
2. **Create Identity (IAM):** Define the Trust Policy in `iam.tf` to allow EC2 to assume a role.
3. **Grant Permissions:** Attach the `AmazonSSMManagedInstanceCore` policy to the role.
4. **Create Profile:** Wrap the role in an IAM Instance Profile for the server to "wear."
5. **Build Network:** Create the VPC, Internet Gateway, and Subnets in `network.tf`.
6. **Configure Routing:** Deploy a **NAT Gateway** in the public subnet and route private traffic through it.
7. **Harden Security:** Create a Security Group with **no ingress rules** (blocking port 22).
8. **Launch Compute:** Deploy the EC2 instance in the private subnet using `main.tf`, attaching the IAM profile.
9. **Deploy:** Run `terraform init` and `terraform apply`.

### Verification (The "Zero Trust" Test)
---
To validate the architecture, we attempt to connect to the server. Since there are no open ports, standard SSH fails. We successfully connect using the AWS CLI and the Session Manager plugin.

**Server Access**                              
<img width="329" height="80" alt="image" src="https://github.com/user-attachments/assets/e44de947-8256-4efd-8b5b-c95edae0b235" />

**Internet Connection**
<img width="1052" height="517" alt="image" src="https://github.com/user-attachments/assets/154498f4-2d3a-4bf5-b07f-9bc4944b6764" />


