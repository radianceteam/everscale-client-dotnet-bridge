#!/bin/bash

set -e

function usage() {
  echo "Usage: build.sh [-S] [-T] [-s] [-c] [-l] <TON SDK VERSION>"
  exit 1
}

PROJECT_NAME="TON SDK"

DO_CLEAN=0
BUILD_TYPE=Release
BUILD_DIR=build
INSTALL_PREFIX=install

while getopts ":cI" opt; do
  case ${opt} in
    c ) # clean build directories
      DO_CLEAN=1
      ;;
    I ) # skip installation step
      SKIP_INSTALL=1
      ;;
    \? )
      usage
      ;;
  esac
done

shift $(($OPTIND - 1))
TON_SDK_VERSION=$1

if [ "${TON_SDK_VERSION}" = "" ]; then
  usage
fi

CWD=$(pwd)

echo "Building ${PROJECT_NAME}..."
if [ "${DO_CLEAN}" -ne "0" ]; then
  echo "Cleaning up build directory."
  rm -rf build
fi
mkdir -p build
cd build || exit
cmake .. \
  -DTON_SDK_VERSION="${TON_SDK_VERSION}" \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}"
make
make install

echo "${PROJECT_NAME} is successfully installed into ${INSTALL_PREFIX}."
echo "${PROJECT_NAME} build finished."
