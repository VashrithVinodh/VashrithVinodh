## Objective

This project utilizes Infrastructure as Code to deploy a honeypot in AWS. The system detects unauthorized reconnaissance or data exfiltration attempts on a decoy S3 bucket and triggers automated alerts via SNS. Additionally, all telemetry is ingested into Splunk for threat analysis.
### Skills Learned
- **Detection Engineering:** Designing active defense mechanisms to catch intruders.
- **Infrastructure as Code:** Using Terraform to deploy event-driven security architecture 
- **Log Analysis:** Configuring CloudTrail Data Events to capture object-level access logs.
- **SIEM Integration:** Ingesting AWS telemetry into Splunk for visualization and threat mapping.
### Tools Used
- AWS (S3, CloudTrail, EventBridge, SNS)
- Terraform
- Splunk Enterprise (Log Analysis)

## Documentation

### The Trap (S3 & CloudTrail)
---
The core of this project is a "Decoy" S3 bucket named to attract attackers (finance-payroll-data). Unlike standard buckets, this resource is configured with **CloudTrail Data Events** logging. This ensures that granular API actions, such as GetObject or ListObjects are recorded, even if the access attempt fails due to permissions.
### The Alarm System (EventBridge & SNS)
---
To move from passive logging to active alerting, Amazon EventBridge is configured with a custom event pattern. It filters the CloudTrail stream in real-time for specific access attempts against the trap bucket. When a match is found, it triggers an SNS Topic to immediately dispatch an email alert to the security team (me) containing the raw JSON data.

### Threat Analysis (Splunk)
---
To analyze the source of attacks, the CloudTrail logs are ingested into a local Splunk Enterprise instance using the "Splunk Add-on for AWS". A custom dashboard was built to map the IP addresses of attackers using iplocation and geostats, providing a visual cluster map of threat origins.

### Procedure
---
1. **Configure Provider:** Set up providers.tf with AWS region and version constraints.
2. **Build the Alarm:** Create the SNS Topic and Email Subscription in sns.tf.
3. **Deploy the Trap:** Define the S3 Bucket and enable CloudTrail Data Event logging in s3.tf.
4. **Code the Logic:** Create the EventBridge Rule to match GetObject events and route them to SNS in eventbridge.tf.
5. **Deploy Infrastructure:** Run terraform init and terraform apply.
6. **Verify Alerting:** Confirm the SNS email subscription and trigger the trap using the AWS CLI (aws s3 cp...).
7. **SIEM Integration:** Install Splunk, configure the AWS Add-on with Read-Only IAM credentials, and ingest the CloudTrail logs.
8. **Analysis:** Run queries to visualize the attack data.
