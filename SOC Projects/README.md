## 1. System Prep
---
- **OS:** Ubuntu Server 24.04 (CLI)
- **Resources:** Allocated 16GB RAM and 4 CPU cores to the VM
- **Kernel Change:** Increased `vm.max_map_count` to `262144` so the databases (Elasticsearch/OpenSearch) don't crash on startup
- **Networking:** Created a Docker bridge network called `soc-network` so the containers can talk to each other

## 2. Tools Installed
---
I’ve got the full stack running in Docker. Here’s what’s live and which ports they are using:
- **Wazuh (SIEM):** Port `443`. This is the main dashboard for logs and alerts.
<img width="1914" height="938" alt="initial wazuh page" src="https://github.com/user-attachments/assets/9469e909-668d-4713-968f-164cf2e73aa5" />
- **TheHive (Case Management):** Port `9000`. This is where I'll track incidents.
<img width="1919" height="952" alt="initial hive page" src="https://github.com/user-attachments/assets/bfe3ce92-47e7-4816-a834-43d95bbec4b7" />
- **Cortex (Analysis):** Port `9001`. Used by TheHive to scan IPs and files.
<img width="1916" height="942" alt="initial cortex page" src="https://github.com/user-attachments/assets/c2c94eb9-61ba-4bcc-81ce-1b20ffc4a81f" />
- **Shuffle (SOAR):** Port `3001`. This will automate the workflow between Wazuh and TheHive.
<img width="1919" height="935" alt="initial shuffle page" src="https://github.com/user-attachments/assets/3465ecc6-d69e-47d7-8e1e-7968f13fc14c" />
- **Caldera (Red Team):** Port `8888`. For testing attacks against the setup.
<img width="1896" height="891" alt="initial caldera page" src="https://github.com/user-attachments/assets/3e2646e6-1aca-4735-8c72-8a2a5ca93ca1" />
- **MISP (Threat Intel):** Port `8443`. For pulling in known malicious IP/Hash lists.
<img width="1916" height="891" alt="initial misp page" src="https://github.com/user-attachments/assets/8b892ab3-6139-4cc3-acb9-e5822a9345de" />

---
## 3. What I Did
---
1. **Updates:** Ran `apt update && apt upgrade`.
2. **Wazuh Certs:** Ran a script to generate the SSL certificates for the Wazuh indexer.
3. **Deployment:** Ran `docker compose up -d` for each tool.
4. **Verification:** Checked `docker ps` to make sure everything stayed "Up" and didn't reboot due to memory issues.
5. 5. **Agent Enrollment:** Successfully deployed the Wazuh agent on a Windows VM to ingest Sysmon and Security logs.
<img width="1916" height="942" alt="windows connected to wazuh" src="https://github.com/user-attachments/assets/89ecca18-284c-4ee1-9cf9-24752cf574ee" />
6. **Cortex Integration:** Connected Cortex to TheHive via API and enabled analyzers like **VirusTotal** and **AbuseIPDB** for automated observable enrichment
<img width="1916" height="938" alt="cortex configured in hive" src="https://github.com/user-attachments/assets/a07157fb-110b-4b68-948c-0f8bf6165656" />
7. **Wazuh-Shuffle Bridge:** Configured a custom `<integration>` block in `ossec.conf` to forward specific security levels to the Shuffle SOAR webhook.
8. **Threat Intelligence Integration:** Initialized **MISP**, synced global OSINT feeds (abuse.ch, CIRCL), and established a secure API bridge to TheHive for real-time IoC correlation.
<img width="1918" height="943" alt="misp integrated to thehive" src="https://github.com/user-attachments/assets/d37dc1f6-9578-43c0-83e8-4d93a51b21a0" />
9. **Offensive Simulation:** Deployed the **Caldera** framework and successfully "infected" the target Windows VM with the `sandcat` agent to simulate adversary behaviors.
<img width="1910" height="906" alt="windows vm connected to caldera" src="https://github.com/user-attachments/assets/b057517b-68ed-4c93-8879-420ee34216c7" />
10. **Full-Cycle Validation:** Executed an automated **Discovery** operation, successfully triggering the pipeline from initial telemetry in Wazuh to an enriched case in TheHive.
<img width="1902" height="852" alt="wazuh events after caldera discovery attack" src="https://github.com/user-attachments/assets/347dc03d-159b-42a5-8ba0-d0c8c8d998a4" />
<img width="1910" height="894" alt="thehive alerts after caldera discovery attack" src="https://github.com/user-attachments/assets/1a89fcc7-43e4-4c68-9885-1a2673927849" />
---
## 4. Automation Pipeline & SOAR Setup
---
I built a full-cycle automation workflow to handle Windows security events. Here is the breakdown of the pipeline:
### The Pipeline Flow

