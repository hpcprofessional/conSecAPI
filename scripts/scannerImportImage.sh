#See also: https://docs.tenable.com/tenableio/Content/ContainerSecurity/CSScanner_ImageInspect.htm

#NOTES: 
#  *  This script assumes relevant Docker arguments are stored in uncreatively named environment variables:
#     TENABLE_ACCESS_KEY
#     TENABLE_SECRET_KEY
#     IMPORT_REPO_NAME

#Here is an example docker image that should allow a quick and easy test of importing
IMPORT_REPO_NAME="docker.io/hpcprofessional/accurics"
IMAGE_NAME="hpcprofessional:1.0.18beta1"

#Pulling the repo first can avoid certain edge cases including high network latency
docker pull $IMPORT_REPO_NAME

docker save $IMPORT_REPO_NAME | docker run \
-e TENABLE_ACCESS_KEY="$TENABLE_ACCESS_KEY" \
-e TENABLE_SECRET_KEY="$TENABLE_SECRET_KEY" \
-e IMPORT_REPO_NAME="$IMPORT_REPO_NAME" \
-i tenableio-docker-consec-local.jfrog.io/cs-scanner:latest inspect-image $IMAGE_NAME
