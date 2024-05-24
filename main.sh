#!/usr/bin/zsh

# Function to install packages if they are not already installed
install_if_needed() {
  if ! dpkg -s "$1" &>/dev/null; then
    sudo apt-get install -y "$1"
  fi
}

# Check and install 'boxes' if not present
install_if_needed boxes

# Display the Main Menu
echo 'Ｍａｉｎ Ｍｅｎｕ' | boxes -d stone -p a2v1

# Present options to the user
echo "
1. Update/Upgrade
2. Install Applications
3. Configure SSH
4. Configure vsftpd
5. UFW Setup
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
    echo "Edit FTP Config..."
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
    sleep 2
    echo "Complete"

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
  *)
    echo "Invalid option selected. Please choose a valid option."
    ;;
esac