1. **Telemetry Ingestion:** A Windows event (e.g., Rule `60106` - Windows logon success) is captured by the Wazuh agent and sent to the Manager.
2. **Webhook Trigger:** Wazuh identifies the alert and executes a POST request to the **Shuffle Webhook** at `http://192.168.28.136:3001`.
<img width="1904" height="708" alt="security events in wazuh" src="https://github.com/user-attachments/assets/adfdae8b-09d3-4fab-9ec5-77c6b09aaa00" />
3. **Logic Processing:** Shuffle receives the JSON payload as a `Runtime Argument`.
<img width="586" height="561" alt="workflow logs in shuffle" src="https://github.com/user-attachments/assets/4a718b31-c9d3-47e7-bc4a-9b2fe036a4c1" />
4. **Incident Creation:** Shuffle uses the **HTTP App** to send a POST request to TheHive’s `/api/v1/alert` endpoint, generating a new case for the SOC team.
<img width="1918" height="914" alt="alerts in thehive" src="https://github.com/user-attachments/assets/1035ced4-0b3e-476f-83b6-03b56dfacaa1" />
## 5. Advanced Intelligence & Offensive Testing
---
The project evolved into a proactive security platform by integrating external intelligence and automated attack simulation.
#### Red Team Simulation (Caldera)

I used Caldera to validate my detection capabilities by executing TTPs (Tactics, Techniques, and Procedures) against the environment:

- **Agent Deployment:** Managed the  deployment on Windows via PowerShell to establish an elevated C2 beacon.
- **Live Testing:** Launched the `SOC_Detection_Test_01` using the **Discovery** profile. This triggered multiple Wazuh rules.

#### Threat Intelligence Enrichment (MISP & Cortex)

The system now automatically contextualizes internal alerts against global threats:
- **MISP Correlation:** Configured TheHive to import OSINT data, resulting in a high-priority alert for threats such as **"Black Vine"** (a known cyberespionage group) when correlated indicators were detected.
<img width="1912" height="887" alt="MISP threat intel" src="https://github.com/user-attachments/assets/138486ae-5180-4e54-a1e8-ffb8d861d82b" />
- **Cortex Analyzers:** Enabled automated lookup engines like **VirusTotal** and **AbuseIPDB**.
<img width="1919" height="890" alt="alert observable that can have analyzers run on" src="https://github.com/user-attachments/assets/e840c0d3-0cb5-4e06-8d8c-9d49468c5584" />

## 6. Final Metrics
---
- **Total Alerts Processed:** 200+
- **Detection Latency:** ~15 seconds from attack execution to TheHive alert.
- **Intelligence Sources:** 4 active OSINT feeds (MISP).

## 7. Key Troubleshooting Milestones
---
- **Endpoint Sanitization:** Fixed a malformed `hook_url` that was double-nested, preventing the initial Wazuh-to-Shuffle handshake.
- **Protocol Migration:** Transitioned from HTTPS to **HTTP (Port 9000)** for internal tool communication to bypass SSL certificate handshake overhead in the lab environment.
- **Namespace Resolution:** Corrected the JSON variable mapping from `$webhook_1` to **`$exec`** to match Shuffle's runtime execution argument, ensuring the alert description actually contains the Windows logs.
- **Variable Mapping:** Identified that the missing `full_log` in alerts was due to deeply nested JSON keys in the `$exec.all_fields` path.
- **Admin Privilege Scoping:** Resolved a "Missing Icon" issue in TheHive by identifying that the `VASH` user was an `org-admin` rather than a `platform-admin`, which is required for connector configuration.
- **Docker-in-Docker (DinD) Permissions:** Diagnosed a `JSONDecodeError` in Cortex analyzers by tracing `DockerJobRunnerSrv` warnings. Fixed the worker failure by applying recursive `777` permissions to the `/opt/cortex/jobs` directory to allow containers to write output files.




