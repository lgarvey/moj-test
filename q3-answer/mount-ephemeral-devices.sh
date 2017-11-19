#!/bin/bash

BASE_METADATA_URL=http://169.254.169.254/2012-01-12/meta-data/block-device-mapping/

# usage: this script can be run via via an instances userdata, or via cloudinit

echo "scanning for ephemeral devices..."
mounted=false

for device in $(curl --silent $BASE_METADATA_URL); do

  # http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html
  # ephemeral disks are mapped as block-device-mapping/ephemeralN
  if [[ $device == ephemeral* ]]; then
    device_id=$(curl --silent $BASE_METADATA_URL/$device)

    # convert to correct device name, e.g. sda becomes /dev/xvda
    # can device names be in different formats? This may not be 
    # correct.
    device="/dev/xvd${device_id: -1}"

    echo "found $device"

    if ! $mounted; then
      # format
      echo "formatting $device"
      mkfs.ext4 $device

      # mount
      echo "mounting $device"
      echo "$device /opt ext4 defaults 0 0" >> /etc/fstab
      mount /opt
      mounted=true
    else
      # NOTE: the question is vague - "and make use of all ephemeral storage devices." - make use how?
      # an option might be to mount various devices inside of /opt or mount as /opt, /opt2, etc.
      # for now I'm just mounting the first device.
      echo "skipping $device as another device has been mounted"
    fi
  fi
done
