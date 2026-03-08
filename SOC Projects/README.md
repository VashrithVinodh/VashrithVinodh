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
![[initial wazuh page.png]]
- **TheHive (Case Management):** Port `9000`. This is where I'll track incidents.
![[initial hive page.png]]
- **Cortex (Analysis):** Port `9001`. Used by TheHive to scan IPs and files.
![[initial cortex page.png]]
- **Shuffle (SOAR):** Port `3001`. This will automate the workflow between Wazuh and TheHive.
![[initial shuffle page.png]]
- **Caldera (Red Team):** Port `8888`. For testing attacks against the setup.
![[initial caldera page.png]]
- **MISP (Threat Intel):** Port `8443`. For pulling in known malicious IP/Hash lists.
![[initial misp page.png]]
---
## 3. What I Did
---
1. **Updates:** Ran `apt update && apt upgrade`.
2. **Wazuh Certs:** Ran a script to generate the SSL certificates for the Wazuh indexer.
3. **Deployment:** Ran `docker compose up -d` for each tool.
4. **Verification:** Checked `docker ps` to make sure everything stayed "Up" and didn't reboot due to memory issues.
5. 5. **Agent Enrollment:** Successfully deployed the Wazuh agent on a Windows VM to ingest Sysmon and Security logs.
![[windows connected to wazuh.png]]
6. **Cortex Integration:** Connected Cortex to TheHive via API and enabled analyzers like **VirusTotal** and **AbuseIPDB** for automated observable enrichment
![[cortex configured in hive.png]]
7. **Wazuh-Shuffle Bridge:** Configured a custom `<integration>` block in `ossec.conf` to forward specific security levels to the Shuffle SOAR webhook.
8. **Threat Intelligence Integration:** Initialized **MISP**, synced global OSINT feeds (abuse.ch, CIRCL), and established a secure API bridge to TheHive for real-time IoC correlation.
![[misp integrated to thehive.png]]
9. **Offensive Simulation:** Deployed the **Caldera** framework and successfully "infected" the target Windows VM with the `sandcat` agent to simulate adversary behaviors.
![[windows vm connected to caldera.png]]
10. **Full-Cycle Validation:** Executed an automated **Discovery** operation, successfully triggering the pipeline from initial telemetry in Wazuh to an enriched case in TheHive.
![[wazuh events after caldera discovery attack.png]]![[thehive alerts after caldera discovery attack.png]]
---
## 4. Automation Pipeline & SOAR Setup
---
I built a full-cycle automation workflow to handle Windows security events. Here is the breakdown of the pipeline:
### The Pipeline Flow

1. **Telemetry Ingestion:** A Windows event (e.g., Rule `60106` - Windows logon success) is captured by the Wazuh agent and sent to the Manager.
2. **Webhook Trigger:** Wazuh identifies the alert and executes a POST request to the **Shuffle Webhook** at `http://192.168.28.136:3001`.
![[security events in wazuh.png]]
3. **Logic Processing:** Shuffle receives the JSON payload as a `Runtime Argument`.
![[workflow logs in shuffle.png]]
4. **Incident Creation:** Shuffle uses the **HTTP App** to send a POST request to TheHive’s `/api/v1/alert` endpoint, generating a new case for the SOC team.
![[alerts in thehive.png]]

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
![[MISP threat intel.png]]
- **Cortex Analyzers:** Enabled automated lookup engines like **VirusTotal** and **AbuseIPDB**.
![[alert observable that can have analyzers run on.png]]
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




