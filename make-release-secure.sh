#!/bin/sh
# make a tgz out of the terraform, modifying the paths to modules beforehand
# --dirname - where to do the worker
# --verison - version for the tgz name
set -e
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


OUTPUT_DIR=../releases/$RELEASE_DIR/secure-roks-cluster
TAR_NAME="secure-cluster-v$RELEASE_VERSION.tgz"

echo "output directory: $OUTPUT_DIR"
echo "tar name: $TAR_NAME"

mkdir -p $OUTPUT_DIR
cp -r examples/secure-roks-cluster/ $OUTPUT_DIR
cp -R modules $OUTPUT_DIR
# sed the files
# note, if GNU, we'll need to modify this
sed -i '' 's#../../modules#./modules#g' $OUTPUT_DIR/*.tf
# tar the files
cd $OUTPUT_DIR/..

# chown should only be needed locally so username isn't in tar
chown -R nobody secure-roks-cluster
echo `pwd`
tar -czf ../$TAR_NAME secure-roks-cluster
