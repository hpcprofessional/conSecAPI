#!/bin/bash 

#NOTES: 
#  *  This script assumes your Tenable Access and Secret Keys are stored in uncreatively named environment variables:
#     TENABLE_ACCESS_KEY
#     TENABLE_SECRET_KEY
#  *  This script depends on the following 3rd party package(s):
#     jq - https://stedolan.github.io/jq/
#
#  TODO: Add loops/arrays to get multiple reports, not just the first one

IMAGES=$(curl -s --request GET \
     --url 'https://cloud.tenable.com/container-security/api/v2/images?offset=0&limit=50' \
     --header 'Accept: application/json' \
     --header "X-ApiKeys: accessKey=$TENABLE_ACCESS_KEY; secretKey=$TENABLE_SECRET_KEY;")
RETCODE=$?

if [[ RETCODE -ne 0 ]]; then
       echo "Curl command exited with return code $RETCODE. Sorry!"
       exit 1
fi

if [[ "$IMAGES" =~ .*"repoName".* ]]; then
	REPONAME=$(echo "$IMAGES" | jq -r '.items[0].repoName' 2> /dev/null | jq -Rr @uri)
	NAME=$(echo "$IMAGES" | jq -r '.items[0].name' 2> /dev/null | jq -Rr @uri)
	TAG=$(echo "$IMAGES" | jq -r '.items[0].tag' 2> /dev/null | jq -Rr @uri)

     REPORT=$(curl -s --request GET \
     --url https://cloud.tenable.com/container-security/api/v2/reports/"$REPONAME"/"$NAME"/"$TAG" \
     --header 'Accept: application/json' \
     --header "X-ApiKeys: accessKey=$TENABLE_ACCESS_KEY; secretKey=$TENABLE_SECRET_KEY;")

     #Do whatever you want with the report. We'll go ahead and pretty-print it.
     echo "$REPORT" | jq

else
	echo "The query results didn't look how I expected or were missing"
	exit 2
fi

