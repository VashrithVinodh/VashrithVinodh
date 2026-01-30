# Secure Enterprise Network Implementation

**Designed & Configured by:** Vashrith Vinodh
**Tool:** Cisco Packet Tracer 8.x
**Status:** Completed

### Objective

This project utilizes Cisco Packet Tracer to design a resilient, secure enterprise network connecting a Headquarters (HQ) and a Remote Branch via a simulated ISP backbone. The architecture moves beyond basic connectivity to implement "Active Defense" mechanisms. It features VLAN segmentation to isolate server assets, Layer 3 WAN routing for multi-site communication, and edge firewalls (ACLs) to block simulated external threats while permitting legitimate business traffic.

### Skills Learned

* **Network Segmentation:** Designing isolated broadcast domains using VLANs and 802.1Q Trunking to secure sensitive data.
* **Access Control:** Writing Extended Access Control Lists (ACLs) to implement "Default Deny" policies at the network edge.
* **Inter-Network Routing:** Configuring "Router-on-a-Stick" topologies to enable controlled routing between isolated subnets.
* **WAN Architecture:** Deploying Point-to-Point Layer 3 links using `/30` CIDR blocks to simulate ISP connectivity.

### Tools Used

* Cisco Packet Tracer (Simulation)
* Cisco IOS (Command Line Interface)
* Traffic Analysis (ICMP & Simulation Mode)

### Documentation

**The Foundation (VLANs & Segmentation)**

The core of the network is the HQ LAN, designed to prevent lateral movement between departments. I configured the switch with **VLAN 10 (Employees)** and **VLAN 20 (Servers)**. To allow these isolated networks to communicate without purchasing a Layer 3 switch, I implemented a **Router-on-a-Stick** design. The physical router interface was divided into logical sub-interfaces (`g0/0/0.10` and `g0/0/0.20`), creating a gateway for each VLAN while maintaining logical separation.

**The Backbone (ISP & Routing)**

To simulate real-world distance, I constructed a WAN chain connecting the HQ Router to a customized "ISP Router," and finally to a "Branch Router." This required strict IPv4 addressing using **`/30` subnets** (e.g., `10.0.0.0/30`) to minimize IP waste on point-to-point links. Static routing was configured on the edge devices to ensure packets could traverse the simulated public internet.

**The Defense (Firewall & ACLs)**

To transition from passive connectivity to active security, a rogue "Attacker PC" was deployed on the ISP backbone to launch reconnaissance scans. To counter this, I implemented an **Extended Access Control List (ACL)** on the HQ WAN interface. This rule explicitly permits traffic from the authenticated Branch Office (`192.168.30.0/24`) while dropping packets from the attacker (`200.200.200.5`) and relying on an "Implicit Deny" for all other unauthorized traffic.

### Procedure

* **Configure Switching:** Access the HQ Switch CLI to define VLANs 10 & 20 and configure the uplink port as an 802.1Q Trunk.
* **Build the Gateway:** Configure the HQ Router with sub-interfaces using `encapsulation dot1q` to serve as the default gateway for both VLANs.
* **Deploy the WAN:** Physically cable the HQ, ISP, and Branch routers and assign Public IP addresses to the serial/gigabit interfaces.
* **Simulate the Threat:** Connect the Attacker PC to the ISP router and verify it can initially Ping the HQ server (confirming vulnerability).
* **Code the Logic:** Write the Extended ACL (Access List 100) to deny the Attacker IP and permit the Branch subnet.
* **Apply the Shield:** Bind the ACL to the HQ WAN interface in the inbound direction (`ip access-group 100 in`).
* **Verify Defense:** Confirm that pings from the Attacker fail (`Destination unreachable`) while pings from the Branch User succeed.