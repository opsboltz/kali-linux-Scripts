#!/usr/bin/zsh

echo "RUN AS ROOT!"

sleep 1
clear

apt update -y
apt upgrade -y
apt install -y unattended-upgrades
apt install -y neofetch
echo "Basic Updating/Upgrading Done"
sleep 1
neofetch

