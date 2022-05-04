#!/bin/bash 

#See also: https://docs.tenable.com/tenableio/Content/ContainerSecurity/CSScanner_RegistryImport.htm

#NOTES: 
#  *  This script assumes relevant Docker arguments are stored in uncreatively named environment variables:
#     TENABLE_ACCESS_KEY
#     TENABLE_SECRET_KEY
#     IMPORT_REPO_NAME
#     REGISTRY_URI
#     REGISTRY_USERNAME
#     REGISTRY_PASSWORD
IMPORT_INTERVAL_MINUTES=1440 #24 hours


docker run \
-e TENABLE_ACCESS_KEY="$TENABLE_ACCESS_KEY" \
-e TENABLE_SECRET_KEY="$TENABLE_SECRET_KEY" \
-e IMPORT_REPO_NAME="$IMPORT_REPO_NAME" \
-e REGISTRY_URI="$REGISTRY_URI" \
-e REGISTRY_USERNAME="$REGISTRY_USERNAME" \
-e REGISTRY_PASSWORD="$REGISTRY_PASSWORD" \
-e IMPORT_INTERVAL_MINUTES="$IMPORT_INTERVAL_MINUTES" \
-i tenableio-docker-consec-local.jfrog.io/cs-scanner:latest import-registry  
