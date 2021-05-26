#!/bin/bash

drive_letter=$1
# Partition the drive /dev/sdc.
# Read from standard input provide the options we want.
#  n adds a new partition.
#  p specifies the primary partition type.
#  the following blank line accepts the default partition number.
#  the following blank line accepts the default start sector.
#  the following blank line accepts the default final sector.
#  p prints the partition table.
#  w writes the changes and exits.
sudo fdisk /dev/$drive_letter <<EOF
n
p



p
w
EOF

#Take the mount Directory from User

# Write a file system to the partition.
#  ext4 creates an ext4 filesystem.
#  /dev/sdc1 is the device name.
sudo mkfs -t ext4 /dev/${drive_letter}1

# Create the /uploads directory, which we'll use as our mount point.
sudo mkdir /data

# Attach the disk to the mount point.
sudo mount /dev/${drive_letter}1 /data

# Get the UUID of the new drive, /dev/sdc1, and save it as a variable.
UUID=$(sudo -i blkid | grep '/dev/${drive_letter}1 ' | perl -pe 's/.+([a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}).+/$1/')

# Add the UUID to /etc/fstab so that the drive is mounted automatically after reboot.
# We use the UUID instead of the device name (/dev/sdc1) because the UUID avoids the incorrect 
# disk from being mounted if the OS detects a disk error during boot.
echo "UUID=${UUID}    /$data    ext4    defaults,nofail    1    2" | sudo tee --append /etc/fstab

# Refresh the mount points.
sudo mount -a
