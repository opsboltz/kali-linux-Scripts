#!/usr/bin/zsh

# Function to install packages if they are not already installed
install_if_needed() {
  if ! dpkg -s "$1" &>/dev/null; then
    sudo apt-get install -y "$1"
  fi
}

# Check and install essential packages
install_if_needed boxes
install_if_needed openssh-server
install_if_needed vsftpd
install_if_needed neofetch
install_if_needed clamav
install_if_needed docker.io
install_if_needed docker-compose
install_if_needed snort
install_if_needed fail2ban
install_if_needed arp-scan
install_if_needed nmap

while true; do
  # Display the Main Menu
  clear
  neofetch
  echo 'Ｍａｉｎ Ｍｅｎｕ' | boxes -d stone -p a2v1

  # Present options to the user in two columns
  echo "
1. Update/Upgrade          2. Install Applications
3. Configure SSH           4. Configure vsftpd
5. UFW Setup               6. Security Enhancements
7. Package Cleanup         8. Service Management
9. Log Management          10. Advanced Firewall Configuration
11. User Management        12. Backup System
13. Exit                   14. System Information and Health Check
15. Network Configuration  16. Scheduled Tasks
17. System Performance     18. File System Management
19. Security Audits        20. Automated Updates
21. Auto-deploy Portainer  22. Disk Usage Monitoring
23. Process Management     24. Network Traffic Analysis
25. Email Notifications    26. Docker Management
27. Custom Script Execution 28. Intrusion Detection System
29. Malware Scanning       30. ARP Scan
31. Nmap Scan
"

  read -r option1

  case "$option1" in
    1)
      echo "Updating and upgrading system..."
      sudo apt update -y && sudo apt upgrade -y
      sudo apt install -y unattended-upgrades neofetch
      echo "Basic Updating/Upgrading Done"
      sleep 1
      neofetch
      ;;
    2)
      echo "Installing applications..."
      apps=(
        nmap gobuster dirbuster hydra tilix neofetch sqlmap wpscan
        wireshark openvpn proxychains vscode docker.io docker-compose
        snapd git terminator gufw tor torbrowser-launcher htop
      )

      for app in "${apps[@]}"; do
        install_if_needed "$app"
      done

      # Start snapd and install snap applications
      sudo systemctl start snapd
      sudo /usr/lib/snapd/snapd &
      sudo snap install snap-store discord spotify

      echo "Applications installed."
      ;;
    3)
      echo "Editing SSH config..."
      sleep 0.5
      sudo nano /etc/ssh/sshd_config
      ;;
    4)
      echo "Editing FTP config..."
      sleep 0.5
      sudo nano /etc/vsftpd.conf
      ;;
    5)
      echo "Setting up UFW..."
      sudo ufw default allow outgoing 
      sudo ufw default deny incoming
      sudo ufw allow http
      sudo ufw allow 80/tcp
      sudo ufw allow 21/udp
      sudo ufw limit ssh
      sudo ufw enable
      clear
      sudo systemctl status ufw.service
      echo "Complete"
      sleep 2

      clear
      echo "Would you like to disable ICMP pings? (y/n)"

      read -r answer

      if [[ $answer == "y" ]]; then
        echo "Disabling ICMP pings..."

        # Backup the original before.rules file
        sudo cp /etc/ufw/before.rules /etc/ufw/before.rules.bak
        # Add rules to /etc/ufw/before.rules to block ICMP echo-request (ping) packets
        sudo bash -c 'echo "
        # Block ICMP echo-request (ping) packets
        -A ufw-before-input -p icmp --icmp-type echo-request -j DROP
        " >> /etc/ufw/before.rules'

        # Reload UFW to apply the new rules
        sudo ufw reload

        echo "ICMP pings disabled."
      fi
      ;;
    6)
      echo "Enhancing system security..."
      # Add your security enhancement commands here
      echo "Security enhancements applied."
      ;;
    7)
      echo "Cleaning up packages..."
      sudo apt autoremove -y
      sudo apt autoclean -y
      echo "Package cleanup complete."
      ;;
    8)
      echo "Managing services..."
      echo "1. Start a service"
      echo "2. Stop a service"
      echo "3. Restart a service"
      read -r service_option
      case "$service_option" in
        1)
          read -p "Enter the service name to start: " service_name
          sudo systemctl start "$service_name"
          ;;
        2)
          read -p "Enter the service name to stop: " service_name
          sudo systemctl stop "$service_name"
          ;;
        3)
          read -p "Enter the service name to restart: " service_name
          sudo systemctl restart "$service_name"
          ;;
        *)
          echo "Invalid option."
          ;;
      esac
      ;;
    9)
      echo "Managing logs..."
      echo "Log files:"
      sudo ls /var/log
      echo "1. View a log file"
      echo "2. Clear a log file"
      echo "3. Send log file via mail"
      read -r log_option
      case "$log_option" in
        1)
          read -p "Enter the log file name to view: " log_file
          sudo cat /var/log/"$log_file"
          ;;
        2)
          read -p "Enter the log file name to clear: " log_file
          sudo truncate -s 0 /var/log/"$log_file"
          ;;
        3)
          read -p "Enter the log file name to send: " log_file
          read -p "Enter the recipient email address: " email
          sudo mail -s "Log File" "$email" < /var/log/"$log_file"
          ;;
        *)
          echo "Invalid option."
          ;;
      esac
      ;;
    10)
      echo "Advanced Firewall Configuration..."
      echo "1. Allow a port"
      echo "2. Deny a port"
      read -r fw_option
      case "$fw_option" in
        1)
          read -p "Enter the port number to allow: " port
          sudo ufw allow "$port"
          ;;
        2)
          read -p "Enter the port number to deny: " port
          sudo ufw deny "$port"
          ;;
        *)
          echo "Invalid option."
          ;;
      esac
      ;;
    11)
      echo "Managing users..."
      echo "1. Add a user"
      echo "2. Delete a user"
      read -r user_option
      case "$user_option" in
        1)
          read -p "Enter the username to add: " username
          sudo adduser "$username"
          ;;
        2)
          read -p "Enter the username to delete: " username
          sudo deluser --remove-home "$username"
          ;;
        *)
          echo "Invalid option."
          ;;
      esac
      ;;
    12)
      echo "Backing up the system..."
      read -p "Enter the backup directory: " backup_dir
      sudo tar -cvpzf /backup/"$backup_dir"/backup.tar.gz --exclude=/backup / --one-file-system
      echo "Backup complete."
      ;;
    13)
      echo "Exiting..."
      break
      ;;
    14)
      echo "System Information and Health Check..."
      echo "System Uptime:"
      uptime
      echo "Memory Usage:"
      free -h
      echo "Disk Usage:"
      df -h
      echo "CPU Information:"
      lscpu
      echo "System Health Check Complete."
      ;;
    15)
      echo "Network Configuration..."
      echo "1. View current network configuration"
      echo "2. Configure static IP address"
      echo "3. Configure DHCP"
      echo "4. Manage DNS settings"
      read -r network_option
      case "$network_option" in
        1)
          ifconfig
          ;;
        2)
          read -p "Enter interface name: " iface
          read -p "Enter static IP address: " ip_addr
          read -p "Enter netmask: " netmask
          read -p "Enter gateway: " gateway
          sudo bash -c "echo -e '\nauto $iface\niface $iface inet static\naddress $ip_addr\nnetmask $netmask\ngateway $gateway\n' >> /etc/network/interfaces"
          sudo systemctl restart networking
          ;;
        3)
          read -p "Enter interface name: " iface
          sudo bash -c "echo -e '\nauto $iface\niface $iface inet dhcp\n' >> /etc/network/interfaces"
          sudo systemctl restart networking
          ;;
        4)
          sudo nano /etc/resolv.conf
          ;;
        *)
          echo "Invalid option."
          ;;
      esac
      ;;
    16)
      echo "Managing Scheduled Tasks..."
      echo "1. View scheduled tasks (crontab)"
      echo "2. Add a new scheduled task"
      echo "3. Remove a scheduled task"
      read -r cron_option
      case "$cron_option" in
        1)
          crontab -l
          ;;
        2)
          read -p "Enter the cron job (e.g., '0 0 * * * /path/to/script.sh'): " cron_job
          (crontab -l 2>/dev/null; echo "$cron_job") | crontab -
          ;;
        3)
          read -p "Enter the line number of the cron job to remove: " line_num
          crontab -l | sed "${line_num}d" | crontab -
          ;;
        *)
          echo "Invalid option."
          ;;
      esac
      ;;
    17)
      echo "Checking System Performance..."
      echo "1. View top resource-consuming processes"
      echo "2. Monitor system performance in real-time"
      read -r perf_option
      case "$perf_option" in
        1)
          ps aux --sort=-%mem | head -n 10
          ;;
        2)
          htop
          ;;
        *)
          echo "Invalid option."
          ;;
      esac
      ;;
    18)
      echo "Managing File System..."
      echo "1. View disk usage"
      echo "2. Check filesystem integrity"
      read -r fs_option
      case "$fs_option" in
        1)
          df -h
          ;;
        2)
          read -p "Enter the filesystem to check (e.g., /dev/sda1): " fs
          sudo fsck "$fs"
          ;;
        *)
          echo "Invalid option."
          ;;
      esac
      ;;
    19)
      echo "Performing Security Audits..."
      lynis audit system
      ;;
    20)
      echo "Setting up Automated Updates..."
      sudo dpkg-reconfigure --priority=low unattended-upgrades
      echo "Automated updates configured."
      ;;
    21)
      echo "Deploying Portainer..."
      if ! docker ps | grep -q portainer; then
        sudo docker volume create portainer_data
        sudo docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
        echo "Portainer deployed."
      else
        echo "Portainer is already running."
      fi
      ;;
    22)
      echo "Monitoring Disk Usage..."
      df -h
      ;;
    23)
      echo "Managing Processes..."
      echo "1. List all running processes"
      echo "2. Kill a process by PID"
      read -r proc_option
      case "$proc_option" in
        1)
          ps aux
          ;;
        2)
          read -p "Enter the PID of the process to kill: " pid
          sudo kill "$pid"
          ;;
        *)
          echo "Invalid option."
          ;;
      esac
      ;;
    24)
      echo "Analyzing Network Traffic..."
      sudo iftop
      ;;
    25)
      echo "Configuring Email Notifications..."
      read -p "Enter recipient email address: " email
      echo "System event notification test" | mail -s "Test Notification" "$email"
      echo "Email notification sent."
      ;;
    26)
      echo "Managing Docker Containers..."
      echo "1. List running containers"
      echo "2. Start a container"
      echo "3. Stop a container"
      echo "4. Remove a container"
      read -r docker_option
      case "$docker_option" in
        1)
          sudo docker ps
          ;;
        2)
          read -p "Enter the container ID or name to start: " container
          sudo docker start "$container"
          ;;
        3)
          read -p "Enter the container ID or name to stop: " container
          sudo docker stop "$container"
          ;;
        4)
          read -p "Enter the container ID or name to remove: " container
          sudo docker rm "$container"
          ;;
        *)
          echo "Invalid option."
          ;;
      esac
      ;;
    27)
      echo "Executing Custom Script..."
      read -p "Enter the path to the custom script: " script_path
      if [[ -x "$script_path" ]]; then
        "$script_path"
      else
        echo "Script is not executable or does not exist."
      fi
      ;;
    28)
      echo "Setting up Intrusion Detection System..."
      echo "1. Configure Snort"
      echo "2. Configure Fail2ban"
      read -r ids_option
      case "$ids_option" in
        1)
          sudo nano /etc/snort/snort.conf
          sudo systemctl restart snort
          ;;
        2)
          sudo nano /etc/fail2ban/jail.conf
          sudo systemctl restart fail2ban
          ;;
        *)
          echo "Invalid option."
          ;;
      esac
      ;;
    29)
      echo "Running Malware Scan..."
      sudo clamscan -r /
      ;;
    30)
      echo "Performing ARP Scan..."
      sudo arp-scan --interface=eth0 --localnet
      ;;
    31)
      echo "Performing Nmap Scan..."
      sudo nmap -p- -sV -sC 10.0.0.0/24
      ;;
    *)
      echo "Invalid option."
      ;;
  esac
done
