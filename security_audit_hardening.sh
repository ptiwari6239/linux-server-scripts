#!/bin/bash

# Function to perform user and group audits
audit_users_groups() {
    echo "User and Group Audits:"
    echo "Listing all users and groups on the server..."
    awk -F':' '{ print $1}' /etc/passwd
    awk -F':' '{ print $1}' /etc/group
    
    echo "Checking for users with UID 0..."
    awk -F: '($3 == 0) { print $1 }' /etc/passwd | grep -v "root"
    
    echo "Identifying users without passwords or with weak passwords..."
    cat /etc/shadow | awk -F: '($2 == "" || $2 == "!" || length($2) < 8) {print $1}'
    echo "-------------------------------------------"
}

# Function to perform file and directory permission audits
audit_file_permissions() {
    echo "File and Directory Permissions:"
    echo "Scanning for world-writable files and directories..."
    find / -type f -perm -o+w 2>/dev/null
    find / -type d -perm -o+w 2>/dev/null
    
    echo "Checking for .ssh directories with insecure permissions..."
    find /home/*/.ssh -type d -exec chmod 700 {} \;
    find /home/*/.ssh -type f -exec chmod 600 {} \;
    
    echo "Reporting files with SUID or SGID bits set..."
    find / -perm /6000 -type f 2>/dev/null
    echo "-------------------------------------------"
}

# Function to audit services
audit_services() {
    echo "Service Audits:"
    echo "Listing all running services..."
    systemctl list-units --type=service --state=running
    
    echo "Checking for unnecessary or unauthorized services..."
    # Add list of allowed services, example below
    allowed_services=("sshd" "iptables" "nginx" "ufw")
    for service in $(systemctl list-units --type=service --state=running | awk '{print $1}'); do
        if [[ ! " ${allowed_services[@]} " =~ " ${service} " ]]; then
            echo "Unauthorized service found: $service"
        fi
    done
    
    echo "Ensuring critical services are running and properly configured..."
    for critical_service in "${allowed_services[@]}"; do
        systemctl is-active --quiet $critical_service || echo "$critical_service is not running!"
    done
    
    echo "Checking for services listening on non-standard or insecure ports..."
    netstat -tuln | grep -Ev '(:22|:80|:443)' # Add more ports as necessary
    echo "-------------------------------------------"
}

# Function to check firewall and network security
check_firewall_network_security() {
    echo "Firewall and Network Security:"
    echo "Checking if a firewall is active and configured..."
    systemctl is-active --quiet iptables || echo "Iptables is not running!"
    iptables -L -n
    
    echo "Reporting any open ports and their associated services..."
    netstat -tuln
    
    echo "Checking for IP forwarding or other insecure configurations..."
    sysctl net.ipv4.ip_forward net.ipv6.conf.all.forwarding
    echo "-------------------------------------------"
}

# Function to perform IP and network configuration checks
check_ip_network_configuration() {
    echo "IP and Network Configuration Checks:"
    ip a show | grep 'inet ' | awk '{print $2}' | while read ip; do
        if [[ $ip == 192.168.* || $ip == 10.* || $ip == 172.16.* || $ip == 172.31.* ]]; then
            echo "Private IP: $ip"
        else
            echo "Public IP: $ip"
        fi
    done
    
    echo "Ensuring sensitive services are not exposed on public IPs..."
    netstat -tuln | grep -E '(:22|:80|:443)' # Add more services if needed
    echo "-------------------------------------------"
}

# Function to check for security updates and patches
check_security_updates() {
    echo "Security Updates and Patching:"
    echo "Checking for available security updates..."
    apt update && apt list --upgradable
    
    echo "Configuring automatic security updates..."
    apt install unattended-upgrades -y
    dpkg-reconfigure --priority=low unattended-upgrades
    echo "-------------------------------------------"
}

# Function to monitor logs for suspicious activity
monitor_logs() {
    echo "Log Monitoring:"
    echo "Checking for recent suspicious log entries..."
    grep "Failed password" /var/log/auth.log | tail -10
    echo "-------------------------------------------"
}

# Function to perform server hardening steps
server_hardening() {
    echo "Server Hardening Steps:"
    echo "Implementing SSH key-based authentication..."
    sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    systemctl restart sshd
    
    echo "Disabling IPv6 (if not required)..."
    echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
    echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
    sysctl -p
    
    echo "Securing the GRUB bootloader..."
    grub-mkpasswd-pbkdf2
    echo "Set the password in /etc/grub.d/40_custom"
    update-grub
    
    echo "Configuring iptables with recommended rules..."
    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -P OUTPUT ACCEPT
    iptables -A INPUT -i lo -j ACCEPT
    iptables -A INPUT -p tcp --dport 22 -j ACCEPT # Allow SSH
    iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    iptables-save > /etc/iptables/rules.v4
    echo "-------------------------------------------"
}

# Function to perform custom security checks
custom_security_checks() {
    echo "Custom Security Checks:"
    # Placeholder for custom checks defined in a separate configuration file
    echo "Running custom checks as defined in custom_checks.conf..."
    source custom_checks.conf
    echo "-------------------------------------------"
}

# Function to generate a summary report
generate_report() {
    echo "Generating Summary Report..."
    # Aggregate findings and generate a summary
    echo "Report generated: /var/log/security_audit_report.log"
}

# Function to send alerts if critical vulnerabilities are found
send_alerts() {
    echo "Sending email alerts for critical issues..."
    # Send email using `mail` or other mail utilities
}

# Main function to run all checks and hardening steps
main() {
    audit_users_groups
    audit_file_permissions
    audit_services
    check_firewall_network_security
    check_ip_network_configuration
    check_security_updates
    monitor_logs
    server_hardening
    custom_security_checks
    generate_report
    send_alerts
}

# Run main function
main
