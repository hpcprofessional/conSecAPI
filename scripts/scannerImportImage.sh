#See also: https://docs.tenable.com/tenableio/Content/ContainerSecurity/CSScanner_ImageInspect.htm
#          https://docs.tenable.com/tenableio/Content/Settings/GenerateAPIKey.htm

#NOTES: 
#  *  This script assumes relevant Docker arguments are stored in uncreatively named environment variables:
#     TENABLE_ACCESS_KEY
#     TENABLE_SECRET_KEY
#     IMPORT_REPO_NAME

#Here is an example docker image that should allow a quick and easy test of importing
IMPORT_REPO_NAME="docker.io/hpcprofessional/accurics"
IMAGE_NAME="hpcprofessional:1.0.18beta1"

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
docker pull $IMPORT_REPO_NAME

docker save $IMPORT_REPO_NAME | docker run \
-e TENABLE_ACCESS_KEY="$TENABLE_ACCESS_KEY" \
-e TENABLE_SECRET_KEY="$TENABLE_SECRET_KEY" \
-e IMPORT_REPO_NAME="$IMPORT_REPO_NAME" \
-i tenableio-docker-consec-local.jfrog.io/cs-scanner:latest inspect-image $IMAGE_NAME
