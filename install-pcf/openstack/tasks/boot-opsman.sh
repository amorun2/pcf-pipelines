#!/bin/bash

# If we are using a self signed SSL certificate,
# export the location so the openstack-cli uses it.

echo "$PRE_OS_CACERT" > /ca.crt
export OS_CACERT='/ca.crt'

function boot_opsman() {

  OPSMAN_FILE=$(find pivnet-opsman-product/ -name '*.raw')
  if [ -z $OPSMAN_FILE ]; then
    echo "FATAL: We didn't get an opsman image from Pivnet."
    exit 1
  fi

  VERSION=$(echo $OPSMAN_FILE | perl -lane "print \$1 if (/pcf-openstack-(.*?).raw/)")
  IMG_NAME="$OPS_MGR_IMG_NAME-$VERSION"

  echo "Looking for $IMG_NAME in glance."
  openstack image list | grep -q $IMG_NAME
  if [ $? != 0 ]; then 
    echo "$IMG_NAME is not available in glance."
    exit 1
  fi

  # Check for the correct flavor

  echo "Booting OpsMan: $IMG_NAME"
  openstack server create --image $IMG_NAME \
    --flavor m1.xlarge --key-name concourse-key --security-group concourse_sec \
    --nic net-id=infra ops-manager

   if [ $? == 0 ]; then
     sleep 5 # Give openstack a few moments to get the VM organized.
     FLOAT=$( openstack floating ip create $EXTERNAL_NETWORK | \
              grep floating_ip_address | awk '{print $4}' )
     echo "Adding floating IP: $FLOAT to $IMAGE_NAME"
     openstack server add floating ip $IMAGE_NAME $FLOAT
   else
     echo "Failed to boot $IMG_NAME"
     openstack server show $IMG_NAME
   fi
}

boot_opsman
