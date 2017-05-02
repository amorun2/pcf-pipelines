#!/bin/bash -e


# Necessary to talk to openstack API with self-signed certs.
echo "$PRE_OS_CACERT" > /ca.crt
export OS_CACERT='/ca.crt'


# /tmp/build/get/pcf-openstack-1.10.4.raw
OPSMAN_IMAGE=$(find pivnet-opsman-product/ -name '*.raw')

echo "Using $OPSMAN_IMAGE"
#openstack image create --file $OPSMAN_IMAGE \

echo "Openstack Image list:"
openstack image list


# TODO - figure out where the opsman binary lives right now

# TODO - use some cli to upload that binary into OpenStack

