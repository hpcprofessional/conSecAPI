#!/bin/bash

#The purpose of this script is to download the Tenable Container Security Scanner.
#Username and password are located here: https://cloud.tenable.com/tio/app.html#/settings/cloud-connectors/add/consec_scanner
#
# CONSEC_JFROG_USERNAME=''
# CONSEC_JFROG_PASSWORD=''
#


##          === Double Check a few things ===
EXIT=0

if [ -z "$CONSEC_JFROG_USERNAME" ]; then
  echo "The CONSEC_JFROG_USERNAME environment variable is not set."
  echo "It can be set as an exported environment variable (recommended) or hard coded in this script (not recommended)"
  echo "The value is specific to your Tenable.io credential. More information is here:"
  echo "   https://cloud.tenable.com/tio/app.html#/settings/cloud-connectors/add/consec_scanner"
  echo ""
  EXIT=1
fi

if [ -z "$CONSEC_JFROG_PASSWORD" ]; then
  echo "The CONSEC_JFROG_PASSWORD environment variable is not set."
  echo "It can be set as an exported environment variable (recommended) or hard coded in this script (not recommended)"
  echo "The value is specific to your Tenable.io credential. More information is here:"
  echo "   https://cloud.tenable.com/tio/app.html#/settings/cloud-connectors/add/consec_scanner"
  echo ""
  EXIT=1
fi

if ! command -v docker &> /dev/null
then
  echo "Docker does not seem to be installed on this host"
  EXIT=1
fi

if [[ $(uname -m) != "x86_64" ]]; then
  echo "The Tenable Container Scanner is not supported in an emulated x86_64 environment. (Are you using an ARM-based Mac?)"
  EXIT=1
  echo ""
fi


if [ $EXIT -ne 0 ]; then
  echo "Fatal errors detected"
  echo ""
  exit $EXIT
fi

docker login tenableio-docker-consec-local.jfrog.io -u "$CONSEC_JFROG_USERNAME" -p "$CONSEC_JFROG_PASSWORD"
docker pull tenableio-docker-consec-local.jfrog.io/cs-scanner:latest
