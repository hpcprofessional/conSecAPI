#See also: https://docs.tenable.com/tenableio/Content/ContainerSecurity/CSScanner_ImageInspect.htm
#          https://docs.tenable.com/tenableio/Content/Settings/GenerateAPIKey.htm

#NOTES: 
#  *  This script assumes relevant Docker arguments are stored in uncreatively named environment variables:
#     TENABLE_ACCESS_KEY
#     TENABLE_SECRET_KEY
#     IMPORT_REPO_NAME

#Note: A relevant policy needs to be configured for this setting to be useful.
CHECK_POLICY=true

#Here is an example docker image that should allow a quick and easy test of importing
#IMPORT_REPO_NAME="docker.io/hpcprofessional/accurics:latest"
IMPORT_REPO_NAME="my_tcs_repo"

#          ===  Images to consider importing ===
#
#An Older Node.js base image. Has one outdated node.js library
#IMAGE_NAME="library/node:14.19-alpine"
#
#An intentionally insecure docker file. Over 700 vulnerabilities
#https://github.com/ianmiell/bad-dockerfile
IMAGE_NAME="imiell/bad-dockerfile"

#You'll need to authenticate to the Tenable Container Security Docker Image Repository using special credentails
#How to get the credentials are described here: https://docs.tenable.com/tenableio/Content/ContainerSecurity/DownloadCSScanner.htm
#Note that these are not:
# Your Tenable.io login
# The API Access/Secret Key
# (So don't use any of the above)
echo "Please provde Container Security Registry Authentication Credentials:"
docker login tenableio-docker-consec-local.jfrog.io

#Pulling the repo first can avoid certain edge cases including high network latency
#(Also confirms our registry credentials work)
docker pull $IMAGE_NAME

echo "docker save $IMAGE_NAME | docker run -e TENABLE_ACCESS_KEY=\"$TENABLE_ACCESS_KEY\" -e TENABLE_SECRET_KEY=\"$TENABLE_SECRET_KEY\" -e IMPORT_REPO_NAME=\"$IMPORT_REPO_NAME\" -i tenableio-docker-consec-local.jfrog.io/cs-scanner:latest inspect-image $IMAGE_NAME"

docker save $IMAGE_NAME | docker run \
-e TENABLE_ACCESS_KEY="$TENABLE_ACCESS_KEY" \
-e TENABLE_SECRET_KEY="$TENABLE_SECRET_KEY" \
-e IMPORT_REPO_NAME="$IMPORT_REPO_NAME" \
-i tenableio-docker-consec-local.jfrog.io/cs-scanner:latest inspect-image $IMAGE_NAME
