#!/bin/bash 

#See also: https://docs.tenable.com/tenableio/Content/ContainerSecurity/CSScanner_RegistryImport.htm
#          https://docs.tenable.com/tenableio/Content/Settings/GenerateAPIKey.htm

#NOTES: 
#  *  This script assumes relevant Docker arguments are stored in uncreatively named environment variables:
#     TENABLE_ACCESS_KEY
#     TENABLE_SECRET_KEY
#     IMPORT_REPO_NAME
#     REGISTRY_URI
#     REGISTRY_USERNAME
#     REGISTRY_PASSWORD
IMPORT_INTERVAL_MINUTES=1440 #24 hours

DEBUG_MODE='false'
#'true': enable debugging
#'false': disable debugging
#
#REPO name provides folder-like organization to your images inside Tenable.cs
IMPORT_REPO_NAME="imported_images"

#          ===  Repositories to consider importing ===
#
#The Tenable Container Scanner's own registry
REGISTRY_URI='tenableio-docker-consec-local.jfrog.io'
REGISTRY_USERNAME="$CONSEC_JFROG_USERNAME"
REGISTRY_PASSWORD="$CONSEC_JFROG_PASSWORD"
IMPORT_REPO_NAME='Tenable'

#When you are ready to import your own registry, please review this documentation:
#  For AWS ECR Registries: https://docs.tenable.com/tenableio/Content/ContainerSecurity/CSScanner_PrepareRegistries.htm#Amazon_Web_Service_(AWS)_Elastic_Container_Registry_(ECR)
#  For Azure registries: https://docs.tenable.com/tenableio/Content/ContainerSecurity/CSScanner_PrepareRegistries.htm#Azure_Registry
#  For GCP GCR registries: https://docs.tenable.com/tenableio/Content/ContainerSecurity/CSScanner_PrepareRegistries.htm#Google_Cloud_Platform_(GCP)_Google_Container_Registry_(GCR)
#
#  Additional documentation:
#
#  https://docs.tenable.com/tenableio/Content/ContainerSecurity/ConfigureRunCSScanner.htm#Environm  
#
#REGISTRY_URI=''
#REGISTRY_USERNAME=''
#REGISTRY_PASSWORD=''
#IMPORT_REPO_NAME='imported_images'

#          === Double Check a few things ===
EXIT=0
if [ -z "$TENABLE_ACCESS_KEY" ]; then
  echo "The TENABLE_ACCESS_KEY environment variable is not set."
  echo "It can be set as an exported environment variable (recommended) or hard coded in this script (not recommended)"
  echo "The value is specific to your Tenable.io credential. More information is here:"
  echo "   https://docs.tenable.com/tenableio/Content/Settings/GenerateAPIKey.htm"
  echo ""
  EXIT=1
fi

if [ -z "$TENABLE_SECRET_KEY" ]; then
  echo "The TENABLE_SECRET_KEY environment variable is not set."
  echo "It can be set as an exported environment variable (recommended) or hard coded in this script (not recommended)"
  echo "The value is specific to your Tenable.io credential. More information is here:"
  echo "   https://docs.tenable.com/tenableio/Content/Settings/GenerateAPIKey.htm"
  echo ""
  EXIT=1
fi

CS_SCANNER=$(docker image list | grep -F 'tenableio-docker-consec-local.jfrog.io/cs-scanner')
if [ -z "$CS_SCANNER" ]; then
  echo "The Tenable Container Security doesn't appear to be in Docker locally."
  echo "You'll need to authenticate to the Tenable Container Security Docker Image Repository using special credentails"
  echo "Please complete the steps described here before continuing:"
  echo "   https://docs.tenable.com/tenableio/Content/ContainerSecurity/DownloadCSScanner.htm"
  echo ""
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

docker run \
-e TENABLE_ACCESS_KEY="$TENABLE_ACCESS_KEY" \
-e TENABLE_SECRET_KEY="$TENABLE_SECRET_KEY" \
-e IMPORT_REPO_NAME="$IMPORT_REPO_NAME" \
-e REGISTRY_URI="$REGISTRY_URI" \
-e REGISTRY_USERNAME="$REGISTRY_USERNAME" \
-e REGISTRY_PASSWORD="$REGISTRY_PASSWORD" \
-e IMPORT_INTERVAL_MINUTES="$IMPORT_INTERVAL_MINUTES" \
-e DEBUG_MODE="$DEBUG_MODE" \
-i tenableio-docker-consec-local.jfrog.io/cs-scanner:latest import-registry  
