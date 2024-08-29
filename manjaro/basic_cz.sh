#!/usr/bin/env zsh

# Automatically confirm all prompts
yes "A" | pacman -Rns firefox       # Remove Firefox
yes "A" | pacman -S brave-browser   # Install Brave browser
yes "A" | pacman -S discover        # Install Discover
yes "A" | pacman -Rns libpamac-flatpak-plugin  # Remove Flatpak plugin for Pamac
yes "A" | pacman -S krusader         # Install Krusader file manager
yes "A" | pacman -S partitionmanager # Install Partition Manager
yes "A" | pacman -S krename          # Install Krename for batch renaming files
yes "A" | pacman -S signal-desktop   # Install Signal desktop app
yes "A" | pacman -S digicam          # Install DigiKam for managing digital photos
yes "A" | pacman -S ktorrent         # Install KTorrent
yes "A" | pacman -S isoimagewriter   # Install ISO Image Writer
yes "A" | pacman -S knotes           # Install KNotes for note-taking
yes "A" | pacman -S keysmith         # Install Keysmith for managing passwords
yes "A" | pacman -S kdeconnect       # Install KDE Connect for phone and PC integration

# Enable and start fstrim.timer for SSD optimization
systemctl enable fstrim.timer
systemctl start fstrim.timer

# Install TLP for power management
yes "A" | pacman -S tlp
systemctl enable tlp
systemctl start tlp

# Install and configure zram-generator
yes | pacman -S zram-generator
CONFIG_FILE="/etc/systemd/zram-generator.conf"

# Create and write zram configuration file
echo "[zram0]" | tee $CONFIG_FILE > /dev/null
echo "zram-size = ram / 2" | tee -a $CONFIG_FILE > /dev/null  # Set zram size to half of available RAM
echo "compression-algorithm = lz4" | tee -a $CONFIG_FILE > /dev/null  # Set compression algorithm to lz4

# Reload systemd and restart zram setup service
systemctl daemon-reload
systemctl restart systemd-zram-setup@zram0

# Display current zram configuration
zramctl

# Define GRUB configuration file path
GRUB_CFG="/etc/default/grub"

# Backup the current GRUB configuration file
cp $GRUB_CFG ${GRUB_CFG}.bak

# Save new GRUB settings to the configuration file
bash -c "cat > $GRUB_CFG << EOF
# GRUB configuration
GRUB_DEFAULT=0
GRUB_TIMEOUT=1
GRUB_TIMEOUT_STYLE=hidden
GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash noatime discard irqpoll\"
GRUB_CMDLINE_LINUX=\"\"
EOF"

# Update GRUB to apply new configuration
update-grub

yes "A" | pacman -S cockpit
yes "A" | pacman -S cockpit-packagekit
yes "A" | pacman -S cockpit-ostree
yes "A" | pacman -S cockpit-sosreport
yes "A" | pacman -S cockpit-networkmanager
systemctl enable --now cockpit.socket
