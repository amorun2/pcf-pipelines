#!/bin/bash -e

# If we are using a self signed SSL certificate,
# export the location so the openstack-cli uses it.

echo "$PRE_OS_CACERT" > /ca.crt
export OS_CACERT='/ca.crt'

function check_for_opsman() {

  OPSMAN_FILE=$(find pivnet-opsman-product/ -name '*.raw')
  if [ -z $OPSMAN_FILE ]; then
    echo "FATAL: We didn't get an opsman image from Pivnet."
    exit 1
  fi

  VERSION=$(echo $OPSMAN_FILE | perl -lane "print \$1 if (/pcf-openstack-(.*?).raw/)")
  IMG_NAME="$OPS_MGR_IMG_NAME-$VERSION"

  echo "Looking for $IMG_NAME in glance."
  openstack image list | grep $IMG_NAME

  echo "Installing: $IMG_NAME"
     
  openstack image create --disk-format qcow2 --container-format bare \
    --private --file ./$OPSMAN_FILE $IMG_NAME 
}

check_for_opsman
