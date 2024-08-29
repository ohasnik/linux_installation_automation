#!/usr/bin/env zsh

# Automatically confirm all prompts
yes | pacman -Rns firefox       # Remove Firefox
yes | pacman -S brave-browser   # Install Brave browser
yes | pacman -S discover        # Install Discover
yes | pacman -Rns libpamac-flatpak-plugin  # Remove Flatpak plugin for Pamac
yes | pacman -S krusader         # Install Krusader file manager
yes | pacman -S partitionmanager # Install Partition Manager
yes | pacman -S krename          # Install Krename for batch renaming files
yes | pacman -S signal-desktop   # Install Signal desktop app
yes | pacman -S digicam          # Install DigiKam for managing digital photos
yes | pacman -S ktorrent         # Install KTorrent
yes | pacman -S isoimagewriter   # Install ISO Image Writer
yes | pacman -S knotes           # Install KNotes for note-taking
yes | pacman -S keysmith         # Install Keysmith for managing passwords
yes | pacman -S kdeconnect       # Install KDE Connect for phone and PC integration

# Enable and start fstrim.timer for SSD optimization
sudo systemctl enable fstrim.timer
sudo systemctl start fstrim.timer

# Install TLP for power management
yes | sudo pacman -S tlp
sudo systemctl enable tlp
sudo systemctl start tlp

# Install and configure zram-generator
yes | pacman -S zram-generator
CONFIG_FILE="/etc/systemd/zram-generator.conf"

# Create and write zram configuration file
echo "[zram0]" | sudo tee $CONFIG_FILE > /dev/null
echo "zram-size = ram / 2" | sudo tee -a $CONFIG_FILE > /dev/null  # Set zram size to half of available RAM
echo "compression-algorithm = lz4" | sudo tee -a $CONFIG_FILE > /dev/null  # Set compression algorithm to lz4

# Reload systemd and restart zram setup service
sudo systemctl daemon-reload
sudo systemctl restart systemd-zram-setup@zram0

# Display current zram configuration
zramctl

# Define GRUB configuration file path
GRUB_CFG="/etc/default/grub"

# Backup the current GRUB configuration file
cp $GRUB_CFG ${GRUB_CFG}.bak

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
