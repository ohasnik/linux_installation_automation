#!/usr/bin/env bash

# Automatically confirm all prompts and remove/install packages using apt

# Remove Firefox
sudo apt-get remove --purge -y firefox

# Install Brave browser
# Add the Brave repository
sudo apt install -y apt-transport-https curl
sudo curl -fsSLo /usr/share/keyrings/brave-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-core.asc
echo "deb [signed-by=/usr/share/keyrings/brave-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install -y brave-browser

# Install Discover
sudo apt install -y discover

# Remove Flatpak plugin for Pamac
# Note: This is specific to Manjaro/Arch; Flatpak support in apt-based systems differs. Remove if you use similar packages.
sudo apt remove --purge -y gnome-software-plugin-flatpak

# Install Krusader
# Note: Krusader might not be available in standard Ubuntu repositories. Use KDE Backports or build from source if needed.
sudo apt install -y krusader

# Install Partition Manager
sudo apt install -y gparted

# Install Krename
sudo apt install -y krename

# Install Signal desktop
# Signal may not be in the standard repositories. Add the Signal repository and install.
curl -s https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee /etc/apt/sources.list.d/signal-xenial.list
sudo apt update
sudo apt install -y signal-desktop

# Install DigiKam
sudo apt install -y digikam

# Install KTorrent
sudo apt install -y ktorrent

# Install ISO Image Writer
# On Debian/Ubuntu, use GNOME Disk Utility as an alternative
sudo apt install -y gnome-disk-utility

# Install KNotes
sudo apt install -y knotes

# Install Keysmith
# Keysmith might not be available directly in repositories. Check alternatives or build from source.
sudo apt install -y keysmith

# Install KDE Connect
sudo apt install -y kdeconnect

# Enable and start fstrim.timer for SSD optimization
# Note: `fstrim` is generally handled manually on apt-based systems.
sudo fstrim -av

# Install TLP for power management
sudo apt install -y tlp
sudo systemctl enable tlp
sudo systemctl start tlp

# Configure zram
# Install zram-tools (similar functionality to zram-generator)
sudo apt install -y zram-tools

# Configure zram settings
# Configuration is typically handled in /etc/zram-config.conf
sudo bash -c 'cat > /etc/zram-config.conf << EOF
# ZRAM configuration
SIZE=50%  # Adjust size as needed
COMPRESSION_ALGORITHM=lz4
EOF'

# Restart zram service
sudo systemctl restart zram-config

# Define GRUB configuration file path
GRUB_CFG="/etc/default/grub"

# Backup the current GRUB configuration file
sudo cp $GRUB_CFG ${GRUB_CFG}.bak

# Save new GRUB settings to the configuration file
sudo bash -c "cat > $GRUB_CFG << EOF
# GRUB configuration
GRUB_DEFAULT=0
GRUB_TIMEOUT=1
GRUB_TIMEOUT_STYLE=hidden
GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash noatime discard irqpoll\"
GRUB_CMDLINE_LINUX=\"\"
EOF"

# Update GRUB to apply new configuration
sudo update-grub
