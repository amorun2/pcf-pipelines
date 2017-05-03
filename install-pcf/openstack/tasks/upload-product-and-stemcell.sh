#!/usr/bin/env bash

# If we are using a self signed SSL certificate,
# export the location so the openstack-cli uses it.
function source_certs() {
  if [ -n "$PRE_OS_CACERT" ]; then
    echo "$PRE_OS_CACERT" > /ca.crt
    export OS_CACERT='/ca.crt'
  fi
}

function check_for_opsman() {

  OPSMAN_FILE=$(find pivnet-opsman-product/ -name '*.raw')
  if [ -z $OPSMAN_FILE ]; then
    echo "FATAL: We didn't get an opsman image from Pivnet."
    exit 1
  fi

  VERSION=$(echo $OPSMAN_FILE | perl -lane "print \$1 if (/pcf-openstack-(.*?).raw/)")
  IMG_NAME="$OPS_MGR_IMG_NAME-$VERSION"
  echo "Installing: $IMG_NAME"
     
  openstack image create --disk-format qcow2 --container-format bare \
    --private --file ./$OPSMAN_FILE $IMG_NAME 
}

source_certs
check_for_opsman
