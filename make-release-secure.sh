#!/bin/sh
# make a tgz out of the terraform, modifying the paths to modules beforehand
# --dirname - where to do the worker
# --verison - version for the tgz name
set -e
# set -x
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --dirname) RELEASE_DIR="$2"; shift ;;
        --version) RELEASE_VERSION="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

if [ -z "$RELEASE_DIR" ]; then
  echo "dirname parameter is required"
fi

if [ -z "$RELEASE_VERSION" ]; then
  echo "version parameter is required"
  exit 1
fi

# remove refs/tags/sc- to get the version number (in different tags scenario, not used currently, 2nd if is)
if [[ $RELEASE_VERSION == refs/tags/sc-* ]]; then
  RELEASE_VERSION=${RELEASE_VERSION:13}
elif [[ $RELEASE_VERSION == sc-* ]]; then
  RELEASE_VERSION=${RELEASE_VERSION:3}
fi
OUTPUT_DIR=releases/$RELEASE_DIR
TAR_NAME="secure-cluster-$RELEASE_VERSION.tgz"
TAR_NAME_OPT_OUT="iks-integration-$RELEASE_VERSION.tgz"

echo "RELEASE VERSION: $RELEASE_VERSION"
echo "output directory: $OUTPUT_DIR"
echo "tar name: $TAR_NAME"
echo "opt out tar: $TAR_NAME_OPT_OUT"

mkdir -p $OUTPUT_DIR
cp -r examples/secure-roks-cluster $OUTPUT_DIR
cp -r examples/iks-integration $OUTPUT_DIR
# For secure cluster & opt out right now, modules diretory isn't even needed. If it is, double check the sed'ing is working
# note, gnu sed. if running on mac, set it up first. (or add a '' after -i)
# cp -R modules $OUTPUT_DIR
# sed -i 's#../../modules#./modules#g' $OUTPUT_DIR/*.tf

# tar the files
cd $OUTPUT_DIR/

echo `pwd`
tar -czf ../$TAR_NAME secure-roks-cluster
tar -czf ../$TAR_NAME_OPT_OUT iks-integration