# Monitoring and Security Scripts for Linux Servers

## Overview

This repository contains two essential scripts designed for Linux servers:

1. **Monitoring System Resources for a Proxy Server**: A Bash script that provides real-time monitoring of various system resources and presents them in a dashboard format. This script allows users to view specific metrics using command-line switches.

2. **Automating Security Audits and Server Hardening**: A modular Bash script that automates security audits and server hardening on Linux servers, ensuring they meet stringent security standards. The script checks for common vulnerabilities and implements recommended hardening measures.

## Table of Contents

1. [Monitoring System Resources for a Proxy Server](#monitoring-system-resources-for-a-proxy-server)
   - [Features](#features)
   - [Installation and Usage](#installation-and-usage)
   - [Command-Line Switches](#command-line-switches)
2. [Automating Security Audits and Server Hardening](#automating-security-audits-and-server-hardening)
   - [Features](#features-1)
   - [Installation and Usage](#installation-and-usage-1)
   - [Customization and Configuration](#customization-and-configuration)
   - [Generating Reports and Alerts](#generating-reports-and-alerts)
3. [Contributing](#contributing)


---

## Monitoring System Resources for a Proxy Server

### Features

- Displays the top 10 applications consuming the most CPU and memory.
- Monitors network statistics, including concurrent connections, packet drops, and data transfer.
- Provides disk usage details and highlights partitions using more than 80% of their capacity.
- Shows system load averages and a breakdown of CPU usage.
- Reports memory usage, including swap memory.
- Monitors active processes and highlights the top processes by CPU and memory usage.
- Checks the status of essential services such as `sshd`, `nginx/apache`, and `iptables`.
- Allows users to view specific parts of the dashboard using command-line switches.

### Installation and Usage

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/ptiwari6239/linux-server-scripts.git
   cd linux-server-scripts
2. **Make the Script Executable:**
   ```bash
   chmod +x monitoring_script.sh
3. **Run the Script:</br>**
    To start monitoring all resources, run:

    ``` bash
        ./monitoring_script.sh
4. **Use Command-Line Switches:</br>**
    To monitor specific parts of the system, use the appropriate command-line switches (e.g., -cpu, -memory)
    ```bash
    ./monitoring_script.sh -cpu

## Command-Line Switches

-  `cpu`: Show CPU usage and load averages.
-   `memory` : Display memory and swap usage.
- `disk`: Show disk usage by mounted partitions. 
- `network`: Monitor network connections, packet drops, and data transfer.
- `services`: Check the status of essential services.
-  `processes`: Display active processes and top resource-consuming processes.


# Automating Security Audits and Server Hardening

## Features
- Audits users and groups, identifies non-standard root users, and checks for weak passwords.
- Scans files and directories for insecure permissions and reports SUID/SGID files.
- Audits running services, checking for unauthorized or misconfigured services.
- Verifies firewall and network security, including IP configurations and open ports.
- Identifies public vs. private IP addresses and ensures sensitive services are not exposed.
- Checks for available security updates and configures automatic updates.
- Monitors logs for suspicious activities such as failed login attempts.
- Implements server hardening steps, including SSH key-based authentication, IPv6 configuration, GRUB security, and firewall rules.
- Provides modularity for custom security checks.
- Generates a summary report of findings and sends alerts for critical issues.

### Installation and Usage

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/ptiwari6239/linux-server-scripts.git
   cd linux-server-scripts
2. **Make the Script Executable:**
   ```bash
   chmod +x security_audit_hardening.sh
3. **Run the Script:</br>**
    To perform a full security audit and apply hardening measures, run:
    ```bash
    sudo ./security_audit_hardening.sh

**Note: Root privileges are required to perform certain actions, such as modifying system configurations and applying hardening measures.</br>**

### Customization and Configuration

1. **Custom Security Checks:**:
- You can define custom security checks in the custom_checks.conf file.
- This file allows you to specify additional checks or modify existing ones based on your organizational policies.
   ```bash
   # Example custom security check
     echo "Checking for outdated packages..."
     dpkg -l | grep -E 'linux-image|linux-headers' | grep -v `uname -r`

2. **Configuration Files:**

- The script may require modifications based on the server environment and specific requirements.
- Review the script and adjust any hard-coded paths or commands to match your server setup.

### Generating Reports and Alerts
- **Report Generation:**
The script generates a summary report of the security audit and hardening process, which is saved to /var/log/security_audit_report.log.
- **Email Alerts:</br>**
If critical vulnerabilities or misconfigurations are found, the script can send email alerts. Ensure you have a mail utility installed and configured on your server (e.g., mail or ssmtp).

To set up email alerts, edit the send_alerts function in the script to specify the recipient email address and SMTP server configuration.

### Contributing
Contributions to this repository are welcome! If you have suggestions for improvements or new features, please open an issue or submit a pull request.

### Steps to Contribute
1. Fork the repository.
2. Create a new branch: git checkout -b feature/YourFeature.
3. Make your changes and commit them: git commit -m 'Add new feature'.
4. Push to the branch: git push origin feature/YourFeature.
5. Open a pull request.
