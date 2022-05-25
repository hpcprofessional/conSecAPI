#See also: https://docs.tenable.com/tenableio/Content/ContainerSecurity/CSScanner_ImageInspect.htm
#          https://docs.tenable.com/tenableio/Content/Settings/GenerateAPIKey.htm

#NOTES: 
#  *  This script assumes relevant Docker arguments are stored in uncreatively named environment variables:
#     TENABLE_ACCESS_KEY
#     TENABLE_SECRET_KEY

#          ===  Images to consider importing ===
#
#An Older Node.js base image. Has a small number (1?) outdated node.js librar[y | ies]
#IMAGE_NAME="library/node:14.19-alpine"
#
#An intentionally insecure docker file. Over 700 vulnerabilities at last count
#https://github.com/ianmiell/bad-dockerfile
IMAGE_NAME="imiell/bad-dockerfile"

#REPO name provides folder-like organization to your images inside Tenable.cs
IMPORT_REPO_NAME="my_tcs_repo"

CHECK_POLICY=1
#0: No special output or exit code on violations
#1: This will check policy and simulate a CI/CD use case. 
#Note that for this to work, you need an appropriate policy configured: 
#    https://cloud.tenable.com/tio/app.html#/container-security/dashboard/policies

#          === Double Check a few things ===
EXIT=0
if [ -z "$TENABLE_ACCESS_KEY" ]; then
  echo "The TENABLE_ACCESS_KEY environment variable is not set."
  echo "It can be set as an exported environment variable (recommended) or hard coded in this script (not recommended)"
  echo "The value is specific to your Tenable.io credential. More information is here:"
  echo "   https://docs.tenable.com/tenableio/Content/Settings/GenerateAPIKey.htm"
  EXIT=1
fi

if [ -z "$TENABLE_SECRET_KEY" ]; then
  echo "The TENABLE_SECRET_KEY environment variable is not set."
  echo "It can be set as an exported environment variable (recommended) or hard coded in this script (not recommended)"
  echo "The value is specific to your Tenable.io credential. More information is here:"
  echo "   https://docs.tenable.com/tenableio/Content/Settings/GenerateAPIKey.htm"
  EXIT=1
fi

CS_SCANNER=$(docker image list | grep -F 'tenableio-docker-consec-local.jfrog.io/cs-scanner')
if [ -z "$CS_SCANNER" ]; then
  echo "The Tenable Container Security doesn't appear to be in Docker."
  echo "You'll need to authenticate to the Tenable Container Security Docker Image Repository using special credentails"
  echo "Please complete the steps described here before continuing:"
  echo "   https://docs.tenable.com/tenableio/Content/ContainerSecurity/DownloadCSScanner.htm"
fi

if [ $EXIT -ne 0 ]; then
  echo "Fatal errors detected"
  exit $EXIT
fi

#Pulling the repo first can avoid certain edge cases including high network latency
#(Also confirms our registry credentials work)
docker pull $IMAGE_NAME

#This may be useful for troubleshooting, but shouldn't be enabled by default 
#echo "docker save $IMAGE_NAME | docker run -e TENABLE_ACCESS_KEY=\"$TENABLE_ACCESS_KEY\" -e TENABLE_SECRET_KEY=\"$TENABLE_SECRET_KEY\" -e IMPORT_REPO_NAME=\"$IMPORT_REPO_NAME\" -i tenableio-docker-consec-local.jfrog.io/cs-scanner:latest inspect-image $IMAGE_NAME"

docker save $IMAGE_NAME | docker run \
-e TENABLE_ACCESS_KEY="$TENABLE_ACCESS_KEY" \
-e TENABLE_SECRET_KEY="$TENABLE_SECRET_KEY" \
-e IMPORT_REPO_NAME="$IMPORT_REPO_NAME" \
-e CHECK_POLICY="$CHECK_POLICY" \
-i tenableio-docker-consec-local.jfrog.io/cs-scanner:latest inspect-image $IMAGE_NAME

TCS_EXIT_CODE=$?

echo "The Container Security Scan had an exit code of: $TCS_EXIT_CODE"
